
extends Control

export var BoxColumns = 2
export var PageAmount = 8

onready var Sbox1 = get_node("Storage1/SelectBox")
onready var Sbox2 = get_node("Storage2/SelectBox")
onready var tween1 = get_node("Storage1/Tween")
onready var tween2 = get_node("Storage2/Tween")

var blue = 0
var red = 0


func _ready():
	get_node("Storage1").set_pos(Vector2(20 - get_node("Storage1/StorageBackground1").get_size().x, 45))
	get_node("Storage2").set_pos(Vector2(OS.get_window_size().x - 20, 45))


func update_boxes():
	Sbox1.update_config(get_parent().mon_depo, PageAmount, BoxColumns)
	Sbox1.generate_members()
	Sbox2.update_config(get_parent().mon_depo, PageAmount, BoxColumns)
	Sbox2.generate_members()


func _on_Breed_pressed():
	Sbox1.clean_box()
	Sbox2.clean_box()
	update_boxes()


func _on_Back_pressed():
	self.hide()
	Sbox1.clean_box()
	Sbox2.clean_box()
	get_parent().get_node("VBox").show()
	get_parent().get_node("FarmBackground").show()



func _on_StorageBackground1_pressed():
	var stor = get_node("Storage1")
	var bg = get_node("Storage1/StorageBackground1")

	if blue == 0:
		tween1.interpolate_property(stor, "rect/pos", stor.get_pos(), stor.get_pos() + Vector2(bg.get_size().x - 20, 0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	else:
		tween1.interpolate_property(stor, "rect/pos", stor.get_pos(), stor.get_pos() - Vector2(bg.get_size().x - 20, 0), 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween1.start()

	blue = (blue + 1) % 2

func _on_StorageBackground2_pressed():
	var stor = get_node("Storage2")
	var bg = get_node("Storage2/StorageBackground2")

	if red == 0:
		tween2.interpolate_property(stor, "rect/pos", stor.get_pos(), stor.get_pos() - Vector2(bg.get_size().x - 20, 0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	else:
		tween2.interpolate_property(stor, "rect/pos", stor.get_pos(), stor.get_pos() + Vector2(bg.get_size().x - 20, 0), 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween2.start()

	red = (red + 1) % 2