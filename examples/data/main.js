const fs = require('node:fs');
const process = require('node:process');

console.log("CWD: ", process.cwd())
console.log("examples/data/cow.txt: ", fs.readFileSync('examples/data/cow.txt', 'utf8').trim());
console.log("examples/data/pig.txt: ", fs.readFileSync('examples/data/pig.txt', 'utf8').trim());

// TODO(rjs3): enable test once upgraded to rules_js v3
// See https://github.com/aspect-build/rules_js/commit/4fdd18ebba07673077ca2ab4585d06d21805fe81
// try {
//     const mainPath = fs.realpathSync('examples/data/main.js')

//     // Should throw a not-found error
//     console.log("FAIL: should not have esbuild(srcs) accessible to consumer of bundle: ", mainPath)
//     process.exit(1)
// } catch (e) {
//     // Should be a not-found error
// }
