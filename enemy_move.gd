extends CharacterBody3D


const SPEED = 1.0
const JUMP_VELOCITY = 4.5
#add list of node3ds as a path to walk up and down, and a variable to keep track of the current target node3d
@export
var path: Array[Node3D] = []
var current_target_index: int = 0
var arrived: bool = false
var turn_timer: float = 0.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	#walk from node to node. at each node wait, turn 360 degrees, and then move to the next node. if at the end of the path, walk the path backwards
	var forward = path[current_target_index].global_transform.origin - global_transform.origin
	if forward.length() < 0.5:
		arrived = true
		current_target_index += 1
		if current_target_index >= path.size():
			current_target_index = 0
	print ("current target index: ", current_target_index)

	if !arrived:
		velocity = forward.normalized() * SPEED
		#look at the target node
		rotation.y = atan2(forward.x, forward.z)
	if arrived:
		velocity = Vector3.ZERO
		#stay still, turn 360 degrees in 2 seconds, and only when finished turning, move to the next node
		rotate_y(deg_to_rad(360) * delta * 1/4)
		turn_timer += delta
		if turn_timer >= 4.0:
			turn_timer = 0.0
			arrived = false

	move_and_slide()
