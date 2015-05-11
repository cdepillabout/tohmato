module Clock (Model, init, Action, signal, update, view) where

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

update : Action -> Model -> (Model, Bool)
update action model =
  case action of
    Tick tickTime ->
        let updatedTime = model.time - tickTime
            hasEnded = updatedTime <= 1
            newModel = { model | time <-
                                    if hasEnded then 0 else updatedTime
                               , state <-
                                    if hasEnded then Ended else Running }           
        in (newModel, hasEnded)

-- VIEW

view : Model -> Html
view model =
  div []
    [ (toString model.time ++ toString model.state) |> text ]

signal : Signal Action
signal = Signal.map (always (1 * second) >> Tick) (every second)
