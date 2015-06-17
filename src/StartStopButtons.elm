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
  div [ class "row" ]
    [ div [ class "col-md-3 col-md-offset-3" ]
          [ button [ onClick (send context.clickChannel ClickStart)
                   , class "btn btn-success btn-block btn-start-stop"
                   ]
                   [ text "Start" ]
          ]
    , div [ class "col-md-3" ]
          [ button [ onClick (send context.clickChannel ClickStop)
                   , class "btn btn-danger btn-block btn-start-stop"
                   ]
                   [ text "Stop" ]
          ]
    ]
