import { app } from './app/server.js';
import { logger } from './app/logging.js';
import { checkDatabasePrimary, checkRedis } from './app/database.js';

const PORT = process.env['PRIMARYPORT'] || 5000;
const DOMAIN = '127.0.0.1';

app.listen(PORT, DOMAIN, async () => {
  const isDatabaseReady = await checkDatabasePrimary();
  const isRedisReady = await checkRedis();
  console.info(isDatabaseReady);
  console.info(isRedisReady);
  logger.info(
    `Database condition : ${isDatabaseReady}, Redis condition : ${isRedisReady}`
  );
  logger.info(`Server berjalan pada ${DOMAIN} dengan port ${PORT}`);
});
