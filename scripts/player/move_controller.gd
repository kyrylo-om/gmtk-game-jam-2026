# ProtoController v1.0 by Brackeys
# CC0 License
# Intended for rapid prototyping of first-person games.
# Happy prototyping!

extends CharacterBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/AnimationNodeStateMachine/playback")
@onready var canvas: CanvasLayer = $Canvas
@onready var inventory: Node3D = $Inventory
@onready var torch: Node3D = $Head/RightHand
@onready var canvas_player: AnimationPlayer = $Canvas/AnimationPlayer

@export var campfire: Node3D

## Can we move around?
@export var can_move : bool = false
## Are we affected by gravity?
@export var has_gravity : bool = true
## Can we press to jump?
@export var can_jump : bool = true
## Can we hold to run?
@export var can_sprint : bool = false
## Can we press to enter freefly mode (noclip)?
@export var can_freefly : bool = false

@export_group("Speeds")
## Look around rotation speed.
@export var look_speed : float = 0.002
## Normal speed.
@export var base_speed : float = 7.0
@export var crouch_speed : float = 4.0
## Speed of jump.
@export var jump_velocity : float = 4.5
## How fast do we run?
@export var sprint_speed : float = 10.0
## How fast do we freefly?
@export var freefly_speed : float = 25.0

@export_group("Input Actions")
## Name of Input Action to move Left.
@export var input_left : String = "move_left"
## Name of Input Action to move Right.
@export var input_right : String = "move_right"
## Name of Input Action to move Forward.
@export var input_forward : String = "move_forward"
## Name of Input Action to move Backward.
@export var input_back : String = "move_backward"
## Name of Input Action to Jump.
@export var input_jump : String = "jump"
## Name of Input Action to Sprint.
@export var input_sprint : String = "sprint"
## Name of Input Action to toggle freefly mode.
@export var input_freefly : String = "freefly"

var mouse_captured : bool = false
var look_rotation : Vector2
var move_speed : float = 0.0
var freeflying : bool = false

var is_moving = false
var is_sprinting = false
var has_jumped = false
var said_boundary = false
var first_respawn = true
var importants_found = 0

@onready var audio_step: AudioStreamPlayer = $Audio_step


## IMPORTANT REFERENCES
@onready var head: Node3D = $Head
@onready var collider: CollisionShape3D = $Collider

func _ready() -> void:
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x

func _unhandled_input(event: InputEvent) -> void:
	# Mouse capturing
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()
	
	# Look around
	if mouse_captured and event is InputEventMouseMotion:
		rotate_look(event.relative)
	
	# Toggle freefly mode
	if can_freefly and Input.is_action_just_pressed(input_freefly):
		if not freeflying:
			enable_freefly()
		else:
			disable_freefly()
			
func _process(delta: float) -> void:
	if first_respawn:
		if Input.is_action_just_pressed("pickup"):
			canvas.hide_tooltip()
			canvas_player.play("RESET")
			campfire.unstop()
			respawn()
		if Input.is_action_just_pressed("throw"):
			canvas.show_dialogue("I'm a developer and I'm cool as heck.")
			canvas.hide_tooltip()
			canvas_player.play("RESET")
			can_move = true
			first_respawn = false
			campfire.unstop()

func _physics_process(delta: float) -> void:
	# If freeflying, handle freefly and nothing else
	if can_freefly and freeflying:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var motion := (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		motion *= freefly_speed * delta
		move_and_collide(motion)
		return
	
	# Apply gravity to velocity
	if has_gravity:
		if not is_on_floor():
			velocity += get_gravity() * delta * 1.1
		if has_jumped and is_on_floor():
			playback.travel("jump_end")
			has_jumped = false

	# Apply jumping
	if can_jump:
		if Input.is_action_just_pressed(input_jump) and is_on_floor():
			has_jumped = true
			playback.travel("jump_start")
			velocity.y = jump_velocity

	# Modify speed based on sprinting
	is_sprinting = false
	move_speed = base_speed
	if can_sprint and Input.is_action_pressed(input_sprint):
		move_speed = sprint_speed
		if is_moving: is_sprinting = true
	if Input.is_action_pressed("throw"):
		is_sprinting = false
		move_speed = crouch_speed

	# Apply desired movement to velocity
	if can_move:
		var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
		var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		var weight = inventory.weight() / 10
		var speed = move_speed - weight
		if move_dir:
			is_moving = true
			velocity.x = move_dir.x * speed
			velocity.z = move_dir.z * speed
		else:
			is_moving = false
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
	else:
		velocity.x = 0
		velocity.y = 0
	
	#REMOVE
	if Input.is_action_just_pressed("reset"):
		respawn()
		
	if not said_boundary and position.distance_to(Vector3.ZERO) > 80:
		canvas.show_dialogue("There is nothing for me outside without her.")
		said_boundary = true
	
	# Use velocity to actually move
	move_and_slide()


## Rotate us to look around.
## Base of controller rotates around y (left/right). Head rotates around x (up/down).
## Modifies look_rotation based on rot_input, then resets basis and rotates by look_rotation.
func rotate_look(rot_input : Vector2):
	look_rotation.x -= rot_input.y * look_speed
	look_rotation.x = clamp(look_rotation.x, deg_to_rad(-85), deg_to_rad(85))
	look_rotation.y -= rot_input.x * look_speed
	transform.basis = Basis()
	rotate_y(look_rotation.y)
	head.transform.basis = Basis()
	head.rotate_x(look_rotation.x)

func rotate_look_immediately(rot_input : Vector2):
	look_rotation.x = clamp(rot_input.y, deg_to_rad(-85), deg_to_rad(85))
	look_rotation.y = rot_input.x
	transform.basis = Basis()
	rotate_y(look_rotation.y)
	head.transform.basis = Basis()
	head.rotate_x(look_rotation.x)


func enable_freefly():
	collider.disabled = true
	freeflying = true
	velocity = Vector3.ZERO

func disable_freefly():
	collider.disabled = false
	freeflying = false


func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false
	
func respawn():
	has_jumped = false
	position = Vector3(0, 0, 7)
	rotate_look_immediately(Vector2.ZERO)
	inventory.clear()
	
	playback.travel("wake_up")
	disable_move()

func disable_move():
	is_moving = false
	is_sprinting = false
	can_move = false
	velocity = Vector3.ZERO

func respawn_done():
	if first_respawn:
		first_respawn = false
	else:
		var lines = ["No. I can't let her go.", "As long as I remember..."]
		canvas.show_dialogue(lines.pick_random())
	can_move = true

func step():
	audio_step.pitch_scale = randf()*0.3 + 0.85
	audio_step.play()
