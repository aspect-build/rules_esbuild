const fs = require('node:fs');
const process = require('node:process');

console.log("CWD: ", process.cwd())
console.log("examples/data/cow.txt: ", fs.readFileSync('examples/data/cow.txt', 'utf8').trim());
console.log("examples/data/pig.txt: ", fs.readFileSync('examples/data/pig.txt', 'utf8').trim());

try {
    const mainPath = fs.realpathSync('examples/data/main.js')

    // Should throw a not-found error
    console.log("FAIL: should not have esbuild(srcs) accessible to consumer of bundle: ", mainPath)
    process.exit(1)
} catch (e) {
    // Should be a not-found error
}
