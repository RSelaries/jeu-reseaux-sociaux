@tool
class_name Parcour
extends Resource


@export var niveaux: Array[LevelResource]


func _init() -> void:
	#notify_property_list_changed()
	niveaux.resize(11)


func _property_can_revert(property: StringName) -> bool:
	return property == "niveaux"


func _property_get_revert(property: StringName) -> Variant:
	if property == "niveaux":
		var default_level := LevelResource.new()
		var default_array: Array[LevelResource]
		default_array.resize(11)
		default_array.fill(default_level)
		return default_array
	else:
		return null
