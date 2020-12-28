extends CanvasLayer

func _ready():
	Globals.paused = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		Globals.paused = !Globals.paused
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if Globals.paused else Input.MOUSE_MODE_CAPTURED)
	
	$Control.visible = Globals.paused

func _on_ResumeButton_pressed():
	Globals.paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_QuitButton_pressed():
	Network.network_disconnect()
	get_tree().change_scene("res://Main Menu/MainMenu.tscn")

func _on_QuitDesktopButton2_pressed():
	Network.network_disconnect()
	get_tree().quit()
