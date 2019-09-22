export namespace Elm {
  namespace Main {
    export interface Application {
      ports: {
        parse: {
          send(contents: string[]): void;
        };
        parsed: {
          subscribe(callback: (contents: string[]) => void): void;
        };
      };
    }

    export function init(options: { flags: string }): Elm.Main.Application;
  }
}
