port module Port exposing (parse, parsed)


port parse : (List String -> msg) -> Sub msg


port parsed : String -> Cmd msg
