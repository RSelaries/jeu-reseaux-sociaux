extends Control


@onready var tab_container: TabContainer = $TabContainer

@onready var famille_1_nom: LineEdit = %Famille1Nom
@onready var famille_2_nom: LineEdit = %Famille2Nom


func _ready() -> void:
	tab_container.current_tab = 0
	ScoreManager.score_scene.hide()
	ScoreManager.score_scene.scores.hide()
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	ReponseManager.maitre_jeu_rep_validee.connect(_on_mtr_jeu_rep)


func _on_mtr_jeu_rep(_rep) -> void:
	_on_start_button_pressed()


func _on_start_button_pressed() -> void:
	tab_container.current_tab = 1
	ScoreManager.score_scene.show()
	famille_1_nom.grab_focus()


func _on_famille_1_nom_text_submitted(new_text: String) -> void:
	ScoreManager.nom_famille_1 = new_text
	famille_2_nom.grab_focus()

func _on_famille_2_nom_text_submitted(new_text: String) -> void:
	ScoreManager.nom_famille_2 = new_text
	ScoreManager.score_scene.scores.show()
	get_tree().change_scene_to_file("res://scenes/game_scene/game_scene.tscn")
