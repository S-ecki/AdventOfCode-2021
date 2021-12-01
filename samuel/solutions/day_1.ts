import * as fs from 'fs';
import path from "path";

const res = fs.readFileSync(path.resolve(__dirname, "../inputs/day_1.txt"), "utf-8");
const inputArr = res.split("\n").map(number => +number);

/**
 * Part 1
 * @param input
 */
function solutionPart1(input: number[]) {
    let counter = 0;
    input.slice(1).forEach((number, index) => {
        if (input[index] < number) {
            counter++;
        }
    })
    return counter;
}

console.log("Solution Part 1: ", solutionPart1(inputArr));

/**
 * Part 2
 * @param input
 */
function solutionPart2(input: number[]) {
    let counter = 0;
    let currentValues:number[] = input.slice(0,3);
    let prevMeasurement = Infinity;
    input.forEach((number) => {
        const currentMeasurement = currentValues.reduce((a,b) => a+b)
        if (currentMeasurement > prevMeasurement) {
            counter++
        }
        currentValues = currentValues.slice(1);
        currentValues.push(number);
        prevMeasurement = currentMeasurement;
    })
    if (currentValues.reduce((a,b) => a+b) > prevMeasurement) {
        counter++
    }
    return counter;
}

console.log("Solution Part 2: ", solutionPart2(inputArr));