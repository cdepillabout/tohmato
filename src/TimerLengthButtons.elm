module TimerLengthButtons (Model, TimerLengthButtonsAction(..), Context, getTimerLengthType, init, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal
import Time exposing (..)

import Types exposing (PomodoroType(..))

-- MODEL

type alias Model =
    { pomodoroType: PomodoroType
    }

type TimerLengthButtonsAction = ClickPomodoro | ClickShortBreak | ClickLongBreak

init : Model
init = { pomodoroType = Pomodoro }

getTimerLengthType : Model -> PomodoroType
getTimerLengthType model = model.pomodoroType

-- UPDATE

update : TimerLengthButtonsAction -> Model -> Model
update action model =
  case action of
    ClickPomodoro -> { model | pomodoroType <- Pomodoro }
    ClickShortBreak -> { model | pomodoroType <- ShortBreak }
    ClickLongBreak -> { model | pomodoroType <- LongBreak }


-- VIEW

type alias Context =
    { clickChannel : Signal.Address TimerLengthButtonsAction
    }

createButton : Context -> TimerLengthButtonsAction -> String -> Html
createButton context action buttonText =
    div [ class "col-md-4" ]
        [ button [ onClick context.clickChannel action
                 , class "btn btn-primary btn-block btn-pomodoro-type"
                 ]
                 [ text buttonText ]
        ]

view : Context -> Html
view context =
  div [ class "row" ]
      [ createButton context ClickPomodoro "Pomodoro"
      , createButton context ClickShortBreak "Short Break"
      , createButton context ClickLongBreak "Long Break"
      ]
