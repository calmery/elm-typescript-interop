module Main exposing (main)

import Model exposing (Model)
import Platform exposing (worker)
import Port exposing (parse)
import Update exposing (Msg(..), update)


main : Program String Model Msg
main =
    worker
        { init = \elmVersion -> ( elmVersion, Cmd.none )
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    parse Parse
