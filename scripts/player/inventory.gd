extends Node3D

@onready var left_hand: Node3D = $"../Head/LeftHand"
@onready var item_slots: Array[SubViewportContainer] = [
	$"../Canvas/Control/Inventory/Item", $"../Canvas/Control/Inventory/Item2", $"../Canvas/Control/Inventory/Item3"
	]

var items: Array[Item] = []
var held_item: RigidBody3D
var held: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("item_1"):
		set_held(0)
	if Input.is_action_just_pressed("item_2"):
		set_held(1)
	if Input.is_action_just_pressed("item_3"):
		set_held(2)

func add_item(item: Item):
	items.append(item)
	set_held(0)
	
	update_inventory_ui()
	
func throw():
	print("trying to throw: ", items)
	if held < items.size():
		var throwed = held_item
		throwed.reparent(get_tree().current_scene)

		items.pop_at(held)
		update_inventory_ui()
		set_held(0)
		
		return throwed
		
func update_inventory_ui():
	for i in item_slots.size():
		item_slots[i].clear()
	for i in items.size():
		item_slots[i].put_item(items[i].prefab)
		
func set_held(index: int):
	held = index
	for child in left_hand.get_children():
		child.queue_free()
	if index >= items.size():
		held_item = null
		return
	held_item = items[index].prefab.instantiate() as RigidBody3D
	left_hand.add_child(held_item)
