module PlaySound (Context, Model, TestSoundAction, init, updateVolume, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode
import Signal
import String
import Time exposing (..)

-- MODEL

type TestSoundAction = TestSound

type alias Model =
    { volume: Float
    }

init : Model
init =
    { volume = 1.0
    }

-- UPDATE

updateVolume : Float -> Model -> Model
updateVolume newVolume model =
    { model | volume <- newVolume }

-- VIEW

type alias Context =
    { clickChannel : Signal.Address TestSoundAction
    , volumeChannel : Signal.Address Float
    }

view : Model -> Context -> Html
view model context =
  -- let node = if model.playing
  --               then audio [ src "sounds/cow.wav"
  --                          , id "audiotag" ]
  --                          []
  --               -- else text "Not Playing"
  --               else div [] []
  let node = audio [ src "sounds/cow.wav"
                   , id "audiotag"
                   ]
                   []
  in div [ class "row" ]
         [ node
         , button [ onClick context.clickChannel TestSound
                  , class "btn btn-block"
                  ]
                  [ text "Play Test Sound" ]
         , input [ on "change" godIHateElm (Signal.message context.volumeChannel)
                 , type' "range"
                 , Html.Attributes.min "0.0"
                 , Html.Attributes.max "1.0"
                 , step "0.01"
                 ]
                 [ ]
         , text <| toString model.volume
         ]

godIHateElm : Json.Decode.Decoder Float
godIHateElm = Json.Decode.map fuckElm Json.Decode.string

hateElm : Float -> Result String Float -> Float
hateElm defaultValue result =
    case result of
        Err _ -> defaultValue
        Ok value -> value

fuckElm : String -> Float
fuckElm str = hateElm (0.5) (String.toFloat str)
