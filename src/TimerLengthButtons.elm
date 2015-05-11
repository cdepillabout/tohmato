module TimerLength (view) where

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

viewWithRemoveButton : Context -> Html
viewWithRemoveButton context model =
  div []
    [ button [ onClick (send context.actionChan Decrement) ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick (send context.actionChan Increment) ] [ text "+" ]
    , div [ countStyle ] []
    , button [ onClick (send context.removeChan ()) ] [ text "X" ]
    ]
