module Update exposing (Msg(..), update)

import Elm.Parser as Parser
import Elm.Processing as Processing
import Elm.Syntax.Declaration exposing (Declaration(..))
import Elm.Syntax.Expression exposing (Function, FunctionImplementation)
import Elm.Syntax.File exposing (File)
import Elm.Syntax.Module exposing (Module(..))
import Elm.Syntax.ModuleName exposing (ModuleName)
import Elm.Syntax.Node exposing (Node(..))
import Elm.Syntax.Signature exposing (Signature)
import List.Extra
import Model exposing (Model)
import Parser exposing (DeadEnd)
import Port exposing (parsed)


parse : String -> Result (List DeadEnd) File
parse =
    Parser.parse >> Result.map (Processing.process Processing.init)



-- Helper Functions


getFunctionName : Function -> String
getFunctionName { declaration } =
    case declaration of
        Node _ functionImplementation ->
            case functionImplementation.name of
                Node _ name ->
                    name


getFunctionSignature : Function -> Maybe Signature
getFunctionSignature { signature } =
    Maybe.andThen (\(Node _ s) -> Just s) signature



-- Main Module


getMainFunctionSignature : List (Result (List DeadEnd) File) -> Maybe Signature
getMainFunctionSignature parsedContents =
    List.foldr
        (\parsedContent accumulator ->
            case parsedContent of
                Ok file ->
                    if isMainModule file then
                        case findMainFunctionSignature file of
                            Just signature ->
                                Just signature

                            Nothing ->
                                accumulator

                    else
                        accumulator

                Err _ ->
                    accumulator
        )
        Nothing
        parsedContents


isMainModule : File -> Bool
isMainModule { moduleDefinition } =
    case moduleDefinition of
        Node _ (NormalModule { moduleName }) ->
            case moduleName of
                Node _ [ "Main" ] ->
                    True

                _ ->
                    False

        _ ->
            False


findMainFunctionSignature : File -> Maybe Signature
findMainFunctionSignature { declarations } =
    findMainFunctionSignatureHelper declarations


findMainFunctionSignatureHelper : List (Node Declaration) -> Maybe Signature
findMainFunctionSignatureHelper declarations =
    case declarations of
        declaration :: nextDeclarations ->
            case declaration of
                Node _ (FunctionDeclaration function) ->
                    if getFunctionName function == "main" then
                        getFunctionSignature function

                    else
                        findMainFunctionSignatureHelper nextDeclarations

                _ ->
                    findMainFunctionSignatureHelper nextDeclarations

        [] ->
            Nothing



-- Port Module


getPortFunctionSignatures : List (Result (List DeadEnd) File) -> List Signature
getPortFunctionSignatures parsedContents =
    List.foldr
        (\parsedContent accumulator ->
            case parsedContent of
                Ok file ->
                    accumulator
                        ++ (if isPortModule file then
                                findPortFunctionDeclarations file

                            else
                                []
                           )

                Err _ ->
                    accumulator
        )
        []
        parsedContents


isPortModule : File -> Bool
isPortModule { moduleDefinition } =
    case moduleDefinition of
        Node _ (PortModule _) ->
            True

        _ ->
            False


findPortFunctionDeclarations : File -> List Signature
findPortFunctionDeclarations { declarations } =
    findPortFunctionDeclarationsHelper [] declarations


findPortFunctionDeclarationsHelper : List Signature -> List (Node Declaration) -> List Signature
findPortFunctionDeclarationsHelper portDeclarations declarations =
    case declarations of
        declaration :: nextDeclarations ->
            findPortFunctionDeclarationsHelper
                (case declaration of
                    Node _ (PortDeclaration signature) ->
                        signature :: portDeclarations

                    _ ->
                        portDeclarations
                )
                nextDeclarations

        [] ->
            portDeclarations



-- Update


type Msg
    = Parse (List String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Parse contents ->
            let
                parsedContents =
                    List.map parse contents

                mainFunctionSignature =
                    getMainFunctionSignature parsedContents

                portFunctionSignatures =
                    getPortFunctionSignatures parsedContents
            in
            ( model, parsed [ Debug.toString mainFunctionSignature, Debug.toString portFunctionSignatures ] )
