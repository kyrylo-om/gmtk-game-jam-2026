extends Node3D
@export var monsters: Array[PackedScene]

@export var min_delay = 2
@export var max_delay = 60
@export var delay_step = 5

@onready var torch: Node3D = $"../Head/RightHand"
@onready var timer: Timer = $Timer
@onready var spawner: Node3D = $Spawner

func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(min_delay, max_delay)
	if not torch.is_safe():
		print("spawn")
		if randi() % 2:
			spawn_tree_monster()
		else:
			spawn_baby()
		
func spawn(monster: PackedScene):
	var instance = monster.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.position = spawner.global_position

func spawn_tree_monster():
	rotation_degrees.y = randf_range(150, 210)
	spawn(monsters[1])
	
func spawn_baby():
	rotation_degrees.y = randf_range(0, 360)
	spawn(monsters[0])


func _on_timer_2_timeout() -> void:
	print("spawn started")
	timer.start()

func increase_spawnrate():
	max_delay -= delay_step
