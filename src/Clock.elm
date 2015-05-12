module Clock (Model, init, Action, signal, update, updateTimerLength, view) where

import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import LocalChannel (..)
import Signal
import Time (..)

import TimerLengthButtons (TimerLengthButtonsAction(..))

-- MODEL

type ClockState = Running | Ended

type alias Model =
    { time: Time
    , state: ClockState
    }

init : Time -> Model
init initialTime =
    { time = initialTime
    , state = Running
    }

-- UPDATE

type Action = Tick Time

update : Action -> Model -> (Model, Bool)
update action model =
  case action of
    Tick tickTime ->
        let updatedTime = model.time - tickTime
            hasEnded = updatedTime <= 1
            newModel = { model | time <-
                                    if hasEnded then 0 else updatedTime
                               , state <-
                                    if hasEnded then Ended else Running }           
        in (newModel, hasEnded)

updateTimerLength : TimerLengthButtonsAction -> Model -> Model
updateTimerLength timerLengthButtonsAction model =
    case timerLengthButtonsAction of
        ClickPomodoro -> 25 * second |> init
        ClickShortBreak -> 5 * second |> init
        ClickLongBreak -> 10 * second |> init

-- VIEW

view : Model -> Html
view model =
  div []
    [ (toString model.time ++ toString model.state) |> text ]

signal : Signal Action
signal = Signal.map (always (1 * second) >> Tick) (every second)
