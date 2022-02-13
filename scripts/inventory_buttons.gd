extends Button

export var inventory_type = ""
export(bool) var start_focused = false

func _ready():
	if(start_focused):
		grab_focus()
		
	connect("mouse_entered",self,"_shift_focus")
	connect("pressed",self,"_select_button")

func _shift_focus():
	grab_focus()

func _select_button():
	grab_focus()
	get_parent()._update_inventory_tiles(inventory_type)
