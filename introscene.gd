extends Node2D

@onready var player = $Player  # Reference to the Player node
var start_position = Vector2(-720, 200)
var end_position = Vector2(600, 200)
var duration = 13.0  # Time in seconds to complete the movement
var elapsed_time = 0.0

func _ready():
	player.position = start_position

func _process(delta):
	if elapsed_time < duration:
		elapsed_time += delta
		var t = elapsed_time / duration
		player.position = start_position.lerp(end_position, t)
	else:
		player.position = end_position
