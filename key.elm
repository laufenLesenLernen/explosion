module Key exposing (..)


type Key
    = Space
    | ArrowLeft
    | ArrowRight
    | ArrowUp
    | ArrowDown
    | Unknown


fromCode : Int -> Key
fromCode keyCode =
    case keyCode of
        38 ->
            ArrowUp

        40 ->
            ArrowDown

        32 ->
            Space

        37 ->
            ArrowLeft

        39 ->
            ArrowRight

        _ ->
            Unknown