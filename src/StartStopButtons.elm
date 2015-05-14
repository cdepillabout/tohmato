module StartStopButtons (StartStopButtonsAction(..), Context, view) where

import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import LocalChannel (..)
import Signal
import Time (..)

-- MODEL

-- UPDATE

type StartStopButtonsAction = ClickStart | ClickStop


-- VIEW

type alias Context =
    { clickChannel : LocalChannel StartStopButtonsAction
    }

view : Context -> Html
view context =
  div []
    [ button [ onClick (send context.clickChannel ClickStart) ]
             [ text "Start" ]
    , button [ onClick (send context.clickChannel ClickStop) ]
             [ text "Stop" ]
    ]

