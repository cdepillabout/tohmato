module PlaySound (Context, Model, TestSoundAction, init, updateVolume, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal
import Time exposing (..)

-- MODEL

type TestSoundAction = TestSound

type alias Model =
    { volume: Float
    }

init : Model
init =
    { volume = 50
    }

-- UPDATE

updateVolume : Float -> Model -> Model
updateVolume newVolume model =
    { model | volume <- newVolume }

-- VIEW

type alias Context =
    { clickChannel : Signal.Address TestSoundAction
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
                   , id "audiotag" ]
                   []
  in div [ class "row" ]
         [ node
         , button [ onClick context.clickChannel TestSound
                  , class "btn btn-block"
                  ]
                  [ text "Play Test Sound" ]
         ]
