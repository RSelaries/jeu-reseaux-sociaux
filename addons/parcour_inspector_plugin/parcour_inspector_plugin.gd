@tool
extends EditorInspectorPlugin


const INSPECT_SCENE := preload("res://addons/parcour_inspector_plugin/parcour_inspect_scene.tscn")


func _can_handle(object: Object) -> bool:
	return object is Parcour


#func _parse_begin(object: Object) -> void:
	#var parcour := object as Parcour
	#add_custom_control(INSPECT_SCENE.instantiate())



func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	# On intercepte la propriété "niveaux"
	if name == "niveaux":
		var inspect_scene_instance := INSPECT_SCENE.instantiate()

		# (Optionnel) : on donne accès à la resource
		if inspect_scene_instance.has_method("set_parcour"):
			inspect_scene_instance.set_parcour(object)

		# On ajoute notre éditeur custom
		add_property_editor(name, inspect_scene_instance)

		# return true = on indique à l’éditeur de ne PAS afficher la propriété par défaut
		return true

	# Sinon, laisser le comportement par défaut
	return false
