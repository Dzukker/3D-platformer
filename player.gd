extends CharacterBody3D


@export var SPEED = 10
@export var JUMP_VELOCITY = 17
@export var JUMP_CUTOFF = 8
@export var ACCELERATION = 0.7
@export var DECELERATION = 1

const MAXTIME = 0.15
var COYOTE_TIMER = 0
var CAN_JUMP = true
var TERMINAL_VELOCITY = 25

func _physics_process(delta: float) -> void:
	
#	Coyote jump setup. Declaring if character can jump or not. 
	if is_on_floor():
		CAN_JUMP = true
	else:
		if COYOTE_TIMER < MAXTIME:
			COYOTE_TIMER += delta
		else:
			CAN_JUMP = false
			COYOTE_TIMER = 0
	
	# Add the gravity. Contains terminal velocity
	if not CAN_JUMP:
		if velocity.y < TERMINAL_VELOCITY:
			velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and CAN_JUMP:
		velocity.y = move_toward(velocity.y, JUMP_VELOCITY, delta)
		CAN_JUMP = false
	if Input.is_action_just_released("jump") && velocity.y > JUMP_VELOCITY:
		velocity.y = JUMP_CUTOFF
	
	# Get the input direction and handle the movement/deceleration
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)

	move_and_slide()
