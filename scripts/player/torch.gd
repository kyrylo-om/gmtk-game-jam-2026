extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody3D = $"../.."
@onready var ui_animation: AnimationPlayer = $"../../Canvas/AnimationPlayer"
@onready var canvas: CanvasLayer = $"../../Canvas"

var showed_dg = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func refuel():
	animation_player.play("RESET")
	animation_player.play("refuel")
	
func refuel_done():
	player.can_move = true
	animation_player.play("torch")
	
func die():
	if not showed_dg:
		canvas.show_dialogue("Well, guess I'm gonna die.")
		showed_dg = true
	ui_animation.play("Death")
	
func death_done():
	player.respawn()
