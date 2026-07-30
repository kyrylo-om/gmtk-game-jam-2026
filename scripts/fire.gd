extends Node3D
@onready var static_body: Area3D = $ScaledObjects/Area3D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var shade_spawner: Node3D = $ShadeSpawner
@export var player: CharacterBody3D 
@export var shades: Array[PackedScene]
@onready var spawner: Node3D = $ShadeSpawner/Spawner
@onready var timer: Timer = $ShadeSpawner/Spawner/SpawnTimer
@onready var audio_burn: AudioStreamPlayer3D = $Audio_burn
@onready var audio_burn_important: AudioStreamPlayer3D = $Audio_burn_important
@onready var cutscene_timer: Timer = $CutsceneTimer
@onready var cutscene_anim: AnimationPlayer = $"../../../AnimationPlayer"
@onready var audio_laugh: AudioStreamPlayer3D = $Audio_laugh


const ANIM_LENGTH = 100
@export var energy: float = 10
@export var minutes_to_fade: float
@export var shade_time_min = 2
@export var shade_time_max = 20
var fade_speed: float = 5
var stop = true
var collected_sticks = 0

func _ready() -> void:
	fade_speed = 100 / (minutes_to_fade * 60)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not stop:
		energy = clamp(energy - fade_speed * delta, 0, 100)
	animation_tree.set("parameters/TimeSeek/seek_request", energy / 100 * ANIM_LENGTH)
	animation_tree.set("parameters/Add2/add_amount", energy / 100 * 3)
	animation_tree.set("parameters/TimeScale 2/scale", energy / 100 * 2)
	
func add_fuel(amount: float):
	energy += amount
	print("added ", amount, " energy to fire")
	animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	audio_burn.play()
	collected_sticks += 1
	if collected_sticks >= 5 and player.importants_found <= 0:
		player.paths_hint()
	
func add_important_fuel(amount: float):
	energy += amount
	print("added ", amount, " energy to fire")
	player.importants_found += 1
	animation_tree.set("parameters/OneShot 2/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	audio_burn_important.play()
	
	if player.importants_found >= 5:
		cutscene_timer.start()
	else:
		player.monster_spawner.increase_spawnrate()

func _on_static_body_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("fuel_important"):
		body.delete()
		add_important_fuel(body.item_data.fuel)
	elif body.is_in_group("fuel"):
		body.delete()
		add_fuel(body.item_data.fuel)


func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(shade_time_min, shade_time_max)
	
	if player.torch.safe:
		shade_spawner.rotation = player.global_rotation
	else:
		shade_spawner.look_at(player.position)
	shade_spawner.rotation_degrees.y += randf_range(-90, 90)
	
	var shade = shades.pick_random().instantiate()
	add_child(shade)
	shade.position = spawner.global_position
	shade.look_at(position)
	
func unstop():
	stop = false


func _on_cutscene_timer_timeout() -> void:
	player.can_reset = true
	cutscene_anim.play("cutscene2")


func _on_timer_laugh_timeout() -> void:
	audio_laugh.play()
