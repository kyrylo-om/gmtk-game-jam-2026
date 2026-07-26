extends Node3D
@export var monsters: Array[PackedScene]

@export var min_delay = 2
@export var max_delay = 60
@export var start_delay = 20

@onready var torch: Node3D = $"../Head/RightHand"
@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer2
@onready var spawner: Node3D = $Spawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(min_delay, max_delay)
	if not torch.is_safe():
		spawn(monsters.pick_random())
		
func spawn(monster: PackedScene):
	print("spawn")
	rotation_degrees.y = randf_range(0, 360)
	
	var instance = monster.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.position = spawner.global_position

func spawn_tree_monster():
	spawn(monsters[1])


func _on_timer_2_timeout() -> void:
	print("spawn started")
	timer.start()
