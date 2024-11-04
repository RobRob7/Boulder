extends Node2D

@export var amplitude: float = 10.0  # Maximum distance to move left and right
@export var speed: float = 2.0       # Speed of the movement

# Dictionary to store each child’s initial position
var initial_positions := {}

# ran only once, when node enters tree
func _ready():
	# store each clouds initial position
	for child in get_children():
		if child is Node2D:
			initial_positions[child] = child.position


# ran every frame
func _process(delta: float):
	# calculate the offset based on sine wave
	var offset = amplitude * sin(Time.get_ticks_msec() / 1000.0 * speed)

	# apply offset to all clouds
	for child in get_children():
		if child is Node2D and child in initial_positions:
			child.position.x = initial_positions[child].x + offset
