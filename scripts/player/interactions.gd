extends Node3D

@onready var canvas: CanvasLayer = $"../Canvas"
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var inventory: Node3D = $"../Inventory"
var looking_at_stick = false

@export var max_throw_speed: int = 10
var throw_speed: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not looking_at_stick and ray_cast_3d.is_colliding():
		canvas.show_tooltip("Press E to admire this cube.")
		looking_at_stick = true
	elif looking_at_stick and not ray_cast_3d.is_colliding():
		canvas.hide_tooltip()
		looking_at_stick = false
		
	if looking_at_stick and Input.is_action_just_pressed("pickup"):
		pickup(ray_cast_3d.get_collider())
		
	if Input.is_action_pressed("throw"):
		throw_speed = clamp(throw_speed + 10 * delta, 0, max_throw_speed)
		print(throw_speed)
	if Input.is_action_just_released("throw"):
		throw()
		throw_speed = 0

func pickup(item: RigidBody3D):
	inventory.add_item(item.collect())
	
func throw():
	var throwed: RigidBody3D = inventory.throw()

	throwed.freeze = false
	var forward_vector: Vector3 = -global_transform.basis.z + global_transform.basis.x * 0.2
	
	throwed.apply_central_impulse(forward_vector * throw_speed)
