extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
#add list of node3ds as a path to walk up and down, and a variable to keep track of the current target node3d
@export
var path: Array[Node3D] = []
var current_target_index: int = 0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	#walk from node to node. at each node wait, turn 360 degrees, and then move to the next node. if at the end of the path, walk the path backwards
	var forward = path[current_target_index].global_transform.origin - global_transform.origin
	if forward.length() < 0.1:
		current_target_index += 1
		if current_target_index >= path.size():
			current_target_index = 0

	velocity = forward.normalized() * SPEED
	#if close enough to the target node, stop moving, turn 360 degrees, and then move to the next node
	#if forward.length() < 0.1:
		#velocity = Vector3.ZERO
		#turn 360 degrees
		#rotate_y(deg_to_rad(360) * delta)

	move_and_slide()
