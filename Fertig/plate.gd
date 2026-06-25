extends Area3D

@export var required_cookies: int = 3

func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.cookies >= required_cookies:
			print("finished")
		else:
			print("not enough cookies: ", body.cookies, "/", required_cookies)
