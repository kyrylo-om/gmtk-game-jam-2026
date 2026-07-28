extends Node3D
@onready var monster: Area3D = $".."
var player: Node3D

@export var move_speed = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	move_speed += randf_range(-move_speed / 2, move_speed / 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	monster.look_at(player.position)
	monster.position += -global_transform.basis.z * delta * move_speed


func _on_monster_area_entered(area: Area3D) -> void:
	monster.die()
