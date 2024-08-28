extends Node2D

@export var num_points : int = 100
@export var min_radius : float = 180
@export var max_radius : float = 200

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func generate_random_polygon() -> PackedVector2Array:
    var points = PackedVector2Array()
    var angle_step = 2 * PI / self.num_points
    
    for i in range(num_points):
        var angle = angle_step * i
        var radius = randf_range(self.min_radius, self.max_radius)
        var x = cos(angle) * radius
        var y = sin(angle) * radius
        points.append(Vector2(x, y))
    
    return points
