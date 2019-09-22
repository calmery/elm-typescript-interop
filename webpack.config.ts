import * as path from "path";
import { Configuration, DefinePlugin } from "webpack";

export default {
  entry: path.resolve(__dirname, "src/index.ts"),
  mode: process.env.NODE_ENV || "development",
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: "elm-webpack-loader",
          options: {
            debug: process.env.NODE_ENV !== "production",
            optimize: process.env.NODE_ENV === "production",
            verbose: true
          }
        }
      },
      {
        test: /\.ts$/,
        loader: "ts-loader"
      }
    ]
  },
  output: {
    path: path.resolve(__dirname, "build"),
    filename: "index.js"
  },
  plugins: [
    new DefinePlugin({
      "process.env": {
        NODE_ENV: process.env.NODE_ENV || "development"
      }
    })
  ],
  resolve: {
    extensions: [".ts", ".js"]
  },
  target: "node"
} as Configuration;
