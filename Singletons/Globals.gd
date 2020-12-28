extends Node

const GRAVITY = 52

var paused = false

func _ready():
	ProjectSettings.set("physics/3d/default_gravity", GRAVITY)
