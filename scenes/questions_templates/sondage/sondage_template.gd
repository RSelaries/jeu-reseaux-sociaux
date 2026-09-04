class_name SondageTemplate
extends Template


var full_questions: Array[String]
var wait_mtr_jeu_rep: bool = false


var current_question: int = 0:
	set(value):
		current_question = value
		if value < full_questions.size() / 2.0:
			current_famille = 1
		else:
			current_famille = 2
var current_famille: int = 1:
	set(value):
		current_famille = value
		current_famille_tab.current_tab = value - 1


@onready var question_titre: Label = %QuestionTitre
@onready var enfant_reponse: LineEdit = %EnfantReponse
@onready var parent_reponse: LineEdit = %ParentReponse
@onready var current_famille_tab: TabContainer = %CurrentFamilleTab


static func generate_sondage_streak(strk_size:int = 6) -> SondageTemplate:
	var new_sondage: SondageTemplate = DataAccess.sondage_scene.instantiate()
	var questions := DataAccess.get_sondage_streak(strk_size)
	new_sondage.full_questions = questions
	return new_sondage


func _ready() -> void:
	enfant_reponse.text_submitted.connect(_on_enfant_rep_submited)
	parent_reponse.text_submitted.connect(_on_parent_rep_submited)
	ReponseManager.maitre_jeu_rep_validee.connect(_on_mtr_jeu_rep)
	_start_question()
	print("Ready fired !")


func _on_mtr_jeu_rep(validee: bool) -> void:
	if wait_mtr_jeu_rep:
		wait_mtr_jeu_rep = false
		if validee: _handle_bonne_reponse()
		else: _handle_mauvaise_rep()


func _handle_bonne_reponse() -> void:
	if current_famille == 1:
		ScoreManager.famille_1_score += 1
	elif current_famille == 2:
		ScoreManager.famille_2_score +=1
	next_question()


func _handle_mauvaise_rep() -> void:
	next_question()


func next_question() -> void:
	current_question += 1
	if current_question == full_questions.size():
		question_finished.emit()
		return
	_start_question()


func _start_question() -> void:
	print("current_question : ", current_question)
	enfant_reponse.text = ""
	enfant_reponse.secret = false
	parent_reponse.text = ""
	var qust_text := full_questions[current_question]
	question_titre.text = qust_text
	enfant_reponse.grab_focus()


func _on_enfant_rep_submited(_t: String) -> void:
	enfant_reponse.secret = true
	parent_reponse.grab_focus()

func _on_parent_rep_submited(_t: String) -> void:
	pass
	wait_mtr_jeu_rep = true
	enfant_reponse.secret = false
