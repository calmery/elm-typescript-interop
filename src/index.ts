import * as fs from "fs";
import * as path from "path";
import { findAllDependencies } from "find-elm-dependencies";

export const flags = {
  message: "Hello World"
};

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

const mainElmPath = findMainElm(elmJson["source-directories"]);

if (mainElmPath !== null) {
  findAllDependencies(mainElmPath).then(console.log);
}
