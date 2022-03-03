extends TextureButton

onready var quantity_label = get_node("item_quantity")
onready var item_sprite = get_node("item_sprite")
var inventory_array = Global.inventory
var empty

export(bool) var start_focused = false
var fish1key = Global.inventory.get("fish").keys()[0]
var item_name = Global.inventory.get("fish").get(fish1key).get("name")
var item_sprite_path = Global.inventory.get("fish").get(fish1key).get("sprite_path")
var item_description = Global.inventory.get("fish").get(fish1key).get("description")

func _ready():		
	if(start_focused):
		update_item_display()
	connect("mouse_entered",self,"_shift_focus")
	connect("pressed",self,"update_item_display")

func _shift_focus():
	grab_focus()

func update_item_display():
	#change the current item_display to the corresponding name, texture, and description text
	if(!empty):
		get_node("../item_desc_bg/item_name").bbcode_text = "[center]" + item_name
		get_node("../item_desc_bg/item_sprite").texture = load(item_sprite_path)
		get_node("../item_desc_bg/flavor_text").text = item_description
		grab_focus()

func make_empty():
	item_sprite.visible = false
	quantity_label.visible = false
	empty = true

func fill_tile(quantity, img_path):
	change_quantity(quantity)
	change_sprite(img_path)
	empty = false

func change_quantity(new_quantity):
	item_sprite.visible = true
	quantity_label.text = str(new_quantity)

func change_sprite(img_path):
	quantity_label.visible = true
	item_sprite.texture = load(img_path)
