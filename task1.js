// 1.1

/**
 * Returns the number of complete days between the two days (absolute value of the amount of days in between)
 * A completed day is considered to be a full 24h time span
 * Assumption - Under this definition of a complete day, day light savings is 
 * not considered for simplicity  
*/
Date.prototype.daysTo = function (d2){
    const millisecondsPerDay = 1000 * 60 * 60 * 24;

    const msDiff = Math.abs(d2.getTime() - this.getTime())  
    return Math.trunc(msDiff/millisecondsPerDay);
}

const d1 = new Date('2024-01-17T03:24:00');
const d2 = new Date('2024-01-19T03:17:00')


const outputDateDiff = (d1, d2) =>{
    console.log(`Days between ${d1.toLocaleString()} and ${d2.toLocaleString()}: ${d1.daysTo(d2)}`)
}

outputDateDiff(d1, d2)
outputDateDiff(d2, d1)
console.log('------------------------------')


// 1.2
// Using inbuilt sort as advised by email
// Sorted ascending
let input = [
    {amount: 10000, quantity: 10}, 
    {amount: 3, quantity: 20}, 
    {amount: 5, quantity: 5},
    {amount: 12, quantity: 2}
]

function orderSalesByTotal(arr){
    let res = arr.map(elem => ({
        ...elem, Total: elem.amount * elem.quantity
    }))

    res.sort((a, b) => a.Total - b.Total)
    return res
}

console.log("Sorted sales array: ")
console.log(orderSalesByTotal(input))
console.log('------------------------------')


// 1.3
// Projected object is the intersection of the source object and the proto Obj
function ObjectProjection(source, proto){
    let res= {}
    // Source is null or primitive. Return as is.
    if (!source || !(source instanceof Object)){
        return source;
    }

    // Proto is null, return source to terminate. 
    if (!proto){
        return {...source};
    }

    for (const key of Object.keys(proto)){
        if (source.hasOwnProperty(key)){
            const nestedSource = source[key]
            const nestedProt = proto[key]

            const nestedRes = ObjectProjection(nestedSource, nestedProt)
            res[key] = nestedRes
        }

    }

    return res;
}

const src = {
    prop11: {
        prop21: 21,
        prop22:{
            prop31: 31,
            prop32: 32
        }
    },
    prop12: 12
}

const proto = {
    prop11: {
        prop22: null
    }
}

console.log("Object projection outputs: ")
console.log(ObjectProjection(src, proto))
console.log(ObjectProjection(proto, src))

