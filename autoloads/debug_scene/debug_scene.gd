# DebugScene
extends Node


@warning_ignore("unused_signal")
signal restart

@export var enabled: bool = false

@onready var prop_list: ItemList = %PropList


class WatchedProp:
	func _init(n: Node, p: NodePath, id: int) -> void:
		self.node = n
		self.path = p
		self.item_id = id
	var node: Node
	var path: NodePath
	var item_id: int


var whatched_props: Array[WatchedProp] = []


func _ready() -> void:
	$CanvasLayer.visible = enabled


func _process(_d: float) -> void:
	if not enabled:
		return
	
	if not prop_list or whatched_props.size() == 0:
		return
	
	for prop in whatched_props:
		var prop_value = prop.node.get_indexed(prop.path)
		if prop_list.get_item_text(prop.item_id):
			var item_text := str(prop.path) + " : " + str(prop_value)
			prop_list.set_item_text(prop.item_id, item_text)


func watch_property(from: Node, prop: NodePath) -> void:
	var new_prop := WatchedProp.new(from, prop, whatched_props.size())
	prop_list.add_item(str(new_prop.path) + " : " + str(new_prop.node.get_indexed(new_prop.path)))
	whatched_props.append(new_prop)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_menu"):
		if enabled:
			$CanvasLayer.visible = !$CanvasLayer.visible
		else:
			$CanvasLayer.visible = false


func _on_restart_button_pressed() -> void:
	restart.emit()
	get_tree().change_scene_to_file("res://scenes/start_scene/start_scene.tscn")
