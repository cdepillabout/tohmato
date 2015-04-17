module Main where

import Debug (..)
import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import Html.Lazy (lazy, lazy2)
import Json.Decode as Json
import List
import LocalChannel as LC
import Maybe
import Signal
import String
import Time (..)
import Window

import Clock

---- MODEL ----

-- The full application state of our todo app.
type alias Model =
    { clock      : Clock.Model
    }

emptyModel : Model
emptyModel =
    { clock = 10 * second |> Clock.init
    }


---- UPDATE ----

-- A description of the kinds of actions that can be performed on the model of
-- our application. See the following post for more info on this pattern and
-- some alternatives: http://elm-lang.org/learn/Architecture.elm
type Action
    = NoOp
    | ClockAction Clock.Action
    | ClockEnded

-- How we update our Model on a given Action?
update : Action -> Model -> Model
update action model =
    case action of
      NoOp -> model

      ClockAction clockAction -> 
          { model | clock <- Clock.update clockAction model.clock }

      ClockEnded -> log "got clock ended update" model

---- VIEW ----

view : Model -> Html
view model =
    let context = Clock.Context (LC.create ClockAction actionChannel)
    in div
      [ class "todomvc-wrapper" ]
      [ Clock.view context model.clock ]

---- INPUTS ----

-- wire the entire application together
main : Signal Html
main = Signal.map view model

-- manage the model of our application over time
model : Signal Model
model = let x = Signal.foldp update initialModel allSignals
            y = withTimerEnds x
        in Signal.foldp update initialModel (Signal.merge allSignals y)

allSignals : Signal Action
allSignals = Signal.mergeMany
                [ Signal.map ClockAction Clock.signal
                , Signal.subscribe actionChannel
                ]

withTimerEnds : Signal Model -> Signal Action
withTimerEnds modelSignal = Signal.map
                    (always ClockEnded)
                    (Clock.signalEnded (Signal.map (.clock) modelSignal))

initialModel : Model
-- initialModel = Maybe.withDefault emptyModel getStorage
initialModel = emptyModel

-- updates from user input
actionChannel : Signal.Channel Action
actionChannel = Signal.channel NoOp

-- port focus : Signal String
-- port focus =

-- interactions with localStorage to save the model
-- port getStorage : Maybe Model

-- port setStorage : Signal Model
-- port setStorage = model
