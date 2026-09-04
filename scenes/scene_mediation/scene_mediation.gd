class_name SceneMediation
extends Control


@export var text_mediation: String


var parent_template: Template


@onready var text_mediation_label: RichTextLabel = %TextMediation


func _ready() -> void:
	text_mediation_label.text = text_mediation
	ReponseManager.maitre_jeu_rep_validee.connect(_on_maitre_jeu_rep_validee)


func _on_maitre_jeu_rep_validee(_reponse_correcte: bool) -> void:
	ReponseManager.reponse_completed.emit()
	parent_template.question_finished.emit()
