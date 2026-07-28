extends Label
@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer2

var text_to_display: String = ""

func show_text(text_arg: String):
	modulate.a = 1.0
	timer_2.stop()
	text = ""
	text_to_display = text_arg

func _on_timer_timeout() -> void:
	if text_to_display:
		var current_symbol = text.length()
		
		if text_to_display.length() > current_symbol:
			if current_symbol % 2 == 0:
				position.y = 0
			else:
				position.y = 2
			text += text_to_display[current_symbol]
		else:
			text_to_display = ""
			timer_2.start()

func _on_timer_2_timeout() -> void:
	create_tween().tween_property(self, "modulate:a", 0.0, 0.2)
