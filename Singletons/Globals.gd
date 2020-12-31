extends Node

const GRAVITY = 52

var paused = false

var data = {}

func _ready():
	ProjectSettings.set("physics/3d/default_gravity", GRAVITY)
	
	# Loading in data
	var data_read = File.new()
	data_read.open("res://data.cdb", File.READ)
	var data_json = parse_json(data_read.get_as_text())
	data_read.close()
	
	for sheet in data_json["sheets"]:
		var lines = sheet["lines"].duplicate(true)
		var items = {}
		for line in lines:
			var id = line["ID"]
			line.erase("ID")
			items[id] = line
		
		data[sheet["name"]] = items
	
	print(data["Weapons"]["StartingPistol"]["Damage"])
