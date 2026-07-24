extends CanvasLayer

@onready var label: Label = $Control/Label
@onready var dialogue: Label = $Control/VBoxContainer/MarginContainer/Dialogue
@onready var timer_2: Timer = $Control/VBoxContainer/MarginContainer/Dialogue/Timer2
var text_to_display = ""

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
	timer_2.stop()
	dialogue.text = ""
	text_to_display = text

func _on_timer_timeout() -> void:
	if text_to_display:
		var current_symbol = dialogue.text.length()
		
		if text_to_display.length() > current_symbol:
			if current_symbol % 2 == 0:
				dialogue.position.y = 0
			else:
				dialogue.position.y = 2
			dialogue.text += text_to_display[current_symbol]
		else:
			text_to_display = ""
			timer_2.start()

func _on_timer_2_timeout() -> void:
	dialogue.text = ""
