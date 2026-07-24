extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody3D = $"../.."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func refuel():
	animation_player.stop()
	animation_player.play("refuel")
	
func refuel_done():
	player.can_move = true
	animation_player.play("torch")
	
func die():
	print("Uh oh.")
