@tool
extends EditorPlugin


const InspectorPluginScript = preload("res://addons/parcour_inspector_plugin/parcour_inspector_plugin.gd")
var inspector_plugin


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	inspector_plugin = InspectorPluginScript.new()
	add_inspector_plugin(inspector_plugin)


func _exit_tree() -> void:
	remove_inspector_plugin(inspector_plugin)
