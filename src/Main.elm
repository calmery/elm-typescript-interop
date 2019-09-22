module Main exposing (main)

import Model exposing (Model)
import Platform exposing (worker)
import Update exposing (Msg(..), update)


main : Program String Model Msg
main =
    worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }


init : String -> ( Model, Cmd Msg )
init flags =
    ( flags, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
