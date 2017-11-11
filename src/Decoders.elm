module Decoders exposing (..)

import Json.Decode as Json exposing (..)


decodePerson tp =
    succeed tp
        |> andMap (field "name" string)
        |> andMap (field "city" string)
        |> andMap (maybe <| at [ "photo", "photo_link" ] string)


decodeData tp =
    field "results" <| list (decodePerson tp)


andMap : Decoder a -> Decoder (a -> b) -> Decoder b
andMap =
    -- (a -> (a-> b) -> b) Json.Decode.Decoder a Json.Decode.Decoder b
    Json.map2 (|>)
