import http from 'http';
import pkg from 'pg'; // Importação do pacote inteiro e desestruturação da classe Pool
import fs from 'fs';
import dotenv from 'dotenv';

dotenv.config();

const { Pool } = pkg;

const port = Number(process.env.PORT);
const user = process.env.DB_USER;
const pass = process.env.DB_PASS;
const host = process.env.DB_HOST;
const db_port = process.env.DB_PORT;
const database = process.env.DB_NAME;

const pool = new Pool({
  connectionString: `postgres://${user}:${pass}@${host}:${db_port}/${database}`
});

let scriptExecuted = false;

http.createServer((req, res) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");

  console.log(`Request: ${req.url}`);

  if (req.url === "/api") {
    pool.connect()
      .then(async (client) => {
        try {
          if (!scriptExecuted) {
            const scriptSQL = fs.readFileSync('./sql/script.sql', 'utf-8');
            await client.query(scriptSQL);
            scriptExecuted = true;
            console.log("Script SQL executado com êxito");
          } else {
            console.log("Script SQL já executado");
          }

          const result = (await client.query("SELECT * FROM users")).rows[0];

          res.setHeader("Content-Type", "application/json");
          res.writeHead(200);

          const data = {
            database: true,
            userAdmin: result?.role === "admin"
          };

          res.end(JSON.stringify(data));
        } catch (err) {
          console.error('Erro ao conectar ou executar SQL:', err);
          res.writeHead(500);
          res.end("Erro ao conectar ou executar SQL");
        } finally {
          client.release(); // Libera a conexão de volta para o pool
        }
      })
      .catch(err => {
        console.error('Erro ao conectar ao pool:', err);
        res.writeHead(500);
        res.end("Erro ao conectar ao pool");
      });
  } else {
    res.writeHead(404);
    res.end("Rota não encontrada");
  }
}).listen(port, () => {
  console.log(`Server is listening on port ${port}`);
});
