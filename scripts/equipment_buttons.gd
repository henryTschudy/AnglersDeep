extends Button

export(bool) var start_focused = false
var inventory_array = Global.inventory

func _ready():
	if(start_focused):
		grab_focus()
		
	connect("mouse_entered",self,"_shift_focus")
	connect("pressed",self,"_select_button")

func _shift_focus():
	print(get_stylebox("normal") == get_stylebox("pressed"))
	self.visible = false
	self.disabled = true
#	if(normal == theme.normal)
#	grab_focus()

func _select_button():
#	grab_focus()
	self.visible = false
	self.disabled = true
	#update inventory_tiles and update item_display
	
