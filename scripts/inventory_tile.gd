extends TextureButton

onready var quantity_label = get_node("item_quantity")
onready var item_sprite = get_node("item_sprite")

export(bool) var start_focused = false
var item_description

func _ready():		
	if(start_focused):
		_open_description()
	connect("mouse_entered",self,"_shift_focus")
	connect("pressed",self,"_open_description")

func _shift_focus():
	grab_focus()

func _open_description():
	#change the current description to display the corresponding texture + text
	grab_focus()

func _make_empty():
	item_sprite.visible = false
	quantity_label.visible = false

func _make_non_empty(quantity, img_path):
	_change_quantity(quantity)
	_change_sprite(img_path)
	
func _update_quantity(add_quantity):
	var current_quantity = int(quantity_label.text)
	var new_quantity = current_quantity + add_quantity
	quantity_label.text = str(new_quantity)

func _change_quantity(new_quantity):
	quantity_label.text = str(new_quantity)

func _change_sprite(img_path):
	item_sprite.texture = load(img_path)
