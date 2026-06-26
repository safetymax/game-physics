extends Node3D

var alarm_on: bool = false
var lights: Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load lights (children of the node)
	for child in get_children():
		if child is Node3D:
			lights.append(child)
	#turn off all lights
	for light in lights:
		light.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if alarm is on, turn on all lights and rotate them and blink them
	if alarm_on:
		for light in lights:
			light.visible = true
			light.rotate_y(delta)
	pass
