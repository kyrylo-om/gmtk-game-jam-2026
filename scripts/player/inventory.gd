extends Node3D

@onready var left_hand: Node3D = $"../Head/LeftHand"

var items: Array[Node] = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_item(item: Item):
	print(item.prefab)
	
	var picked_item = item.prefab.instantiate() as RigidBody3D
	left_hand.add_child(picked_item)
	picked_item.freeze = true
	
	items.append(picked_item)
	
func throw():
	print("trying to throw: ", items)
	if not items.is_empty():
		var throwed_item: RigidBody3D = items[0]
		
		throwed_item.reparent(get_tree().current_scene)
		items.pop_front()
		throwed_item.freeze = false
