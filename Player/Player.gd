extends KinematicBody

# Camera
var mouse_sensitivity = 0.2
var camera_angle_max = 89

# State machine
enum STATES {
	FREE
}
var state = STATES.FREE

# Movement
var velocity = Vector3()
var move_direction = Vector3()
var move_acceleration = 15
var move_speed = 20
var jump_force = 30

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Head/Camera/RayCast.add_exception(self)

func _input(event):
	if event is InputEventMouseMotion && is_network_master() && !Globals.paused:
		rotation_degrees.y -= event.relative.x*mouse_sensitivity
		$Head.rotation_degrees.x -= event.relative.y*mouse_sensitivity
		$Head.rotation_degrees.x = clamp($Head.rotation_degrees.x, -camera_angle_max, camera_angle_max)

func _process(delta):
	$Head/Camera.current = is_network_master()
	
	# Checking that if the player has quit the game
	# will delete itself it it doesn't have a player
	var has_player = false
	for client in Network.clients:
		if get_network_master() == client[0]:
			has_player = true
	if !has_player:
		queue_free()
	
	# Getting the position that the player is aiming at
	var aim_raycast = $Head/Camera/RayCast
	if aim_raycast.is_colliding():
		aim_raycast.get_node("LookPoint").global_transform.origin = aim_raycast.get_collision_point()
	else:
		aim_raycast.get_node("LookPoint").transform.origin = aim_raycast.cast_to
	
	if !Globals.paused && is_network_master():
		match(state):
			STATES.FREE:
				get_movement()

func _physics_process(delta):
	if is_network_master():
		# Move twords the move direcion
		var temp_y = velocity.y
		velocity = velocity.linear_interpolate(move_direction*move_speed, move_acceleration*delta)
		velocity.y = temp_y - Globals.GRAVITY*delta
		if move_direction.y != 0: velocity.y += move_direction.y
		velocity = move_and_slide(velocity, Vector3.UP)
		move_direction = Vector3()
		
		rpc_unreliable("sync_transform", global_transform)
	

func get_movement():
	var head_basis = $Head.global_transform.basis
	
	if Input.is_action_pressed("move_forward"):
		move_direction -= head_basis.z	
	if Input.is_action_pressed("move_backwards"):
		move_direction += head_basis.z
	if Input.is_action_pressed("move_left"):
		move_direction -= head_basis.x
	if Input.is_action_pressed("move_right"):
		move_direction += head_basis.x
	
	move_direction.y = 0
	move_direction = move_direction.normalized()
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		move_direction.y = jump_force

sync func sync_transform(transform):
	global_transform = transform
