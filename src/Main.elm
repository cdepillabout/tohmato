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
import StartStopButtons
import TimerLengthButtons

---- MODEL ----

-- The full application state of our todo app.
type alias Model =
    { clock  : Clock.Model
    , player : PlaySound.Model
    , countdownHasEnded : Bool
    }

emptyModel : Model
emptyModel =
    { clock = 10 * second |> Clock.init
    , player = PlaySound.init
    , countdownHasEnded = False
    }

---- UPDATE ----

type Action
    = NoOp
    | ClockAction Clock.Action
    | TimerLengthButtonsAction TimerLengthButtons.TimerLengthButtonsAction
    | StartStopButtonsAction StartStopButtons.StartStopButtonsAction

-- How we update our Model on a given Action?
update : Action -> Model -> Model
update action model =
    case action of
        ClockAction clockAction ->
            let (newClock, hasEnded) = Clock.update clockAction model.clock
                newPlaySound = PlaySound.update hasEnded model.player
            in { model | clock <- newClock
                       , player <- newPlaySound
                       , countdownHasEnded <- hasEnded }

        TimerLengthButtonsAction timerLengthAction ->
            let newClock = Clock.updateTimerLength timerLengthAction model.clock
                newPlayer = PlaySound.init
            in { model | clock <- newClock
                       , player <- newPlayer
                       , countdownHasEnded <- False }

        StartStopButtonsAction startStopAction ->
            { model | clock <- Clock.updateClockState startStopAction model.clock }

        NoOp -> model

---- VIEW ----

view : Model -> Html
view model =
    let timerLengthButtonsContext = LC.create TimerLengthButtonsAction actionChannel
                                 |> TimerLengthButtons.Context
        startStopButtonsContext = LC.create StartStopButtonsAction actionChannel
                                 |> StartStopButtons.Context
    in div [ ]
           [ TimerLengthButtons.view timerLengthButtonsContext
           , Clock.view model.clock
           , StartStopButtons.view startStopButtonsContext
           , PlaySound.view model.player
           ]

---- INPUTS ----

-- wire the entire application together
main : Signal Html
main = Signal.map view model

-- manage the model of our application over time
model : Signal Model
model = Signal.foldp update
                     initialModel
                     allSignals

allSignals : Signal Action
allSignals = Signal.mergeMany
                [ Signal.map ClockAction Clock.signal
                , Signal.subscribe actionChannel
                ]

initialModel : Model
initialModel = emptyModel

-- updates from user input
actionChannel : Signal.Channel Action
actionChannel = Signal.channel NoOp

port playSound : Signal ()
port playSound = model
                    |> Signal.map .countdownHasEnded
                    |> Signal.dropRepeats
                    |> Signal.keepIf ((==) True) False
                    |> Signal.map (always ())
