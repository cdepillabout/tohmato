module Types (PomodoroType(..), pomodoroTypeToString) where

type PomodoroType = Pomodoro | ShortBreak | LongBreak

pomodoroTypeToString : PomodoroType -> String
pomodoroTypeToString pomodoroType =
    case pomodoroType of
        Pomodoro -> "Pomodoro"
        ShortBreak -> "Short Break"
        LongBreak -> "Long Break"
