const { Client } = require('pg');
const crypto = require('crypto');

const connectionString = process.env.DATABASE_URL || 'postgresql://neondb_owner:npg_wzrm1cWXitC3@ep-falling-bread-adpoy9ql.c-2.us-east-1.aws.neon.tech/neondb?sslmode=require';

const client = new Client({
  connectionString: connectionString,
  ssl: {
    rejectUnauthorized: false // Required for some environments with self-signed SSL certs
  }
});

async function init() {
  try {
    await client.connect();
    console.log('Connected to PostgreSQL successfully.');
    
    // Create feedbacks table with matching schema
    const createTableQuery = `
      CREATE TABLE IF NOT EXISTS feedbacks (
        id VARCHAR(50) PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(255) NOT NULL,
        message TEXT NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
      );
    `;
    await client.query(createTableQuery);
    console.log('Table "feedbacks" created or already exists in Neon database.');
  } catch (err) {
    console.error('Error initializing database:', err);
  } finally {
    await client.end();
  }
}

init();
