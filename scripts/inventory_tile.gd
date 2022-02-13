extends TextureButton

onready var quantity_label = get_node("item_quantity")
onready var item_sprite = get_node("item_sprite")
var inventory_array = Global.inventory

export(bool) var start_focused = false
var item_name = inventory_array[0][0][0][0]
var item_sprite_path = inventory_array[0][0][0][1]
var item_description = inventory_array[0][0][0][2]

func _ready():		
	if(start_focused):
		_update_item_display()
	connect("mouse_entered",self,"_shift_focus")
	connect("pressed",self,"_update_item_display")

func _shift_focus():
	grab_focus()

func _update_item_display():
	#change the current description to display the corresponding texture + text
	get_node("../item_desc_bg/item_name").bbcode_text = "[center]" + item_name
	get_node("../item_desc_bg/item_sprite").texture = load(item_sprite_path)
	get_node("../item_desc_bg/flavor_text").text = item_description
	print(get_node("../item_desc_bg/item_name"))
	grab_focus()

func _make_empty():
	item_sprite.visible = false
	quantity_label.visible = false

func _fill_tile(quantity, img_path):
	_change_quantity(quantity)
	_change_sprite(img_path)

func _change_quantity(new_quantity):
	item_sprite.visible = true
	quantity_label.text = str(new_quantity)

func _change_sprite(img_path):
	quantity_label.visible = true
	item_sprite.texture = load(img_path)
