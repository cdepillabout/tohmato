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

createButton : Context -> StartStopButtonsAction -> String -> Html
createButton context action buttonText =
    button [ onClick (send context.clickChannel action)
           , class "btn btn-default btn-start-stop"
           ]
           [ text buttonText ]

view : Context -> Html
view context =
  div []
    [ createButton context ClickStart "Start"
    , createButton context ClickStop "Stop"
    ]

