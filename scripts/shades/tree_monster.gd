extends Node3D
var player: Node3D
@onready var animation_player_2: AnimationPlayer = $"../AnimationPlayer2"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func looked_at():
	print("Das")
	animation_player_2.play("glow")
