declare module "find-elm-dependencies" {
  export const findAllDependencies: (
    file: string,
    knownDependencies?: string[],
    sourceDirectories?: string[],
    knownFiles?: string[]
  ) => Promise<string[]>;
}
