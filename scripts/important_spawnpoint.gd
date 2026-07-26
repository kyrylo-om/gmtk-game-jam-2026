extends Node3D

@export var prefab: PackedScene
@onready var pos: Node3D = $Position

func spawn():
	if pos.get_child_count() == 0:
		var inst = prefab.instantiate()
		pos.add_child(inst)
