extends Node2D

var asteroid_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_asteroid_generation_timer_timeout():
    if asteroid_count < 5:
        var asteroid = preload("res://scenes/asteroid_2.tscn").instantiate()
        asteroid.position = Vector2(100, 100)
        asteroid_count += 1
        asteroid.asteroid_number = asteroid_count
        
        add_child(asteroid)
    
    $AsteroidGenerationTimer.start()
