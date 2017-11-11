module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode as Json
import Http
import List
import Set exposing (Set)


token : String
token =
    "c2551192279670d376393d33b88a16bc"


main : Program Never Model Msg
main =
    Html.program
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


type alias Person =
    { name : String
    , city : String
    , photo : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    let
        model =
            { members = dummyData
            , attendees = Set.empty
            , errorMessage = ""
            , token = token
            }
    in
        ( model, getMemberList model.token )



-- ------------------------------
-- UPDATE
-- ------------------------------


type Msg
    = Attending Int
    | NotAttending Int
    | MemberData (Result Http.Error (List Person))


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Attending idx ->
            ( { model | attendees = Set.insert idx model.attendees }
            , Cmd.none
            )

        NotAttending idx ->
            ( { model | attendees = Set.remove idx model.attendees }
            , Cmd.none
            )

        MemberData data ->
            case data of
                Ok members ->
                    ( { model | members = members }
                    , Cmd.none
                    )

                Err err ->
                    ( { model | errorMessage = toString err }
                    , Cmd.none
                    )



-- ------------------------------
-- VIEW
-- ------------------------------


view : Model -> Html Msg
view model =
    div [ class "container-fluid" ]
        [ h1 [] [ text "Functional Programming Leuven" ]
        , div [ class "row" ]
            [ div [ class "col-sm-6 people" ] [ h4 [] [ text "Members" ] ]
            , div [ class "col-sm-6" ] [ h4 [] [ text "Attendees" ] ]
            ]
        , viewMembers model
        , text model.errorMessage
        , div []
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
        div [ class "row flex-start" ]
            [ div [ class "col-sm-6 people" ] (List.map (viewPerson Attending) members)
            , div [ class "col-sm-6 people" ] (List.map (viewPerson NotAttending) attendees)
            ]


viewPerson : (Int -> Msg) -> ( Int, Person ) -> Html Msg
viewPerson toggler ( idx, person ) =
    div [ class "person card", onClick (toggler idx) ]
        [ case person.photo of
            Just photo ->
                img [ src photo, class "card-img-top" ] []

            Nothing ->
                img [ src "person.svg", class "card-img-top" ] []
        , div [ class "card-block" ]
            [ h3 [ class "card-title" ] [ text <| toString (idx + 1) ++ " " ++ person.name ]
            , p [ class "card-text" ] [ text person.city ]
            ]
        ]



-- ------------------------------
-- Command
-- ------------------------------


getMemberList : String -> Cmd Msg
getMemberList token =
    Http.get (meetupUrl token) decodeData
        |> Http.send MemberData


meetupUrl : String -> String
meetupUrl key =
    "https://api.meetup.com/2/members?" ++ query ++ "&access_token=" ++ key


query : String
query =
    "offset=0&format=json&group_urlname=Leuven-Functional-Programming-Meetup&photo-host=public&page=20&order=name&sign=true"



-- ------------------------------
-- JSON Decoding
-- ------------------------------


decodeData : Json.Decoder (List Person)
decodeData =
    Json.field "results" <| Json.list decodePerson


decodePerson : Json.Decoder Person
decodePerson =
    Json.map3 Person
        (Json.field "name" Json.string)
        (Json.field "city" Json.string)
        (Json.maybe <| Json.at [ "photo", "photo_link" ] Json.string)



-- Dummy initial data


dummyData : List Person
dummyData =
    List.map mkPerson (List.range 1 5)


mkPerson : Int -> Person
mkPerson idx =
    Person ("Fred" ++ toString idx) "Leuven" Nothing
