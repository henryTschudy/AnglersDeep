extends Button

export var ref_path = ""
export(bool) var start_focused = false
var prev_scene = "prev_scene"

# for debug
const SaveManager = preload("autosave.gd") # Relative path
onready var autosave = SaveManager.new()

func _ready():
	if(start_focused):
		grab_focus()
		
	connect("mouse_entered",self,"_shift_focus")
	connect("pressed",self,"_select_button")

func _shift_focus():
	grab_focus()

func _select_button():
	# delete this debug later!!!
#	saveGame()	
	if(ref_path != ""):
		Global.change_scene(ref_path)
	else:
		get_tree().quit()
