import * as fs from "fs";
import * as path from "path";
import { findAllDependencies } from "find-elm-dependencies";
import { Elm } from "./Main.elm";

// Constants

const currentDirectory = process.cwd();

const elmJson = JSON.parse(
  fs.readFileSync(path.resolve(currentDirectory, "elm.json"), "utf-8")
);

// Helper Functions

const findMainElm = (sourceDirectories: string[]): string | null => {
  if (sourceDirectories.length === 0) {
    return null;
  }

  const sourceDirectory = path.resolve(currentDirectory, sourceDirectories[0]);
  const probablyMainElmPath = path.resolve(sourceDirectory, "Main.elm");

  if (fs.existsSync(probablyMainElmPath)) {
    return probablyMainElmPath;
  }

  return findMainElm(sourceDirectories.slice(1));
};

// Main

const main = async () => {
  const mainElmPath = findMainElm(elmJson["source-directories"]);

  if (mainElmPath === null) {
    console.error("Main.elm not found");
    return process.exit(1);
  }

  const mainElmRelatedPaths = await findAllDependencies(mainElmPath);
  const elmPaths = [mainElmPath, ...mainElmRelatedPaths];
  const elmContents = elmPaths.map(elmPath => {
    return fs.readFileSync(elmPath, "utf-8");
  });

  const { ports } = Elm.Main.init({ flags: elmJson["elm-version"] });

  ports.parse.send(elmContents);
  ports.parsed.subscribe(console.log);
};

main();

// Exports for tests

export default {};
