module PlaySound (Model, init, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal
import Time exposing (..)

-- MODEL

type alias Model =
    { playing: Bool
    }

init : Model
init =
    { playing = False
    }

-- UPDATE

update : Bool -> Model -> Model
update shouldPlay model =
    { model | playing <- shouldPlay }

-- VIEW

view : Model -> Html
view model =
  div [ class "row" ]
      [ audio [ src "sounds/cow.wav"
              , id "audiotag" ]
              []
      ]
