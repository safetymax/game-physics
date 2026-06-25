extends CharacterBody3D


const SPEED = 1.0
const JUMP_VELOCITY = 4.5
#add list of node3ds as a path to walk up and down, and a variable to keep track of the current target node3d
@export
var path: Array[Node3D] = []
var current_target_index: int = 0
var arrived: bool = false
var turn_timer: float = 0.0

@export
var player: Node3D

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
	#print ("current target index: ", current_target_index)

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

	#look for player: raycast from enemy to player, if angle between enemy forward and player is less than 75 degrees, and distance is less than 10, then print("player detected")
	#find player node in the scene tree
	#var player = get_tree().get_root().get_node("Player")
	var enemy_forward = global_transform.basis.z
	var to_player = player.global_transform.origin - global_transform.origin
	var angle = rad_to_deg(enemy_forward.angle_to(to_player.normalized()))
	if to_player.length() < 10.0:
		if abs(angle) < 30.0:
			#cast a ray from enemy to player, if it hits the player, then print("player detected")
			var space_state = get_world_3d().direct_space_state
			# use global coordinates, not local to node
			var query = PhysicsRayQueryParameters3D.create(global_transform.origin,player.global_transform.origin)
			var result = space_state.intersect_ray(query)
			if result and result.collider == player:
				print("player detected")

	move_and_slide()
