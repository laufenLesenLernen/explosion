module Game exposing (..)

import Html exposing (Html, text)
import Html.App as Html
import Keyboard exposing (KeyCode)
import AnimationFrame
import Time exposing (Time)
import Key exposing (..)

main = 
    Html.program 
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions}

init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )

-- Model
(gameWidth, gameHeight) = (600, 400)
(halfWidth, halfHeight) = (300, 200)

type alias Object =
    { x : Float
    , y : Float
    , vx : Float
    , vy : Float }

type alias Model = 
    {character : Object
    , bombs : List Object}

type Msg
    = TimeUpdate Time
    | KeyDown KeyCode
    | KeyUp KeyCode

-- Update
newBomb : Object
newBomb = 
    { x = (Random.float -halfWidth halfWidth)
    , y = (Random.float -halfHeight halfHeight)
    , vx = 0
    , vy = 0}

-- Note, this can be done with repeat n newBomb, I believe
initializeBombs Int -> List Object
initializeBombs i objList = 
    if i <= 1 then
        newBomb :: []
    else
        newBomb :: (initializeBombs i - 1)

defautGame : Model
defautGame = 
    { character = {x=0, y=0, vx=0, vy=0}
    , bombs = (initializeBombs (Random.int 1 6))}

-- are n and m near each other?
-- specifically are they within c of each other?
near : Float -> Float -> Float -> Bool
near n c m =
    m >= n - c && m <= n + c

applyPhysics Time -> Model -> Model
applyPhysics dt ({character, bombs} as model) =
    let 
        newX = character.x + vx * dt
        newY = character.y + vy * dt

    in 
        { model |  character = {character | x = newX, y = newY}}

keyDown : KeyCode -> Model -> Model
keyDown keyCode model =
    case Key.fromCode keyCode of
        ArrowLeft -> updateVelocity (-1, 0) model
        ArrowRight -> updateVelocity (1, 0) model 
        ArrowUp -> updateVelocity (0, 1) model
        ArrowDown -> updateVelocity (0, -1) model
        _ -> model

keyUp : KeyCode -> Model -> Model
keyUp keyCode model = 
    case Key.fromCode keyCode of
        ArrowLeft -> updateVelocity (0, 0) model
        ArrowRight -> updateVelocity (0, 0) model
        ArrowUp -> updateVelocity (0, 0) model
        ArrowDown -> updateVelocity (0, 0) model
        _ -> model

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimeUpdate dt ->
            ( applyPhysics dt model, Cmd.none )

        KeyDown keyCode ->
            ( keyDown keyCode model, Cmd.none )

        KeyUp keyCode ->
            ( keyUp keyCode model, Cmd.none )

-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
        [ AnimationFrame.diffs TimeUpdate
        , Keyboard.downs KeyDown
        , Keyboard.ups KeyUp
        ]

-- View

view : Model -> Html msg
view model =
    text (toString model)

