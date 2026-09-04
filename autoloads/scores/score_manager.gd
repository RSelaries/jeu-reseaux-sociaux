# ScoreManager
extends Node


signal scores_changed


var famille_1_score: int = 0: set = _set_famille_1_score
var famille_2_score: int = 0: set = _set_famille_2_score

var nom_famille_1: String: set = _set_nom_famille_1
var nom_famille_2: String: set = _set_nom_famille_2

const score_packed_scene: PackedScene = preload("uid://c8gykulw8b7gx")
var score_scene: ScoreScene


func _ready() -> void:
	add_score_scene()
	DebugScene.restart.connect(restart)


func restart() -> void:
	nom_famille_1 = ""
	nom_famille_2 = ""
	famille_1_score = 0
	famille_2_score = 0


func _set_famille_1_score(value: int) -> void:
	famille_1_score = value
	scores_changed.emit()
func _set_famille_2_score(value: int) -> void:
	famille_2_score = value
	scores_changed.emit()

func _set_nom_famille_1(value: String) -> void:
	nom_famille_1 = value
	if score_scene:
		score_scene.famille_1_nom.text = value.to_upper()
func _set_nom_famille_2(value: String) -> void:
	nom_famille_2 = value
	if score_scene:
		score_scene.famille_2_nom.text = value.to_upper()


func add_score_scene() -> void:
	var new_score_scene: ScoreScene = score_packed_scene.instantiate()
	score_scene = new_score_scene
	add_child(new_score_scene)
