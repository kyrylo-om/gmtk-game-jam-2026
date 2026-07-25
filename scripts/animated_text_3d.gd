extends Label3D
@onready var timer: Timer = $"../../dialogue_timer"
@onready var timer_2: Timer = $"../../dialogue_timer/Timer"
@onready var timer_3: Timer = $"../../dialogue_timer/Timer2"
@onready var campfire_shade: Node3D = $"../.."

@export var lines: Array[String]
@export var lines_per_life = 2

var said_lines = 1
var text_to_display: String = ""

func show_text():
	modulate.a = 1.0
	timer_2.stop()
	text = ""
	text_to_display = lines.pick_random()

func _on_dialogue_timer_timeout() -> void:
	if text_to_display:
		var current_symbol = text.length()
		
		if text_to_display.length() > current_symbol:
			if current_symbol % 2 == 0:
				position.y = 0
			else:
				position.y = 0.02
			text += text_to_display[current_symbol]
		else:
			text_to_display = ""
			timer_2.start()


func _on_timer_timeout() -> void:
	timer_3.start()
	create_tween().tween_property(self, "modulate:a", 0.0, 0.2)

func _on_timer_2_timeout() -> void:
	print("new line")
	if said_lines >= lines_per_life:
		campfire_shade.die()
	else:
		show_text()
		said_lines += 1
