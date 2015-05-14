module PomodoroList (TimerLengthButtonsAction(..), Context, view) where

import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import LocalChannel (..)
import Signal
import Time (..)

-- MODEL


type PomodoroType = Pomodoro | Short | Long

type PomodoroListItem =
    { pomodoroType: PomodoroType
    , pomodoroLength: Time
    , pomodoroDate: Date
    }

type alias PomodoroListModel =
    { pomodoroList: List PomodoroListItem
    }

-- UPDATE

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

