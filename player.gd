extends CharacterBody3D


@export var SPEED = 10
@export var ACCELERATION = 0.7
@export var DECELERATION = 1

@export var JUMP_CUTOFF = 8
var JUMP_TIMER = 0.0
var JUMP_VELOCITY = 17

const MAXTIME = 0.3
var COYOTE_TIMER = 0
var CAN_JUMP = false
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
	#if Input.is_action_just_pressed("jump") and JUMP_TIMER < 0.5 and CAN_JUMP:
		#velocity.y = JUMP_CUTOFF
	#else:
		#velocity.y = JUMP_VELOCITY
		#JUMP_TIMER = 0
	#CAN_JUMP = false
	
	
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
