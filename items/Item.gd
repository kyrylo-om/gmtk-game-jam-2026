class_name Item
extends Resource

@export var name: String = ""
@export var icon: Texture2D
@export_file("*.tscn") var prefab_path: String = ""
@export var prefab: PackedScene
