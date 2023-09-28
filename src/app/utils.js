import moment from 'moment';

const camelCaseConvert = (message) => {
  const value = message.replace(/\w+/g, function (w) {
    return w[0].toUpperCase() + w.slice(1).toLowerCase();
  });
  return value;
};

const generateId = () => {
  const idLength = 8;
  const characters = '0123456789';
  let randomId = '';

  for (let i = 0; i < idLength; i++) {
    const randomIndex = Math.floor(Math.random() * characters.length);
    randomId += characters.charAt(randomIndex);
  }

  return parseInt(randomId);
};

const saveUpdateInnerObject = (extractDatabase, extractInput) => {
  for (let inner = 0; inner < Object.keys(extractDatabase).length; inner++) {
    let innerKeyObject = Object.keys(extractDatabase)[inner];
    if (
      extractInput[innerKeyObject] === undefined ||
      extractInput[innerKeyObject] === null ||
      extractInput[innerKeyObject] === ''
    ) {
      extractInput[innerKeyObject] = '';
    }
  }
  return extractInput;
};

const saveUpdate = (dataInput, dataDatabase) => {
  for (let index = 0; index < Object.keys(dataDatabase).length; index++) {
    let keyObject = Object.keys(dataDatabase)[index];
    if (typeof dataInput[keyObject] === 'object') {
      const extractDatabase = JSON.parse(dataDatabase[keyObject]);
      const extractInput = dataInput[keyObject];
      const resultInnerObject = saveUpdateInnerObject(
        extractDatabase,
        extractInput
      );
      dataInput[keyObject] = resultInnerObject;
    } else if (
      dataInput[keyObject] === undefined ||
      dataInput[keyObject] === null ||
      dataInput[keyObject] === ''
    ) {
      dataInput[keyObject] = dataDatabase[keyObject];
    }
  }
  return dataInput;
};

export { camelCaseConvert, generateId, saveUpdate };
