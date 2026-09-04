class_name GameScene
extends Control


var current_question_scene: Template


func _ready() -> void:
	if LevelsManager.levels_scene:
		_change_child(LevelsManager.levels_scene)
	LevelsManager.levels_scene.commencer_niveau.connect(_on_commencer_niveau)


func _generate_qcm_streak() -> void:
	var new_qcm_streak := QcmStreakTemplate.generate_rdm_qcm_streak()
	_change_child(new_qcm_streak)

func _generate_vf_streak() -> void:
	var new_vf = VraiFauxTemplate.generate_rdm_vrai_faux()
	_change_child(new_vf)

func _generate_sondage_streak() -> void:
	var new_sondage = SondageTemplate.generate_sondage_streak()
	_change_child(new_sondage)

func _generate_intru_streak() -> void:
	var new_intru := IntruStreak.generate_intru_streak()
	_change_child(new_intru)


func _generate_petit_bac_streak() -> void:
	var new_petit_bac := PetitBacTemplate.generate_petit_bac()
	_change_child(new_petit_bac)


func _change_child(new_child: Node) -> void:
	for child in get_children():
		if child is LevelsScene:
			remove_child(child)
		else:
			child.queue_free()
	
	if new_child is Template:
		new_child.question_finished.connect(_on_question_finished)
	add_child(new_child)


func _on_question_finished() -> void:
	_change_child(LevelsManager.levels_scene)
	LevelsManager.next_level()


func _on_commencer_niveau(niveau: int) -> void:
	match LevelsManager.levels_scene.parcour.niveaux[niveau].level_type:
		DataAccess.QuestionTypes.QCM: _generate_qcm_streak()
		DataAccess.QuestionTypes.VRAI_FAUX: _generate_vf_streak()
		DataAccess.QuestionTypes.SONDAGE: _generate_sondage_streak()
		DataAccess.QuestionTypes.INTRU: _generate_intru_streak()
		DataAccess.QuestionTypes.PETIT_BAC: _generate_petit_bac_streak()
		
		# Faire le reste
		#DataAccess.QuestionTypes.PENDU: pass
		#DataAccess.QuestionTypes.QUESTION_INDICE: pass
		#DataAccess.QuestionTypes.RESEAU_PIXEL: pass
