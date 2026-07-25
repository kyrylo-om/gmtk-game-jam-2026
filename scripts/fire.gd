extends Node3D
@onready var static_body: Area3D = $ScaledObjects/Area3D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var shade_spawner: Node3D = $ShadeSpawner
@export var player: CharacterBody3D 
@export var shades: Array[PackedScene]
@onready var spawner: Node3D = $ShadeSpawner/Spawner
@onready var timer: Timer = $ShadeSpawner/Spawner/Timer

const ANIM_LENGTH = 100
@export var fade_speed: float = 5
@export var energy: float = 0

@export var shade_time_min = 2
@export var shade_time_max = 20


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	energy -= fade_speed * delta
	animation_tree.set("parameters/TimeSeek/seek_request", energy / 100 * ANIM_LENGTH)
		


func _on_static_body_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("fuel"):
		body.delete()
		energy += 50


func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(shade_time_min, shade_time_max)
	
	if player.torch.safe:
		shade_spawner.rotation = player.global_rotation
	else:
		shade_spawner.look_at(player.position)
	var va = randf_range(-90, 90)
	print(shade_spawner.rotation, va)
	shade_spawner.rotation_degrees.y += va
	print(shade_spawner.rotation)
	
	var shade = shades.pick_random().instantiate()
	add_child(shade)
	shade.position = spawner.global_position
	shade.look_at(position)
