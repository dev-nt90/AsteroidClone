extends RigidBody2D


var points : PackedVector2Array
var screen_size : Vector2i
var velocity = Vector2.ZERO
var rotation_speed = 0.0
var asteroid_number : int

@onready var line2d = $Line2D


# Called when the node enters the scene tree for the first time.
func _ready():
    var viewport = get_viewport()
    screen_size = viewport.size
    
    sleeping = false
    can_sleep = false
    
    points = $AsteroidGenerator.generate_random_polygon()
    $Area2D/CollisionPolygon2D.polygon = points
    line2d.points = points  # Set the points for Line2D
    line2d.width = 2.0  # Set the width of the line
    line2d.default_color = Color(1, 1, 1, 1)  # Set the color of the line
    line2d.add_point(points[0]) # this closes the loop by attaching the first point as the last point
    
    # Random initial velocity
    velocity = Vector2(randf_range(-200, 200), randf_range(-200, 200))
    linear_velocity = velocity
    
    # Random rotation speed
    rotation_speed = randf_range(-1.0, 1.0)
    angular_velocity = rotation_speed
    
    $Label.text = str(asteroid_number)
    $Label.add_theme_font_size_override("font_size", 40)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    check_screen_wrap()


func _on_area_2d_body_entered(body):
    print('body entered')
    
func calculate_bounding_box() -> Rect2:
    var min_x = points[0].x
    var max_x = points[0].x
    var min_y = points[0].y
    var max_y = points[0].y

    for point in points:
        if point.x < min_x:
            min_x = point.x
        if point.x > max_x:
            max_x = point.x
        if point.y < min_y:
            min_y = point.y
        if point.y > max_y:
            max_y = point.y

    var size = Vector2(max_x - min_x, max_y - min_y)
    var position = Vector2(min_x, min_y)
    return Rect2(position, size)
    
func check_screen_wrap():
    var viewport_rect = get_viewport().get_visible_rect()
    var bounding_box = calculate_bounding_box()
    var asteroid_size = bounding_box.size / 2
    var wrapped = false

    # Check if the asteroid is fully offscreen on the left or right
    if position.x + asteroid_size.x < 0:
        position.x = viewport_rect.size.x + asteroid_size.x
        wrapped = true
    elif position.x - asteroid_size.x > viewport_rect.size.x:
        position.x = -asteroid_size.x
        wrapped = true

    # Check if the asteroid is fully offscreen on the top or bottom
    if position.y + asteroid_size.y < 0:
        position.y = viewport_rect.size.y + asteroid_size.y
        wrapped = true
    elif position.y - asteroid_size.y > viewport_rect.size.y:
        position.y = -asteroid_size.y
        wrapped = true

    # Reapply velocity and ensure the body doesn't sleep after wrapping
    if wrapped:
        linear_velocity = velocity
        sleeping = false
