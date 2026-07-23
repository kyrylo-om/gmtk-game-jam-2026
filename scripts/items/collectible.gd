extends Node

@export var item_data: Item
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	item_data.prefab = load(item_data.prefab_path) as PackedScene

func delete():
	queue_free()
	return item_data
	
func hold():
	collision_shape_3d.disabled = true
	
func unhold():
	collision_shape_3d.disabled = false
