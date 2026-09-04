@tool
class_name LevelsScene
extends Control


signal commencer_niveau(niveau: int)
signal current_level_finished
signal next_level_unlocked


@export var parcour: Parcour = preload("res://data/parcours/parcour_defaut.tres"):
	set(value):
		parcour = value
		if levels_container:
			_update_levels()


var current_level: int = 0
var in_tree: bool = false


@onready var levels_container: Control = %LevelsContainer


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_update_levels()
	DebugScene.restart.connect(restart)
	ReponseManager.maitre_jeu_rep_validee.connect(_on_mtr_jeu_input)


func _enter_tree() -> void:
	in_tree = true
func _exit_tree() -> void:
	in_tree = false


func _notification(what):
	if (what == NOTIFICATION_PREDELETE):
		print("Being freed !")
		LevelsManager.level_scene_freed()


func restart() -> void:
	queue_free()


func next_level() -> void:
	current_level_finished.emit()
	next_level_unlocked.emit()
	current_level += 1


func _on_mtr_jeu_input(_in: bool) -> void:
	if in_tree:
		commencer_niveau.emit(current_level)


func _set_current_level(value) -> void:
	current_level = value


func _update_levels() -> void:
	if !parcour:
		return
	
	for i: int in range(parcour.niveaux.size()):
		var level: Level = levels_container.get_child(i)
		
		level.dernier_niv = i+1 == parcour.niveaux.size()
		level.level_nbr = i
		level.set_level_type(parcour.niveaux[i].level_type)
