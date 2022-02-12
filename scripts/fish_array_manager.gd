extends Node

var PATH_TO_FISH_JSON = "res://data/fish data.json"

var fish_dictionary
var fish_region_names = []
var fish_region_arrays = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var fish_json = File.new()
	fish_json.open(PATH_TO_FISH_JSON, File.READ)
	var fish_text = fish_json.get_as_text()
	var parsed_json_dictionary = parse_json(fish_text)
	
	fish_dictionary = parsed_json_dictionary.get("Fish")
		
	for fish_key in fish_dictionary.keys():
		var fish_data = fish_dictionary.get(fish_key)
		
		var fish_region = fish_data.get("Region")
		var fish_region_index = fish_region_names.find(fish_region)
		
		if (fish_region_index == -1):
			fish_region_names.push_back(fish_region)
			var new_region_array = []
			fish_region_arrays.push_back(new_region_array)
			fish_region_index = fish_region_names.size() - 1
		
		var fish_frequency = fish_data.get("Frequency")
		var i = 0
		while i < fish_frequency:
			fish_region_arrays[fish_region_index].append(fish_key)
			i = i + 1
