extends Node

var items: Dictionary = {}

func _ready() -> void:
	# Load all items.
	items = load_json_file("res://Data/items.json")

# Load JSON file.
func load_json_file(file_path: String):
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		
		if parsed_result is Dictionary:
			return parsed_result
		else:
			print("Error reading file")
			
	else:
		print("File doesn't exist!")

# Search for single item in array of dictionary
func search_from_dictionary(dictionary: Array, unique_id: String):
	var result
	for item in dictionary:
		if (item["code"] == unique_id):
			result = item
			break
			
	return result
