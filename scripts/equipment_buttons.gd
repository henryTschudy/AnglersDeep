extends Button

export(bool) var start_focused = false
var inventory_array = Global.inventory
onready var equipment_manager = get_node("../../../Node2D")
onready var item_name_label = get_node("../item_name")

func _ready():
	if(start_focused):
		grab_focus()
		
	connect("mouse_entered",self,"_shift_focus")
	connect("pressed",self,"_select_button")

func _shift_focus():
	pass
#	print(selected_tile_item_name)
#	self.visible = false
#	self.disabled = true
#	if(normal == theme.normal)
#	grab_focus()

func _select_button():
#	var selected_tile_item = Global.inventory.get("equipment").get(item_name_label.text)
#	equipment_manager.equip_item(selected_tile_item)
	equipment_manager.equip_item(item_name_label.text)
#	grab_focus()
#	self.visible = false
#	self.disabled = true
	#update inventory_tiles and update item_display
	
