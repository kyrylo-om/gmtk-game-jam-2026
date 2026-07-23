extends Node3D

@onready var canvas: CanvasLayer = $"../Canvas"
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var inventory: Node3D = $"../Inventory"
var looking_at_stick = false

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
		
	if Input.is_action_just_pressed("throw"):
		throw()

func pickup(item: RigidBody3D):
	inventory.add_item(item.collect())
	
func throw():
	inventory.throw()
