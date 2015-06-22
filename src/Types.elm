module Types (PomodoroType(..), longLength, pomodoroLength, pomodoroTypeToString, shortLength) where

import Time exposing (..)

type PomodoroType = Pomodoro | ShortBreak | LongBreak

pomodoroTypeToString : PomodoroType -> String
pomodoroTypeToString pomodoroType =
    case pomodoroType of
        Pomodoro -> "Pomodoro"
        ShortBreak -> "Short Break"
        LongBreak -> "Long Break"

debugShortTimes : Bool
debugShortTimes = False

pomodoroLength : Time
pomodoroLength = if debugShortTimes then 25 * second else 25 * minute

shortLength : Time
shortLength = if debugShortTimes then 5 * second else 5 * minute

longLength : Time
longLength = if debugShortTimes then 10 * second else 10 * minute
