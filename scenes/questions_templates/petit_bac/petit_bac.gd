extends Control


const LETTRES = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const ROUNDS_PAR_THEME = 4


signal next_theme


var pause: bool = false
var current_response_family: int
var current_letter_count: int = 0:
	set(value):
		if value > ROUNDS_PAR_THEME:
			current_letter_count = 1
			next_theme.emit()
		else:
			current_letter_count = value
		print("Set current_letter_count to:", current_letter_count)


@onready var lettre: Label = %Lettre
@onready var pause_panel: Panel = %Pause
@onready var famille_label: Label = %FamilleLabel


func _ready() -> void:
	ReponseManager.reponse_event.connect(_on_reponse_event)
	ReponseManager.maitre_jeu_rep_validee.connect(_on_mtr_jeu_rep)
	visibility_changed.connect(_on_visibility_changed)
	_on_visibility_changed()


func _on_visibility_changed() -> void:
	if visible: nvelle_lettre()


func nvelle_lettre() -> void:
	current_letter_count += 1
	pause = false
	pause_panel.hide()
	lettre.text = LETTRES[randi_range(0, 25)]


func _on_reponse_event(_rep: int, famille:int) -> void:
	if not visible or pause:
		ReponseManager.reponse_en_cours = false
		return
	
	if famille == 1:
		famille_label.text = ScoreManager.nom_famille_1
		current_response_family = 1
	else:
		famille_label.text = ScoreManager.nom_famille_2
		current_response_family = 2
	
	pause_panel.show()
	pause = true


func _on_mtr_jeu_rep(rep: bool) -> void:
	if not pause: return
	
	if rep: # Si le maitre du jeu juge la réponse correcte
		if current_response_family == 1:
			ScoreManager.famille_1_score += 1
		else:
			ScoreManager.famille_2_score += 1
	else: # Si le maitre du jeu juge la réponse incorrecte
		pass
	ReponseManager.reponse_en_cours = false
	
	nvelle_lettre()
