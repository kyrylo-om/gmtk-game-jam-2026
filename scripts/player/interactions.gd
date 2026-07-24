extends Node3D

@onready var canvas: CanvasLayer = $"../Canvas"
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var inventory: Node3D = $"../Inventory"
@onready var player: CharacterBody3D = $".."
var collider = null

@export var max_throw_speed: int = 10
var throw_speed: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_collider = ray_cast_3d.get_collider()
	
	if collider != current_collider: # something new
		if collider:
			collider.unglow()
			canvas.hide_tooltip()
		
		collider = current_collider
		if collider:
			canvas.show_tooltip("Press E to pick up " + collider.item_data.name + ".")
			collider.glow()

	if collider: # looking at collectible
			if Input.is_action_just_pressed("pickup"):
				pickup(collider)
				canvas.hide_tooltip()
				collider = null

	if Input.is_action_pressed("throw"):
		throw_speed = clamp(throw_speed + 10 * delta, 0, max_throw_speed)
		
	if Input.is_action_just_released("throw"):
		throw()
		throw_speed = 0

func pickup(item: RigidBody3D):
	inventory.add_item(item.delete())
	
func throw():
	var throwed: RigidBody3D = inventory.throw()

	if throwed:
		throwed.freeze = false
		var forward_vector: Vector3 = -global_transform.basis.z
		
		throwed.apply_central_impulse((forward_vector + global_transform.basis.x * 0.2) * throw_speed)
		throwed.apply_torque_impulse(-global_transform.basis.x * throw_speed / 5)
