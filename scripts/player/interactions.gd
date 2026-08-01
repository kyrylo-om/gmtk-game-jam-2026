extends Node3D

@onready var canvas: CanvasLayer = $"../Canvas"
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var ray_cast_fire: RayCast3D = $RayCast3D2
@onready var inventory: Node3D = $"../Inventory"
@onready var player: CharacterBody3D = $".."
@onready var torch: Node3D = $RightHand
@onready var animation_tree: AnimationTree = $"../AnimationTree"
@onready var monster_spawner: Node3D = $"../MonsterSpawner"
@onready var cutscene_anim: AnimationPlayer = $"../../../../AnimationPlayer"
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var color_rect: Panel = $"../Canvas/Control/HintContainer/ColorRect"
var collider = null
var look_at_fire = false
var hint_throw = false
var hinted_throw = false
var current_tree_monster: Area3D

@export var max_throw_speed: int = 10
var throw_speed: float = 0

func _ready() -> void:
	canvas.show_tooltip("Press E to wake up.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_collider = ray_cast_3d.get_collider()
	
	if collider != current_collider: # something new
		if collider:
			collider.unglow()
			canvas.hide_tooltip()
		
		collider = current_collider
		if collider:
			if inventory.items.size() < 3:
				canvas.show_tooltip("Press E to pick up " + collider.item_data.name + ".")
			else:
				canvas.show_tooltip("Can't hold more.")
			collider.glow()

	if collider: # looking at collectible
		if Input.is_action_just_pressed("pickup"):
			if inventory.items.size() < 3:
				pickup(collider)
				canvas.hide_tooltip()
				collider = null
				
	if not look_at_fire and ray_cast_fire.is_colliding():
		look_at_fire = true
	elif look_at_fire and not ray_cast_fire.is_colliding():
		look_at_fire = false
		canvas.hide_tooltip()
	if look_at_fire:
		if player.campfire.energy == 0:
			canvas.show_tooltip("Press E to contemplate.")
			if Input.is_action_just_pressed("pickup"):
				player.disable_move()
				player.can_reset = true
				cutscene_anim.play("cutscene1")
		else:
			canvas.show_tooltip("Press E to light up the torch.\n" + str(player.importants_found) + " / 5 memories found.")
			if Input.is_action_just_pressed("pickup"):
				player.disable_move()
				torch.refuel()

	if Input.is_action_pressed("throw"):
		throw_speed = clamp(throw_speed + 20 * delta, 0, max_throw_speed)
		color_rect.custom_minimum_size.x = throw_speed * 12
		
	if Input.is_action_just_released("throw"):
		throw()
		throw_speed = 0
		color_rect.custom_minimum_size.x = 0
		
	if hint_throw:
		canvas.show_tooltip("Hold Q to throw into the fire.")

func pickup(item: RigidBody3D):
	audio_stream_player.play()
	if not hinted_throw:
		hint_throw = true
	var item_data = item.delete()
	inventory.add_item(item_data)
	
	if item_data.name == "Book":
		canvas.show_dialogue("It's her diary.")
	elif item_data.name == "Jewelry box":
		canvas.show_dialogue("There is nothing inside anymore.")
	elif item_data.name == "Clock":
		canvas.show_dialogue("It keeps counting down.")
	elif item_data.name == "Comb":
		canvas.show_dialogue("I can still smell her hair.")
	elif item_data.name == "Mirror":
		canvas.show_dialogue("It is shattered.")
		
	
func throw():
	if not hinted_throw:
		hint_throw = false
		hinted_throw = true
		canvas.hide_tooltip()
	var throwed: RigidBody3D = inventory.throw()

	if throwed:
		throwed.freeze = false
		throwed.process_mode = Node.PROCESS_MODE_INHERIT
		var forward_vector: Vector3 = -global_transform.basis.z
		
		throwed.apply_central_impulse((forward_vector + global_transform.basis.x * 0.2) * throw_speed)
		throwed.apply_torque_impulse(-global_transform.basis.x * throw_speed / 10)
		
		throwed.set_collision_layer_value(7, true)
		throwed.start_timer()

func _on_shade_trigger_area_entered(area: Area3D) -> void:
	torch.extinguish()
	area.die()


func _on_look_area_entered(area: Area3D) -> void:
	current_tree_monster = area
	if current_tree_monster.mesh:
		current_tree_monster.mesh.looked_at()
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _on_look_area_exited(area: Area3D) -> void:
	if current_tree_monster:
		current_tree_monster.die()
		#monster_spawner.spawn_tree_monster()
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)
	
func tree_monster_looked():
	current_tree_monster.die()
	torch.extinguish()
