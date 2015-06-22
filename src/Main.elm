module Main where

import Debug exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy, lazy2)
import Json.Decode as Json
import List
import Maybe
import Signal
import String
import Time exposing (..)
import Window

import Clock
import PlaySound
import PomodoroList
import StartStopButtons
import TimerLengthButtons
import Types exposing (pomodoroLength)

---- MODEL ----

-- The full application state of our todo app.
type alias Model =
    { clock  : Clock.Model
    , player : PlaySound.Model
    , countdownHasEnded : Bool
    , timerLengthButtons : TimerLengthButtons.Model
    , pomodoroList : PomodoroList.Model
    }

emptyModel : Model
emptyModel =
    { clock = Clock.init pomodoroLength
    , player = PlaySound.init
    , countdownHasEnded = False
    , timerLengthButtons = TimerLengthButtons.init
    , pomodoroList = PomodoroList.init
    }

---- UPDATE ----

type Action
    = NoOp
    | ClockAction (Time, Clock.Action)
    | TimerLengthButtonsAction TimerLengthButtons.TimerLengthButtonsAction
    | StartStopButtonsAction StartStopButtons.StartStopButtonsAction

-- How we update our Model on a given Action?
update : Action -> Model -> Model
update action model =
    case action of
        ClockAction (currentTime, clockAction) ->
            let oldHasEnded = model.countdownHasEnded
                (newClock, newHasEnded) = Clock.update clockAction model.clock
                newPlaySound = PlaySound.update newHasEnded model.player
                timerLengthType = TimerLengthButtons.getTimerLengthType
                                        model.timerLengthButtons
                newPomodoroList = if newHasEnded == True && oldHasEnded == False
                                     then PomodoroList.update
                                            newHasEnded
                                            timerLengthType
                                            currentTime
                                            model.pomodoroList
                                     else model.pomodoroList
            in { model | clock <- newClock
                       , player <- newPlaySound
                       , countdownHasEnded <- newHasEnded
                       , pomodoroList <- newPomodoroList
                       }

        TimerLengthButtonsAction timerLengthAction ->
            let newClock = Clock.updateTimerLength timerLengthAction model.clock |>
                            Clock.updateClockState StartStopButtons.ClickStart
                newPlayer = PlaySound.init
                newTimerLengthButtons = TimerLengthButtons.update
                                            timerLengthAction
                                            model.timerLengthButtons
            in { model | clock <- newClock
                       , player <- newPlayer
                       , countdownHasEnded <- False
                       , timerLengthButtons <- newTimerLengthButtons
                       }

        StartStopButtonsAction startStopAction ->
            { model | clock <- Clock.updateClockState startStopAction model.clock }

        NoOp -> model

---- VIEW ----

view : Model -> Html
view model =
    -- let timerLengthButtonsContext = LC.create TimerLengthButtonsAction actionMailbox
    --                              |> TimerLengthButtons.Context
    let timerLengthButtonsContext = Signal.forwardTo actionMailbox.address TimerLengthButtonsAction
                                 |> TimerLengthButtons.Context
        -- startStopButtonsContext = LC.create StartStopButtonsAction actionMailbox
        --                          |> StartStopButtons.Context
        startStopButtonsContext = Signal.forwardTo actionMailbox.address StartStopButtonsAction
                                 |> StartStopButtons.Context
    in div [ class "container" ]
           [ div [ class "row" ]
                 [ div [ class "col-md-8" ]
                       [ TimerLengthButtons.view timerLengthButtonsContext
                       , Clock.view model.clock
                       , StartStopButtons.view startStopButtonsContext
                       , PlaySound.view model.player
                       ]
                 , div [ class "col-md-4" ]
                       [ PomodoroList.view model.pomodoroList
                       ]
                 ]
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
                -- , Signal.subscribe actionMailbox
                , actionMailbox.signal
                ]

initialModel : Model
initialModel = emptyModel

-- updates from user input
actionMailbox : Signal.Mailbox Action
actionMailbox = Signal.mailbox NoOp

port playSound : Signal ()
port playSound = model
                    |> Signal.map .countdownHasEnded
                    |> Signal.dropRepeats
                    |> Signal.filter ((==) True) False
                    |> Signal.map (always ())
