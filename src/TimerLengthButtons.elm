module TimerLengthButtons (Action, Context, view) where

import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import LocalChannel (..)
import Signal
import Time (..)

-- MODEL

-- UPDATE

type Action = ClickPomodoro | ClickShortBreak | ClickLongBreak


-- VIEW

type alias Context =
    { clickChannel : LocalChannel Action
    }

view : Context -> Html
view context =
  div []
    [ button [ onClick (send context.clickChannel ClickPomodoro) ]
             [ text "Pomodoro" ]
    , div [ ] [ ]
    , button [ onClick (send context.clickChannel ClickShortBreak) ]
             [ text "Short Break" ]
    , div [ ] []
    , button [ onClick (send context.clickChannel ClickLongBreak) ]
             [ text "Long Break" ]
    ]
