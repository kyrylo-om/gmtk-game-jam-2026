extends Node3D
@onready var label_3d: Label3D = $Node3D/Label3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_timer_2_timeout() -> void:
	label_3d.show_text()
	
func die():
	queue_free()
