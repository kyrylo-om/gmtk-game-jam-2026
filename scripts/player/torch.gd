extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody3D = $"../.."
@onready var ui_animation: AnimationPlayer = $"../../Canvas/AnimationPlayer"
@onready var canvas: CanvasLayer = $"../../Canvas"
@onready var area_3d: Area3D = $"../../Area3D"
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var fire: GPUParticles3D = $Torch/Fire/Fire_vfx/Fire
@onready var smoke: GPUParticles3D = $Torch/Fire/Fire_vfx/Smoke
@onready var sparks_2: GPUParticles3D = $Torch/Fire/Fire_vfx/Sparks2

@export var safe = true
@export var death_delay = 3

const ANIM_LENGTH = 12
@export var fade_speed: float = 10
@export var energy: float = 100
@export var max_energy = 100

var showed_dg = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not safe:
		energy = clamp(energy - fade_speed * delta, 0, max_energy)
		animation_tree.set("parameters/TimeSeek/seek_request", 
		ANIM_LENGTH - energy / max_energy * ANIM_LENGTH)
	#animation_tree.set("parameters/Sub2/sub_amount", energy / max_energy / 2)
	if energy > 0:
		animation_tree.set("parameters/TimeScale 2/scale", 2 - energy / max_energy)
	else:
		animation_tree.set("parameters/TimeScale 2/scale", 0)

func refuel():
	fire.restart()
	smoke.restart()
	sparks_2.restart()
	animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	pass

func refuel_halfway():
	energy = max_energy
	animation_tree.set("parameters/TimeSeek/seek_request", 0)

func refuel_done():
	player.can_move = true
	
func die():
	if not safe:
		if not showed_dg:
			canvas.show_dialogue("Well, guess I'm gonna die.")
			showed_dg = true
		ui_animation.play("Death")
	
func death_done():
	player.respawn()

func extinguish():
	energy = 0
	animation_tree.set("parameters/TimeSeek/seek_request", 
		ANIM_LENGTH - energy / max_energy * ANIM_LENGTH)

func _on_area_3d_area_entered(area: Area3D) -> void:
	if not safe:
		print("Entered safe zone")
		ui_animation.play("Death", -1, -1, false)
		safe = true

func _on_area_3d_area_exited(area: Area3D) -> void:
	print("Exited safe zone")
	safe = false
	
