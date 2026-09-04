@tool
class_name ScrollSnap
extends Panel


const VRAI_FAUX_LABEL: LabelSettings = preload("uid://d1vjfptcqamq7")


@export var show_item: int = 0: set = _set_show_item


var items: Array[DataAccess.VraiFauxQuestion]: set = _set_items
var items_position_y: Array[int]
var label_items: Array[Label]
var focused_item: Label


@onready var elements_vbox: VBoxContainer = %ElementsVbox


func _ready() -> void:
	_update_elements_v_box()


func _focus_item(item_index: int) -> void:
	if item_index >= items.size():
		return
	if item_index < -items.size():
		return
	
	var tween := get_tree().create_tween()
	tween.set_parallel()
	
	#if focused_item:
		#tween.tween_property(focused_item, "modulate", Color.LIGHT_GRAY, 0.2)
	
	focused_item = label_items[item_index]
	
	var lbl_pos = focused_item.position
	var offset = (size.y / 2) - (focused_item.size.y / 2)
	var new_offset = -lbl_pos.y + offset
	tween.tween_property(elements_vbox, "offset_top", new_offset, 0.2)
	tween.tween_property(focused_item, "modulate", Color.BLACK, 0.2)


func _update_elements_v_box() -> void:
	if not elements_vbox:
		return
	
	for child in elements_vbox.get_children():
		child.queue_free()
	
	label_items = []
	for item in items:
		var new_item := Label.new()
		new_item.text = item.titre
		new_item.label_settings = VRAI_FAUX_LABEL.duplicate(true)
		new_item.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		new_item.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		new_item.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		new_item.modulate = Color.LIGHT_GRAY
		elements_vbox.add_child(new_item, false, Node.INTERNAL_MODE_BACK)
		label_items.append(new_item)


func show_item_rep(item_index: int) -> void:
	if items[item_index].reponse:
		set_item_right(item_index)
	else:
		set_item_wrong(item_index)


func set_item_wrong(item_index: int) -> void:
	label_items[item_index].modulate = Color.FIREBRICK


func set_item_right(item_index: int) -> void:
	label_items[item_index].modulate = Color.WEB_GREEN


func _set_show_item(value) -> void:
	value = clamp(value, -items.size(), items.size() - 1)
	show_item = value
	_focus_item(value)


func _set_items(value) -> void:
	items = value
	_update_elements_v_box()
