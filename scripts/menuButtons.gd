extends Button

export var ref_path = ""
export(bool) var start_focused = false

func _ready():
	if(start_focused):
		grab_focus()
		
	connect("mouse_entered",self,"_shift_focus")
	connect("pressed",self,"_select_button")
	
func _shift_focus():
	grab_focus()

func _select_button():
	if(ref_path != ""):
		get_tree().change_scene(ref_path)
	else:
		get_tree().quit()
