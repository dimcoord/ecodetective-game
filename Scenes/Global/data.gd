extends Node

var items: Dictionary = {}
var monsters: Dictionary = {}

func _ready() -> void:
	# Load all items.
	items = load_json_file("res://Data/items.json")
	monsters = load_json_file("res://Data/monsters.json")

# Load JSON file.
func load_json_file(file_path: String):
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		
		if parsed_result is Dictionary:
			return parsed_result
		else:
			print("Error reading file")
			return null
			
	else:
		print("File doesn't exist!")
		return null

# Search for single item in array of dictionary
func search_from_dictionary(dictionary: Array, unique_id: String, key: String):
	var result
	for item in dictionary:
		if (item[key] == unique_id):
			result = item
			break
			
	return result

func save(file_path: String) -> void:
	var save_dict := {
		"pos_x" : GameManager.pos_x, # gak support Vector2
		"pos_y" : GameManager.pos_y, # gak support Vector2
		"username" : GameManager.username,
		"current_map": GameManager.current_map,
		"current_hp" : GameManager.current_hp,
		"max_hp" : GameManager.max_hp,
		"exp": GameManager.exp,
		"level": GameManager.level,
		"total_move": GameManager.total_move,
		"is_new": GameManager.is_new
	}
	var json_string := JSON.stringify(save_dict)
	var file_access := FileAccess.open(file_path, FileAccess.WRITE)
	if not file_access:
		print("An error happened while saving data: ", FileAccess.get_open_error())
		return
	file_access.store_line(json_string)
	file_access.close()
