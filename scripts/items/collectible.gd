extends Node

@export var item_data: Item
@export var mesh: MeshInstance3D
@export var outline_material: Material
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
	
func glow():
	mesh.material_overlay = outline_material

func unglow():
	mesh.material_overlay = null
