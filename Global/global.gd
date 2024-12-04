extends Node

var active_camera = null

func set_active_camera(camera):
	if active_camera:
		active_camera.enabled = false
	active_camera = camera
	active_camera.enabled = true
