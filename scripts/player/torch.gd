extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody3D = $"../.."
@onready var ui_animation: AnimationPlayer = $"../../Canvas/AnimationPlayer"
@onready var canvas: CanvasLayer = $"../../Canvas"
@onready var area_3d: Area3D = $"../../Area3D"
@onready var animation_tree: AnimationTree = $AnimationTree

@export var safe = true

const ANIM_LENGTH = 10
@export var fade_speed: float = 100
@export var energy: float = 100

var showed_dg = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not safe:
		energy -= fade_speed * delta
		animation_tree.set("parameters/TimeSeek/seek_request", 
		ANIM_LENGTH - energy / 100 * ANIM_LENGTH)

func refuel():
	animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	pass

func refuel_halfway():
	energy = 100
	animation_tree.set("parameters/TimeSeek/seek_request", 0)

func refuel_done():
	player.can_move = true
	
func die():
	if not showed_dg:
		canvas.show_dialogue("Well, guess I'm gonna die.")
		showed_dg = true
	ui_animation.play("Death")
	
func death_done():
	player.respawn()

func _on_area_3d_area_entered(area: Area3D) -> void:
	if not safe:
		print("Entered safe zone")
		ui_animation.play("Death", -1, -1, false)
		safe = true

func _on_area_3d_area_exited(area: Area3D) -> void:
	print("Exited safe zone")
	safe = false
