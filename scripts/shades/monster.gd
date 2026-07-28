extends Node3D
@export var mesh: Node3D
@export var effect: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func die():
	var instance = effect.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.position = global_position
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	die()

func _on_timer_timeout() -> void:
	die()


func _on_timer_2_timeout() -> void:
	die()
