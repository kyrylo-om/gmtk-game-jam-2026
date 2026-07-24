extends CanvasLayer

@onready var label: Label = $Control/Label
@onready var dialogue: Label = $Control/VBoxContainer/MarginContainer/Dialogue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func show_tooltip(text):
	label.text = text
	label.visible = true
	
func hide_tooltip():
	label.visible = false
	
func show_dialogue(text: String):
	dialogue.show_text(text)
