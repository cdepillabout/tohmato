module Clock (Model, init, Action, signal, signalEnded, update, view, Context) where

import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import LocalChannel (..)
import Signal
import Time (..)

-- MODEL

type ClockState = Running | Ended

type alias Model =
    { time: Time
    , state: ClockState
    }

init : Time -> Model
init initialTime =
    { time = initialTime
    , state = Running
    }

-- UPDATE

type Action = Tick Time


update : Action -> Model -> Model
update action model =
  case action of
    Tick tickTime ->
        { model | time <- if model.time <= 1 then 0 else model.time - tickTime
                , state <- if model.time <= 1 then Ended else Running }           

-- VIEW

type alias Context =
    { actionChan : LocalChannel Action
    }

-- viewWithRemoveButton : Context -> Model -> Html
-- viewWithRemoveButton context model =
--   div []
--     [ button [ onClick (send context.actionChan Decrement) ] [ text "-" ]
--     , div [ countStyle ] [ text (toString model) ]
--     , button [ onClick (send context.actionChan Increment) ] [ text "+" ]
--     , div [ countStyle ] []
--     , button [ onClick (send context.removeChan ()) ] [ text "X" ]
--     ]

view : Context -> Model -> Html
view context model =
  div []
    [ (toString model.time ++ toString model.state) |> text ]


countStyle : Attribute
countStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    ]


signal : Signal Action
-- signal = Signal.foldp (\new state -> state  0 (every second)
signal = Signal.map (always (1 * second) >> Tick) (every second)

signalEnded : Signal Model -> Signal Bool
signalEnded modelSignal =
    Signal.map (.state >> (\st -> st == Ended)) modelSignal |> Signal.dropRepeats
