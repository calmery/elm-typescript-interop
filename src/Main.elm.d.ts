export namespace Elm {
  namespace Main {
    export interface Application {
      ports: {};
    }

    export function init(options: { flags: string }): Elm.Main.Application;
  }
}
