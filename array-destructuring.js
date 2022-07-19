// let f = ['apples', 'bananas', 'oranges', 'pears'];
// let a = f[0];
// let b = f[1];
// let c = f[2];

function getFruits(){
    return ['apples', 'bananas', 'oranges', 'pears']
}

let [a, b, c] = getFruits();
console.log(a, b,c )

//if only interested in first fruit: 
let [g] = getFruits();
console.log(g)