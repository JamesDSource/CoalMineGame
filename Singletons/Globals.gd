extends Node

const GRAVITY = 52

func _ready():
	ProjectSettings.set("physics/3d/default_gravity", GRAVITY)
