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

createButton : Context -> TimerLengthButtonsAction -> String -> Html
createButton context action buttonText =
    div [ class "col-md-4" ]
        [ button [ onClick (send context.clickChannel action)
                 , class "btn btn-default btn-pomodoro-type"
                 -- , style [ ("margin-right", "20px") ]
                 , style [ ("width", "90%") ]
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
