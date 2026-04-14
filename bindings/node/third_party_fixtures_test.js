const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const { test } = require("node:test");

const Parser = require("tree-sitter");

const parser = new Parser();
parser.setLanguage(require("."));

const fixturesDir = path.resolve(__dirname, "../../test/fixtures/third_party");
const cythonExtensions = new Set([".pxd", ".pxi", ".pyx"]);

function collectFixtureFiles(dir) {
  return fs
    .readdirSync(dir, { withFileTypes: true })
    .flatMap((entry) => {
      const fullPath = path.join(dir, entry.name);

      if (entry.isDirectory()) {
        return collectFixtureFiles(fullPath);
      }

      if (entry.isFile() && cythonExtensions.has(path.extname(entry.name))) {
        return [fullPath];
      }

      return [];
    })
    .sort();
}

function formatPosition(position) {
  return `${position.row + 1}:${position.column + 1}`;
}

function summarizeErrors(rootNode) {
  const errors = rootNode.descendantsOfType("ERROR");

  if (errors.length === 0) {
    return "Parser reported an error, but no ERROR node was found.";
  }

  return errors
    .slice(0, 8)
    .map((node) => {
      const snippet = node.text.replace(/\s+/g, " ").slice(0, 100);
      return `- ${formatPosition(node.startPosition)} ${snippet}`;
    })
    .join("\n");
}

const fixtureFiles = collectFixtureFiles(fixturesDir);

test("third-party Cython fixture set is populated", () => {
  assert.notEqual(fixtureFiles.length, 0);
});

for (const fixtureFile of fixtureFiles) {
  const displayPath = path.relative(fixturesDir, fixtureFile);

  test(`parses third-party fixture: ${displayPath}`, () => {
    const source = fs.readFileSync(fixtureFile, "utf8");
    const tree = parser.parse(source);

    assert.equal(
      tree.rootNode.hasError,
      false,
      `Unexpected parse error in ${displayPath}\n${summarizeErrors(tree.rootNode)}`,
    );
  });
}
