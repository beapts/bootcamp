let dobro = (numero) => numero*2;

let triplo = (numero) => numero*3;

let aplicar = (numero, funcao) => funcao(numero);


function somar (a, b) {
    return a + b;
}

function subtrair (a, b) {
    return a - b;
}

function multiplicar (a, b) {
    return a * b;
}

function dividir (a, b) {
    return a / b;
}

function calculadora (a, b, operacao){
    return operação (a, b);
}


function adicionarHttp (url){
    return "http://"+ url
}

function processar (array, funcao){
    let arrayfinal = []
    for (let i = 0; i < array.length; i++){
        arrayfinal.push(funcao(array[i]))
    }
    return arrayfinal
}

let array = ['teste', 'teste2', 'teste3']
console.log(processar(array,adicionarHttp))