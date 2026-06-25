extends Area3D

@export var required_cookies: int = 3

func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_cookie_count >= required_cookies:
			print("finished")
		else:
			print("not enough cookies: ", body.has_cookie_count, "/", required_cookies)
