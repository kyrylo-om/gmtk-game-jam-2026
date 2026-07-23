extends SubViewportContainer

@onready var slot: Node3D = $SubViewport/Slot

func put_item(item: PackedScene):
	var slotted = item.instantiate()
	slot.add_child(slotted)

func clear():
	for child in slot.get_children():
		child.queue_free()
