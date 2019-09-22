module Update exposing (Msg(..), update)

import Elm.Parser
import Model exposing (Model)
import Port exposing (parsed)


parse : String -> String
parse content =
    case Elm.Parser.parse content of
        Err error ->
            Debug.toString error

        Ok syntaxTree ->
            Debug.toString syntaxTree


type Msg
    = Parse (List String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Parse contents ->
            ( model, parsed <| List.map parse contents )
