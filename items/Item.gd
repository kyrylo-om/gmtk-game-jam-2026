class_name Item
extends Resource

@export var name: String = ""
@export_file("*.tscn") var prefab_path: String = ""
var prefab: PackedScene
@export var fuel: float = 1
@export var mass: float = 1
