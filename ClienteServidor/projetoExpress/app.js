const express = require('express');

let app = express();

app.get('/', (req, res)=> res.send('Olá mundo!'));
app.get('/contatos', (req, res)=>{ res.send(["contatos1", 'constatos2'])})
app.get('/teste', (req, res) => res.send({nome: "Vinicius", idade: '23'}))

//criando um servidor
app.listen(3000, () => {
    console.log('Servidor rodando na porta 3000')
})