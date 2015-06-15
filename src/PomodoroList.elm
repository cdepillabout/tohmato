module PomodoroList (Model, init, update, view) where

import Date
import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import List
import LocalChannel (..)
import Signal
import Time (..)

import Types (..)

-- MODEL

maxItems : Int
maxItems = 20

type alias PomodoroListItem =
    { pomodoroType: PomodoroType
    , pomodoroDate: Date.Date
    }

type alias Model =
    { pomodoroList: List PomodoroListItem
    }

init : Model
init = { pomodoroList = [] }

-- UPDATE

updatePomodoroList : PomodoroType -> Time -> Model -> Model
updatePomodoroList pomodoroType currentTime model =
    let newPomodoro = { pomodoroType = pomodoroType
                      , pomodoroDate = Date.fromTime currentTime
                      }
        newPomodoroList = List.take maxItems <| newPomodoro :: model.pomodoroList
    in { model | pomodoroList <- newPomodoroList }

update : Bool -> PomodoroType -> Time -> Model -> Model
update hasEnded pomodoroType currentTime model =
    if hasEnded
       then updatePomodoroList pomodoroType currentTime model
       else model

-- VIEW

view : Model -> Html
view model =
    div [] <| List.map viewOneLine model.pomodoroList

viewOneLine : PomodoroListItem -> Html
viewOneLine item =
  div []
    [ hr [] []
    , div [] [ text <| pomodoroTypeToString item.pomodoroType ]
    , div [] [ text <| viewDate item.pomodoroDate ]
    ]


viewDate : Date.Date -> String
viewDate date =
    let month = viewMonth <| Date.month date
        day = toString <| Date.day date
        dayEnding' = dayEnding <| Date.day date
        hour = toString <| Date.hour date
        min = toString <| Date.minute date
    in month ++ " " ++ day ++ dayEnding' ++ ", " ++ hour ++ ":" ++ min

viewMonth : Date.Month -> String
viewMonth month =
    case month of
        Date.Jan -> "January"
        Date.Feb -> "February"
        Date.Mar -> "March"
        Date.Apr -> "April"
        Date.May -> "May"
        Date.Jun -> "Jun"
        Date.Jul -> "July"
        Date.Aug -> "August"
        Date.Sep -> "September"
        Date.Oct -> "October"
        Date.Nov -> "November"
        Date.Dec -> "December"

dayEnding : Int -> String
dayEnding dayNumber =
    case dayNumber % 10 of
        1 -> "st"
        2 -> "nd"
        3 -> "rd"
        _ -> "th"

