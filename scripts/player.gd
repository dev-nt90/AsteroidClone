extends CharacterBody2D

@export var rotation_speed = 5
@export var max_velocity = 500
@export var acceleration = 1.5
@export var speed = 10.0

var screen_size : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
    var viewport = get_viewport()
    screen_size = viewport.size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    handle_player_input()

    move_and_slide()
    
    handle_position_wrap()

func handle_player_input():
    if Input.is_action_pressed("left"):
        rotation_degrees += -1 * rotation_speed
    if Input.is_action_pressed("right"):
        rotation_degrees += rotation_speed
        
    var rotation_vector = Vector2(0, speed * acceleration).rotated(rotation)
    
    if Input.is_action_pressed("forward"):
        velocity.y -= rotation_vector.y
        velocity.x += rotation_vector.x * -1 # TODO: why does this need to be inverted?
    if Input.is_action_pressed("back"):
        velocity.y += rotation_vector.y
        velocity.x += rotation_vector.x
        
    velocity.y = clampf(velocity.y, max_velocity * -1, max_velocity)
    velocity.x = clampf(velocity.x, max_velocity * -1, max_velocity)
    if Input.is_action_just_pressed("fire"):
        pass
        
func handle_position_wrap():
    var position = global_position
    if position.x < 0:
        position.x = screen_size.x
    elif position.x > screen_size.x:
        position.x = 0
        
    if position.y < 0:
        position.y = screen_size.y
    elif position.y > screen_size.y:
        position.y = 0
        
    global_position = position
