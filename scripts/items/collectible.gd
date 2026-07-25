extends RigidBody3D

@export var item_data: Item
@export var mesh: MeshInstance3D
@export var outline_material: Material
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var timer: Timer = $Timer

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

func start_timer():
	timer.start()

func _on_timer_timeout() -> void:
	set_collision_layer_value(7, false)
