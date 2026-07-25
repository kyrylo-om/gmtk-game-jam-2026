extends Node3D

@onready var canvas: CanvasLayer = $"../Canvas"
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var ray_cast_fire: RayCast3D = $RayCast3D2
@onready var inventory: Node3D = $"../Inventory"
@onready var player: CharacterBody3D = $".."
@onready var torch: Node3D = $RightHand
var collider = null
var look_at_fire = false

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
			if inventory.items.size() < 3:
				canvas.show_tooltip("Press E to pick up " + collider.item_data.name + ".")
			else:
				canvas.show_tooltip("Can't hold more.")
			collider.glow()

	if collider: # looking at collectible
		if Input.is_action_just_pressed("pickup"):
			if inventory.items.size() < 3:
				pickup(collider)
				canvas.hide_tooltip()
				collider = null
				
	if not look_at_fire and ray_cast_fire.is_colliding():
		look_at_fire = true
		canvas.show_tooltip("Press E to light up the torch.")
	elif look_at_fire and not ray_cast_fire.is_colliding():
		look_at_fire = false
		canvas.hide_tooltip()
	if look_at_fire and Input.is_action_just_pressed("pickup"):
		player.disable_move()
		torch.refuel()

	if Input.is_action_pressed("throw"):
		throw_speed = clamp(throw_speed + 10 * delta, 0, max_throw_speed)
		
	if Input.is_action_just_released("throw"):
		throw()
		canvas.show_dialogue("How about you throw yourself instead?")
		throw_speed = 0

func pickup(item: RigidBody3D):
	inventory.add_item(item.delete())
	
func throw():
	var throwed: RigidBody3D = inventory.throw()

	if throwed:
		throwed.freeze = false
		var forward_vector: Vector3 = -global_transform.basis.z
		
		throwed.apply_central_impulse((forward_vector + global_transform.basis.x * 0.2) * throw_speed)
		throwed.apply_torque_impulse(-global_transform.basis.x * throw_speed / 10)

func _on_shade_trigger_area_entered(area: Area3D) -> void:
	#torch.
	area.die()
