class_name VraiFauxTemplate
extends Template


@onready var scroll_snap: ScrollSnap = %ScrollSnap
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var vf_questions: Array[DataAccess.VraiFauxQuestion]
var current_question: int = 0


static func generate_rdm_vrai_faux() -> VraiFauxTemplate:
	var new_vf_scene: VraiFauxTemplate = DataAccess.vrai_faux_scene.instantiate()
	new_vf_scene.vf_questions = DataAccess.get_vrai_faux_questions()
	return new_vf_scene


func _ready() -> void:
	ReponseManager.reponse_event.connect(_on_reponse_event)
	if vf_questions.size() == 0:
		vf_questions = DataAccess.get_vrai_faux_questions()
	scroll_snap.items = vf_questions
	
	await get_tree().create_timer(0).timeout
	scroll_snap._set_show_item(0)


func _next_vf() -> void:
	current_question += 1
	scroll_snap.show_item += 1
	
	await get_tree().create_timer(0.2).timeout
	animation_player.play("RESET")
	ReponseManager.reponse_en_cours = false


func _on_reponse_event(reponse: int, famille: int) -> void:
	#if current_question == vf_questions.size() - 1:
		#ReponseManager.reponse_completed.emit()
	
	var bool_rep: bool = reponse in [1, 2]
	
	# Réponse correcte
	if bool_rep == vf_questions[current_question].reponse:
		if famille == 1:
			ScoreManager.famille_1_score += 1
			animation_player.play("correcte_1")
		else:
			ScoreManager.famille_2_score += 1
			animation_player.play("correcte_2")
		scroll_snap.show_item_rep(current_question)
	else: # Réponse incorrecte
		if famille == 1:
			ScoreManager.famille_2_score += 1
			animation_player.play("fausse_1")
		else:
			ScoreManager.famille_1_score += 1
			animation_player.play("fausse_2")
		scroll_snap.show_item_rep(current_question)
	
	if current_question == vf_questions.size() - 1:
		await get_tree().create_timer(1).timeout
		ReponseManager.reponse_completed.emit()
		question_finished.emit()
	else:
		_next_vf()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("famille_1_reponse_3"):
		print("apuuyé sur 1")
