extends CharacterBody3D


const SPEED = 2.0
const JUMP_VELOCITY = 4.5

var cookies: int = 0

@export
var model: Node3D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	model.rotation.y = atan2(-direction.x, -direction.z) + deg_to_rad(180)

	move_and_slide()

func _ready():
	for area in get_tree().get_nodes_in_group("cookie"):
		if area is Area3D:
			area.body_entered.connect(_on_cookie_body_entered.bind(area))
			print("Connected to cookie area: ", area.name)


func _on_cookie_body_entered(body, cookie):
	if body == self:
		cookies += 1
		print("Player has collected: ", cookies, " cookies.")

		cookie.get_parent().queue_free()  # Remove the cookie from the scene
