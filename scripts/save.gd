extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var save_file_name = "user://AnglersDeepSave.save"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func AnglersDeepSave():
	# open our saved file
	var save_file = File.new()
	save_file.open(save_file_name, File.WRITE)
	
	# get all the nodes saved
	var saved_nodes = get_tree().get_nodes_in_group("Saved")
	
	for node in saved_nodes:
		if node.filename.empty():
			# skip empty nodes
			break
		# otherwise, we get the saved stats
		var node_details = node.get_save_stats()
		save_file.store_line(to_json(node_details))
	
	# close our file
	save_file.close()
