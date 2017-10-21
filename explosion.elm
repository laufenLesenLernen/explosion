module Explosion exposing (..)

import Random
import Html exposing (Html, text)
import Keyboard exposing (KeyCode)
import Time exposing (Time)
import Key exposing (..)
import AnimationFrame

main = 
    Html.program 
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions}

init : ( Model, Cmd Msg )
init =
    ( defautGame, Cmd.none )

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
    , bombs : List Object
    , explosions: Int}

type Msg
    = TimeUpdate Time
    | KeyDown KeyCode
    | KeyUp KeyCode

-- Update
newBomb : Object
newBomb = 
    { x = 100
    , y = 100
    , vx = 0
    , vy = 0}

-- Note, this can be done with repeat n newBomb, I believe
initializeBombs : Int -> List Object
initializeBombs i = 
    if i <= 1 then
        newBomb :: []
    else
        newBomb :: (initializeBombs (i - 1))

defautGame : Model
defautGame = 
    { character = {x=0, y=0, vx=0, vy=0}
    , bombs = (initializeBombs 2)
    , explosions = 0}

-- are n and m near each other?
-- specifically are they within c of each other?
near : Float -> Float -> Float -> Bool
near n c m =
    m >= n - c && m <= n + c

-- is the ball within a paddle?
within : Object -> Object -> Bool
within obj1 obj2 =
    near obj2.x 20 obj1.x
    && near obj2.y 20 obj1.y

applyPhysics : Float -> Model -> Model
applyPhysics dt ({character, bombs, explosions} as model) =
    let 
        x_ = character.x + character.vx * dt
        y_ = character.y + character.vy * dt
        explosionCount = List.length (List.filter ( within character ) bombs)
    in 
        { model |  
            character = {character | x = x_, y = y_}, 
            explosions = explosionCount + explosions}

updateVelocity : (Float, Float) -> Model -> Model
updateVelocity (vx_, vy_) ({character, bombs} as model) = 
    let
        character_ = { character | vx = vx_, vy = vy_ }
    in
        { model | character = character_ }
            

keyDown : KeyCode -> Model -> Model
keyDown keyCode model =
    case Key.fromCode keyCode of
        ArrowLeft -> 
            updateVelocity (-1, 0) model

        ArrowRight -> 
            updateVelocity (1, 0) model 

        ArrowUp -> 
            updateVelocity (0, 1) model

        ArrowDown -> 
            updateVelocity (0, -1) model

        _ -> model

keyUp : KeyCode -> Model -> Model
keyUp keyCode model = 
    case Key.fromCode keyCode of
        ArrowLeft -> 
            updateVelocity (0, 0) model

        ArrowRight -> 
            updateVelocity (0, 0) model

        ArrowUp ->
            updateVelocity (0, 0) model

        ArrowDown -> 
            updateVelocity (0, 0) model

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