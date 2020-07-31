/**
 * function: addSpecs
 * repeats the given string a given number of times
 *
 * @param {String} repStr - string to be repeated
 * @param {Integer} num  - the number of times the repStr should be repeated
 */
export function addSpecs(repStr, num) {
  let currStr = '';
  let count = num;
  while (count > 0) {
    currStr += repStr;
    count--;
  }
  return currStr;
}

/**
 * function: splitParams
 * creates an array of elemnets from a comma seperated string of values
 *
 * @param {*} csString- a string of values sperated by a comma
 */
export function splitString(csString) {
  const paramArr = csString.split(',').map((element) => `%${element}%`);
  return paramArr;
}
