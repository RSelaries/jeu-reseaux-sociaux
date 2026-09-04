# ReponseManager
extends Node


signal reponse_event(reponse_value: int, famille_index: int)
signal maitre_jeu_rep_validee(reponse_correcte: bool)
signal reponse_completed


var reponse_en_cours: bool = false
var penalite_rep_fam_1: bool = false: set = _set_penalite_rep_fam_1
var penalite_rep_fam_2: bool = false: set = _set_penalite_rep_fam_2
var temps_penalite: float = 3.0


@onready var _famille_1_penalite: TextureProgressBar = %Famille1Penalite
@onready var _famille_2_penalite: TextureProgressBar = %Famille2Penalite


func _ready() -> void:
	reponse_completed.connect(_on_reponse_completed)
	await get_tree().create_timer(0).timeout
	DebugScene.restart.connect(restart)
	#DebugScene.watch_property(self, "reponse_en_cours")
	#DebugScene.watch_property(self, "penalite_rep_fam_1")
	#DebugScene.watch_property(self, "penalite_rep_fam_2")


func restart() -> void:
	reponse_en_cours = false
	penalite_rep_fam_1 = false
	penalite_rep_fam_2 = false
	temps_penalite = 3.0


func _unhandled_input(event: InputEvent) -> void:
	var action:String = _what_action_is_event(event)
	if action == "":
		return
	
	match action:
		# Famille 1
		"famille_1_reponse_1": _handle_famille_input(1, 1)
		"famille_1_reponse_2": _handle_famille_input(2, 1)
		"famille_1_reponse_3": _handle_famille_input(3, 1)
		"famille_1_reponse_4": _handle_famille_input(4, 1)
		
		# Famille 2
		"famille_2_reponse_1": _handle_famille_input(1, 2)
		"famille_2_reponse_2": _handle_famille_input(2, 2)
		"famille_2_reponse_3": _handle_famille_input(3, 2)
		"famille_2_reponse_4": _handle_famille_input(4, 2)
		
		# Maître du jeu
		"maitre_jeu_correct": _handle_maitre_jeu_input(true)
		"maitre_jeu_incorrect": _handle_maitre_jeu_input(false)


func _handle_famille_input(reponse: int, famille: int) -> void:
	#print("\nIncomming input : ", reponse, " from familly : ", famille)
	if reponse_en_cours:
		#print("A reponse input is already being processed. Aborting.")
		return
	if famille == 1 and penalite_rep_fam_1:
		#print("Famille 1 gave an answer while being under a penalty.")
		return
	if famille == 2 and penalite_rep_fam_2:
		#print("Famille 2 gave an answer while being under a penalty.")
		return
	
	reponse_en_cours = true
	#print("Emited reponse : ", reponse, " by famille :", famille)
	reponse_event.emit(reponse, famille)


func _set_penalite_rep_fam_1(value) -> void:
	penalite_rep_fam_1 = value
	if value:
		_famille_1_penalite.value = 1.0
		var tween := get_tree().create_tween()
		tween.tween_property(_famille_1_penalite, "value", 0.0, temps_penalite)
		await get_tree().create_timer(temps_penalite).timeout
		penalite_rep_fam_1 = false


func _set_penalite_rep_fam_2(value) -> void:
	penalite_rep_fam_2 = value
	if value:
		_famille_2_penalite.value = 1.0
		var tween := get_tree().create_tween()
		tween.tween_property(_famille_2_penalite, "value", 0.0, temps_penalite)
		await get_tree().create_timer(temps_penalite).timeout
		penalite_rep_fam_2 = false


func _on_reponse_completed() -> void:
	reponse_en_cours = false
	penalite_rep_fam_1 = false
	penalite_rep_fam_2 = false


func _handle_maitre_jeu_input(correct: bool) -> void:
	maitre_jeu_rep_validee.emit(correct)


func _what_action_is_event(event: InputEvent) -> String:
	for action in InputMap.get_actions():
		if event.is_action_pressed(action):
			return action
	return ""
