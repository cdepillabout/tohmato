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
import PlaySound
import TimerLengthButtons

---- MODEL ----

-- The full application state of our todo app.
type alias Model =
    { clock  : Clock.Model
    , player : PlaySound.Model
    }

emptyModel : Model
emptyModel =
    { clock = 10 * second |> Clock.init
    , player = PlaySound.init
    }

---- UPDATE ----

type Action
    = NoOp
    | ClockAction Clock.Action
    | TimerLengthButtonsAction TimerLengthButtons.Action

-- How we update our Model on a given Action?
update : Clock.Action -> (Model, Bool) -> (Model, Bool)
update clockAction (model, oldHasEnded) =
    let (newClock, hasEnded) = Clock.update clockAction model.clock
        newPlaySound = PlaySound.update hasEnded model.player
        newModel = { model | clock <- newClock
                   , player <- newPlaySound }
    in (newModel, hasEnded)

---- VIEW ----

view : Model -> Html
view model =
    let timerLengthButtonsContext = LC.create TimerLengthButtonsAction actionChannel
                                 |> TimerLengthButtons.Context
    in div [ ]
           [ Clock.view model.clock
           , PlaySound.view model.player
           , TimerLengthButtons.view timerLengthButtonsContext
           ]

---- INPUTS ----

-- wire the entire application together
main : Signal Html
main = Signal.map (view << fst) model

-- manage the model of our application over time
model : Signal (Model, Bool)
model = Signal.foldp update
                     initialModel
                     Clock.signal

-- allSignals : Signal Action
-- allSignals = Signal.mergeMany
--                 [ Signal.map ClockAction Clock.signal
--                 , Signal.subscribe actionChannel
--                 ]

initialModel : (Model, Bool)
initialModel = (emptyModel, False)

-- updates from user input
actionChannel : Signal.Channel Action
actionChannel = Signal.channel NoOp

port playSound : Signal ()
port playSound = model
                    |> Signal.map snd
                    |> Signal.dropRepeats
                    |> Signal.keepIf ((==) True) False
                    |> Signal.map (always ())
