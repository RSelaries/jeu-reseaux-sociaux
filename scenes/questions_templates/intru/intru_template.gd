class_name IntruTemplate
extends Template


const REPONSE_CORRECTE = Color("#60c400")
const REPONSE_INCORRECTE = Color("#ff7a61")


var intru_question: DataAccess.IntruQuestion


@onready var element_1: TextureRect = %Element1
@onready var element_2: TextureRect = %Element2
@onready var element_3: TextureRect = %Element3
@onready var element_4: TextureRect = %Element4

@onready var element_1_rep: ColorRect = %Element1Rep
@onready var element_2_rep: ColorRect = %Element2Rep
@onready var element_3_rep: ColorRect = %Element3Rep
@onready var element_4_rep: ColorRect = %Element4Rep


static func generate_intru_streak() -> IntruTemplate:
	var intru_scene := DataAccess.intru_scene
	var new_intru_scene: IntruTemplate = intru_scene.instantiate()
	return new_intru_scene


func _ready() -> void:
	ReponseManager.reponse_event.connect(_on_reponse_event)
	_next_question()


func _on_reponse_event(reponse_value: int, famille_index: int) -> void:
	if reponse_value == intru_question.intru:
		if famille_index == 1: ScoreManager.famille_1_score += 1
		else: ScoreManager.famille_2_score += 1
		_handle_reponse_correcte(reponse_value)
	else:
		if famille_index == 1: ReponseManager.penalite_rep_fam_1 = true
		else: ReponseManager.penalite_rep_fam_2 = true
		_handle_reponse_incorrecte(reponse_value)


func _handle_reponse_correcte(_rep_index: int) -> void:
	element_1_rep.color = REPONSE_INCORRECTE if _rep_index != 1 else REPONSE_CORRECTE
	element_2_rep.color = REPONSE_INCORRECTE if _rep_index != 2 else REPONSE_CORRECTE
	element_3_rep.color = REPONSE_INCORRECTE if _rep_index != 3 else REPONSE_CORRECTE
	element_4_rep.color = REPONSE_INCORRECTE if _rep_index != 4 else REPONSE_CORRECTE
	await get_tree().create_timer(1.5).timeout
	var text_mediation := intru_question.text_mediation
	if text_mediation != "":
		var mediation: SceneMediation = scene_mediation.instantiate()
		mediation.text_mediation = text_mediation
		mediation.parent_template = self
		add_child(mediation)
	else:
		ReponseManager.reponse_en_cours = false
		question_finished.emit()


func _handle_reponse_incorrecte(rep_index: int) -> void:
	match rep_index:
		1: element_1_rep.color = REPONSE_INCORRECTE
		2: element_2_rep.color = REPONSE_INCORRECTE
		3: element_3_rep.color = REPONSE_INCORRECTE
		4: element_4_rep.color = REPONSE_INCORRECTE
	ReponseManager.reponse_en_cours = false


func _next_question() -> void:
	var question := intru_question
	element_1.texture = load(_get_path(question.element_1_img))
	element_2.texture = load(_get_path(question.element_2_img))
	element_3.texture = load(_get_path(question.element_3_img))
	element_4.texture = load(_get_path(question.element_4_img))
	
	element_1_rep.color = Color(0, 0, 0, 0)
	element_2_rep.color = Color(0, 0, 0, 0)
	element_3_rep.color = Color(0, 0, 0, 0)
	element_4_rep.color = Color(0, 0, 0, 0)


func _get_path(base_path: String) -> String:
	return "res://assets/images_intru/" + base_path
