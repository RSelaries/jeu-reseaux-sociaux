@tool
class_name QCMTemplate
extends Template


@export var titre: String = "Titre de Question":
	set(value):
		titre = value
		_update_texts()
@export var reponse_1: String = "Réponse 1":
	set(value):
		reponse_1 = value
		_update_texts()
@export var reponse_2: String = "Réponse 2":
	set(value):
		reponse_2 = value
		_update_texts()
@export var reponse_3: String = "Réponse 3":
	set(value):
		reponse_3 = value
		_update_texts()
@export var reponse_4: String = "Réponse 4":
	set(value):
		reponse_4 = value
		_update_texts()
@export_range(1, 4) var reponse_correcte: int
@export_range(1, 4) var reponse_correcte_2: int
@export var text_mediation: String


var game_scene: GameScene
var reponses_visibles: bool = false


@onready var titre_label: Label = %TitreLabel
@onready var arrangement_boutons: QCMArrangementBoutons = %ArrangementBoutons


static func generate_qcm(qcm_data: DataAccess.QCMQuestion = null) -> QCMTemplate:
	var new_qcm_scene: QCMTemplate = DataAccess.qcm_scene.instantiate()
	if qcm_data == null:
		qcm_data = DataAccess.get_qcm_question()
	new_qcm_scene.titre = qcm_data.titre
	new_qcm_scene.reponse_1 = qcm_data.reponse_1
	new_qcm_scene.reponse_2 = qcm_data.reponse_2
	new_qcm_scene.reponse_3 = qcm_data.reponse_3
	new_qcm_scene.reponse_4 = qcm_data.reponse_4
	new_qcm_scene.reponse_correcte = qcm_data.reponse_correcte
	new_qcm_scene.reponse_correcte_2 = qcm_data.reponse_correcte_2
	new_qcm_scene.text_mediation = qcm_data.text_mediation
	return new_qcm_scene


func _ready() -> void:
	_update_texts()
	arrangement_boutons.reponse_selectionee.connect(_on_arrangement_rep_select)
	ReponseManager.reponse_event.connect(_on_reponse_event)
	
	reponses_visibles = false
	
	# Attendre 3s avant de montrer les reps
	arrangement_boutons.hide()
	await get_tree().create_timer(3.0).timeout
	reponses_visibles = true
	arrangement_boutons.show()
	_update_texts()


func _update_texts() -> void:
	if arrangement_boutons:
		titre_label.text = titre
		var button_texts: Array[String] = [reponse_1, reponse_2, reponse_3, reponse_4]
		arrangement_boutons.update_buttons_text(button_texts)


func _on_arrangement_rep_select(rep_i: int) -> void:
	print("Manuellement selectionné la réponse : ", rep_i)


func _on_reponse_event(reponse_value: int, famille_index: int) -> void:
	if not reponses_visibles:
		ReponseManager.reponse_en_cours = false
		return
	
	if reponse_value == reponse_correcte:
		if famille_index == 1:
			ScoreManager.famille_1_score += 1
			_handle_reponse_correcte()
		elif famille_index == 2:
			ScoreManager.famille_2_score += 1
			_handle_reponse_correcte()
	else:
		_handle_reponse_fausse(reponse_value)
		if famille_index == 1:
			ReponseManager.penalite_rep_fam_1 = true
		elif famille_index == 2:
			ReponseManager.penalite_rep_fam_2 = true


func _handle_reponse_correcte() -> void:
	arrangement_boutons.show_correct_button(reponse_correcte)
	await get_tree().create_timer(2.0).timeout
	
	if text_mediation != "":
		var mediation: SceneMediation = scene_mediation.instantiate()
		mediation.text_mediation = text_mediation
		mediation.parent_template = self
		add_child(mediation)
	else:
		ReponseManager.reponse_completed.emit()
		question_finished.emit()


func _handle_reponse_fausse(reponse_index) -> void:
	arrangement_boutons.disable_button(reponse_index)
	ReponseManager.reponse_en_cours = false
