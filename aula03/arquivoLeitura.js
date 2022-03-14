const fs = require('fs');

const caminhoJson = __dirname + '/arquivo.json'
const caminhoTxt = __dirname + '/arquivo.txt'

const conteudoDoArquivoJson = fs.readFileSync(caminhoJson, 'utf-8');
const conteudoDoArquivoTxt = fs.readFileSync(caminhoTxt, 'utf-8');

console.log("Json: ", conteudoDoArquivoJson);
console.log("Txt: ", conteudoDoArquivoTxt);