extends Node3D
@onready var static_body: Area3D = $StaticBody3D
@onready var animation_tree: AnimationTree = $AnimationTree

const ANIM_LENGTH = 100
@export var fade_speed: float = 5
@export var energy: float = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	energy -= fade_speed * delta
	animation_tree.set("parameters/TimeSeek/seek_request", energy)


func _on_static_body_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("fuel"):
		body.delete()
		energy += 50
