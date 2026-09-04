class_name Template
extends Control


const scene_mediation: PackedScene = preload("uid://bejkcppiuxi0s")


@warning_ignore("unused_signal")
signal question_finished


func _enter_tree() -> void:
	if ReponseManager:
		ReponseManager.reponse_completed.emit()


@export var fond: Control
@export var question_type: DataAccess.QuestionTypes
