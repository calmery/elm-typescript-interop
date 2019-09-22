import { Elm } from "./Main.elm";

export const flags = {
  message: "Hello World"
};

Elm.Main.init({
  flags: JSON.stringify(flags)
});
