module PlaySound (Model, init, update, view) where

import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import LocalChannel (..)
import Signal
import Time (..)

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
  let node = if model.playing
                then audio [ src "sounds/bell.wav"
                           , id "audiotag" ]
                           [] 
                else text "Not Playing"
  in div [] [node]
