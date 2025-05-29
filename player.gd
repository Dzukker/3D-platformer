extends CharacterBody3D

@export var SPEED = 8
@export var RUN_SPEED = 12
@export var ACCELERATION = 0.7
@export var DECELERATION = 1

@export var JUMP_CUTOFF = 10
@export var FALL_SPEED = 1.5
var JUMP_VELOCITY = 20
var HOLDING_JUMP = false

@export var COYOTE_JUMP_TIME = 0.3
var COYOTE_TIMER = 0
var CAN_JUMP = false
var TERMINAL_VELOCITY = 25

func _physics_process(delta: float) -> void:
	
#	Coyote jump setup. Declaring if character can jump or not. 
#	Można delte zmienić na TIME
	if is_on_floor():
		CAN_JUMP = true
	else:
		if COYOTE_TIMER < COYOTE_JUMP_TIME:
			COYOTE_TIMER += delta
		else:
			CAN_JUMP = false
			COYOTE_TIMER = 0
	
	# Add the gravity. Contains terminal velocity
	if not CAN_JUMP:
		if velocity.y < TERMINAL_VELOCITY:
			velocity += get_gravity() * delta * FALL_SPEED
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and CAN_JUMP:
		HOLDING_JUMP = true
		CAN_JUMP = false
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_released("jump"):
		HOLDING_JUMP = false
	
	if not HOLDING_JUMP and velocity.y >= JUMP_CUTOFF:
		velocity.y = JUMP_CUTOFF
	
	# Get the input direction and handle the movement/deceleration
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).rotated(Vector3.UP, $Camera3D.rotation.y).normalized()
#	Speed if running
	if direction and Input.is_action_pressed("run") and is_on_floor():
		velocity.x = move_toward(velocity.x, direction.x * RUN_SPEED, ACCELERATION)
		velocity.z = move_toward(velocity.z, direction.z * RUN_SPEED, ACCELERATION)
#	Getting running speed at jumping 
	elif direction and (velocity.x > SPEED or velocity.z > SPEED) and not is_on_floor():
		velocity.x = move_toward(velocity.x, direction.x * RUN_SPEED, ACCELERATION)
		velocity.z = move_toward(velocity.z, direction.z * RUN_SPEED, ACCELERATION)
#	Speed if walking
	elif direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION)
#	Deceleration
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)

	move_and_slide()
