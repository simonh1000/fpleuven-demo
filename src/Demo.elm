module Demo exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import List
import Set exposing (Set)


main : Program String Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- ------------------------------
-- MODEL + Init
-- ------------------------------


type alias Model =
    { members : List Person
    , attendees : Set Int
    , errorMessage : String
    , token : String
    }


{-| A person has a name, location and possibly a photo.
Dummy data with this structure available at dummyData
-}
type alias Person =
    String


{-| on init we need to get data from Meetup
-}
init : String -> ( Model, Cmd Msg )
init token =
    let
        model =
            { members = []
            , attendees = Set.empty
            , errorMessage = ""
            , token = token
            }
    in
        ( model, Cmd.none )



-- ------------------------------
-- UPDATE
-- ------------------------------


{-| Need to handle click events
-}
type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        NoOp ->
            ( model, Cmd.none )



-- ------------------------------
-- VIEW
-- ------------------------------


view : Model -> Html Msg
view model =
    div [ class "container-fluid" ]
        [ h1 [] [ text "Functional Programming Leuven: Elm" ]
        , div [ class "row" ]
            [ div [ class "col-sm-6 people" ] [ h4 [] [ text "Members" ] ]
            , div [ class "col-sm-6" ] [ h4 [] [ text "Attendees" ] ]
            ]
        , viewMembers model
        , text model.errorMessage
        , footer []
            [ a [ href "http://www.freepik.com" ] [ text "Icons made by Freepik" ]
            ]
        ]


viewMembers : Model -> Html Msg
viewMembers model =
    let
        ( attendees, members ) =
            model.members
                |> List.indexedMap (\idx mem -> ( idx, mem ))
                |> List.partition (\( idx, _ ) -> Set.member idx model.attendees)
    in
        div [ class "members row" ]
            [ div [ class "col-sm-6 people" ] [ text "List of members" ]
            , div [ class "col-sm-6 people" ] [ text "List of attendees" ]
            ]


viewPerson : (Int -> Msg) -> ( Int, Person ) -> Html Msg
viewPerson toggler ( idx, person ) =
    div [ class "person card", onClick (toggler idx) ]
        [ img [ src "person.svg", class "card-img-top" ] []
        , div [ class "card-block" ]
            [ h3 [ class "card-title" ] [ text <| toString (idx + 1) ++ " " ++ person ]
            ]
        ]



-- ------------------------------
-- Command
-- ------------------------------


getMemberList : String -> Cmd Msg
getMemberList token =
    Cmd.none


meetupUrl : String -> String
meetupUrl key =
    "https://api.meetup.com/2/members?" ++ query ++ "&access_token=" ++ key


query : String
query =
    "offset=0&format=json&group_urlname=Leuven-Functional-Programming-Meetup&photo-host=public&page=20&order=name&sign=true"



-- ------------------------------
-- JSON Decoding
-- ------------------------------
-- decodeData : Json.Decoder (List Person)
-- decodeData =
--     Json.field "results" <| Json.list decodePerson
--
--
-- decodePerson : Json.Decoder Person
-- decodePerson =
--     Json.map3 Person
--         (Json.field "name" Json.string)
--         (Json.field "city" Json.string)
--         (Json.maybe <| Json.at [ "photo", "photo_link" ] Json.string)
-- Dummy initial data
-- dummyData : List Person
-- dummyData =
--     List.map mkPerson (List.range 1 5)
--
--
-- mkPerson : Int -> Person
-- mkPerson idx =
--     { name = "Fred" ++ toString idx
--     , city = "Leuven"
--     , photo = Nothing
--     }
