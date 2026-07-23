extends RayCast3D

@onready var canvas: CanvasLayer = $"../../Canvas"
var looking_at_stick = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not looking_at_stick and is_colliding():
		canvas.show_tooltip("Press E to admire this cube.")
		looking_at_stick = true
	elif looking_at_stick and not is_colliding():
		canvas.hide_tooltip()
		looking_at_stick = false
		
	if looking_at_stick and Input.is_action_just_pressed("pickup"):
		print("pick")
