import winston from 'winston';
const { combine, timestamp, json } = winston.format;
const logger = winston.createLogger({
  level: 'info',
  format: combine(
    timestamp({
      format: 'YYYY-MM-DD hh:mm:ss.SSS A', // 2022-01-25 03:23:10.350 PM
    }),
    json()
  ),
  transports: [new winston.transports.Console({})],
});

export { logger };
