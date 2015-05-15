module TimerLengthButtons (Model, TimerLengthButtonsAction(..), Context, getTimerLengthType, init, update, view) where

import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import LocalChannel (..)
import Signal
import Time (..)

import Types (PomodoroType(..))

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
    { clickChannel : LocalChannel TimerLengthButtonsAction
    }

view : Context -> Html
view context =
  div []
    [ button [ onClick (send context.clickChannel ClickPomodoro) ]
             [ text "Pomodoro" ]
    , button [ onClick (send context.clickChannel ClickShortBreak) ]
             [ text "Short Break" ]
    , button [ onClick (send context.clickChannel ClickLongBreak) ]
             [ text "Long Break" ]
    ]
