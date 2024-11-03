// Arquivo: index.js

import pg from 'pg';

const { Pool } = pg;

const pool = new Pool({
  user: 'admin',
  host: 'localhost',
  database: 'teste',
  password: 'admin',
  port: 5432,
});

pool.connect((err, client, release) => {
  if (err) {
    console.error('Erro ao adquirir cliente', err.stack);
    return;
  }
  client.query('SELECT NOW()', (err, result) => {
    release();
    if (err) {
      console.error('Erro ao executar consulta', err.stack);
      return;
    }
    console.log(result.rows);
  });
});
