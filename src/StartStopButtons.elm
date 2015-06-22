module StartStopButtons (StartStopButtonsAction(..), Context, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal
import Time exposing (..)

-- MODEL

-- UPDATE

type StartStopButtonsAction = ClickStart | ClickStop


-- VIEW

type alias Context =
    { clickChannel : Signal.Address StartStopButtonsAction
    }

view : Context -> Html
view context =
  div [ class "row" ]
    [ div [ class "col-md-3 col-md-offset-3" ]
          [ button [ onClick context.clickChannel ClickStart
                   , class "btn btn-success btn-block btn-start-stop"
                   ]
                   [ text "Start" ]
          ]
    , div [ class "col-md-3" ]
          [ button [ onClick context.clickChannel ClickStop
                   , class "btn btn-danger btn-block btn-start-stop"
                   ]
                   [ text "Stop" ]
          ]
    ]
