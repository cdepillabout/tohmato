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
    , shouldPlay : Bool
    , timerLengthButtons : TimerLengthButtons.Model
    , pomodoroList : PomodoroList.Model
    }

emptyModel : Model
emptyModel =
    { clock = Clock.init pomodoroLength
    , player = PlaySound.init
    , countdownHasEnded = False
    , shouldPlay = False
    , timerLengthButtons = TimerLengthButtons.init
    , pomodoroList = PomodoroList.init
    }

---- UPDATE ----

type Action
    = NoOp
    | ClockAction (Time, Clock.Action)
    | TimerLengthButtonsAction TimerLengthButtons.TimerLengthButtonsAction
    | StartStopButtonsAction StartStopButtons.StartStopButtonsAction
    | TestSoundAction PlaySound.TestSoundAction
    | VolumeChangeAction Float

-- How we update our Model on a given Action?
update : Action -> Model -> Model
update action model =
    case action of
        ClockAction (currentTime, clockAction) ->
            let oldHasEnded = model.countdownHasEnded
                (newClock, newHasEnded) = Clock.update clockAction model.clock
                timerLengthType = TimerLengthButtons.getTimerLengthType
                                        model.timerLengthButtons
                newPomodoroList = if newHasEnded == True && oldHasEnded == False
                                     then PomodoroList.update
                                            newHasEnded
                                            timerLengthType
                                            currentTime
                                            model.pomodoroList
                                     else model.pomodoroList
                newShouldPlay = if newHasEnded == True && oldHasEnded == False
                                   then True
                                   else False
            in { model | clock <- newClock
                       , countdownHasEnded <- newHasEnded
                       , pomodoroList <- newPomodoroList
                       , shouldPlay <- newShouldPlay
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

        TestSoundAction testSoundAction ->
            { model | shouldPlay <- True }

        VolumeChangeAction volume ->
            { model | player <- PlaySound.updateVolume volume model.player }

        NoOp -> model

---- VIEW ----

view : Model -> Html
view model =
    let timerLengthButtonsContext = Signal.forwardTo actionMailbox.address
                                                     TimerLengthButtonsAction
                                        |> TimerLengthButtons.Context
        startStopButtonsContext = Signal.forwardTo actionMailbox.address
                                                   StartStopButtonsAction
                                 |> StartStopButtons.Context
        playSoundClickChannel = Signal.forwardTo actionMailbox.address
                                            TestSoundAction
        playSoundVolumeChannel = Signal.forwardTo actionMailbox.address
                                            VolumeChangeAction
        playSoundContext = PlaySound.Context playSoundClickChannel playSoundVolumeChannel
    in div [ class "container" ]
           [ div [ class "row" ]
                 [ div [ class "col-md-8" ]
                       [ TimerLengthButtons.view timerLengthButtonsContext
                       , Clock.view model.clock
                       , StartStopButtons.view startStopButtonsContext
                       , PlaySound.view model.player playSoundContext
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

port playSound : Signal Float
port playSound = model
                    |> Signal.map getStuff
                    |> Signal.dropRepeats
                    |> Signal.filter (moreStuff) (False, 100)
                    |> Signal.map snd


getStuff : Model -> (Bool, Float)
getStuff model = (model.shouldPlay, model.player.volume)

moreStuff : (Bool, Float) -> Bool
moreStuff (b, _) = b == True

port setVolume : Signal Float
port setVolume = model
                    |> Signal.map (\mod -> mod.player.volume)
                    |> Signal.dropRepeats
