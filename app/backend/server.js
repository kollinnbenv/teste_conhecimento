import http from 'http';
import PG from 'pg';
import fs from 'fs';
import dotenv from 'dotenv';
import cors from 'cors';

dotenv.config();

const port = Number(process.env.PORT);
const user = process.env.DB_USER;
const pass = process.env.DB_PASS;
const host = process.env.DB_HOST;
const db_port = process.env.DB_PORT;
const database = process.env.DB_NAME;

const client = new PG.Client(
  `postgres://${user}:${pass}@${host}:${db_port}/${database}`
);

let successfulConnection = false;
let scriptExecuted = false; 

http.createServer((req, res) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");

  console.log(`Request: ${req.url}`);

  if (req.url === "/api") {
    if (!successfulConnection) {
      client.connect()
        .then(async () => {
          successfulConnection = true;

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
            database: successfulConnection,
            userAdmin: result?.role === "admin"
          };

          res.end(JSON.stringify(data));
        })
        .catch(err => {
          console.error('Erro ao conectar ou executar SQL:', err);
          res.writeHead(500);
          res.end("Erro ao conectar ou executar SQL");
        });
    } else {
      res.setHeader("Content-Type", "application/json");
      res.writeHead(200);

      const data = {
        database: successfulConnection,
        message: "SQL já executado, conectado com êxito"
      };

      res.end(JSON.stringify(data));
    }
  } else {
    res.writeHead(503);
    res.end("Internal Server Error");
  }
}).listen(port, () => {
  console.log(`Server is listening on port ${port}`);
});
