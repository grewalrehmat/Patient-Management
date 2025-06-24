require('dotenv').config();
const { Sequelize } = require('sequelize');
const defineModels = require('./models');

async function waitForDb(sequelize, retries = 10, delay = 2000) {
  for (let i = 0; i < retries; i++) {
    try {
      await sequelize.authenticate();
      console.log(`✅ Connected to DB on attempt ${i + 1}`);
      return;
    } catch (err) {
      console.log(`⏳ DB not ready (attempt ${i + 1}/${retries}), retrying in ${delay}ms…`);
      await new Promise(res => setTimeout(res, delay));
    }
  }
  throw new Error('Unable to connect to the database after multiple attempts.');
}

async function init() {
  const sequelize = new Sequelize(process.env.DATABASE_URL, {
    dialect: 'postgres',
    logging: console.log
  });

  try {
    await waitForDb(sequelize);
    const models = defineModels(sequelize);

    // This will CREATE tables if they don't exist, or ALTER them to match.
    await sequelize.sync({ alter: true });
    console.log('✅ Tables are in sync');

  } catch (err) {
    console.error('❌ DB init failed:', err);
    process.exit(1);
  } finally {
    await sequelize.close();
    console.log('🛑 Init service exiting');
    process.exit(0);
  }
}

init();
