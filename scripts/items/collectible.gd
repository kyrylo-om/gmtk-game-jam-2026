extends Node

@export var item_data: Item

func _ready() -> void:
	item_data.prefab = load(item_data.prefab_path) as PackedScene

func collect():
	queue_free()
	return item_data
