# DataAccess
extends Node

# ===========================
# Data file paths
# ===========================
const qcm_data: CSVData = preload("res://data/qcm_data.csv")
const vrai_faux_data: CSVData = preload("res://data/vrai_faux_data.csv")
const sondage_data: CSVData = preload("res://data/sondage_data.csv")
const intru_data: CSVData = preload("uid://b65hwswxj66xy")
const petit_bac_data: CSVData = preload("uid://colsfkqpu2npt")


# ===========================
# Enum
# ===========================
enum QuestionTypes {
	QCM, PENDU, PETIT_BAC,
	INTRU, SONDAGE, VRAI_FAUX,
	RESEAU_PIXEL, QUESTION_INDICE
}


# ===========================
# Questions Classes
# ===========================
class QCMQuestion:
	var titre: String
	var reponse_1: String
	var reponse_2: String
	var reponse_3: String
	var reponse_4: String
	var reponse_correcte: int
	var reponse_correcte_2: int
	var text_mediation: String

class VraiFauxQuestion:
	static func create(titr: String, rep: bool, txt_med: String = "") -> VraiFauxQuestion:
		var new_quest := VraiFauxQuestion.new()
		new_quest.titre = titr
		new_quest.reponse = rep
		new_quest.text_mediation = txt_med
		return new_quest
	
	var titre: String
	var reponse: bool
	var text_mediation: String

class IntruQuestion:
	var element_1_name: String
	var element_1_img: String
	var element_2_name: String
	var element_2_img: String
	var element_3_name: String
	var element_3_img: String
	var element_4_name: String
	var element_4_img: String
	var intru: int
	var text_mediation: String


# ===========================
# Global Variables
# ===========================

# Scenes
var qcm_scene: PackedScene = preload("uid://cfacdvwshxt3v")
var vrai_faux_scene: PackedScene = preload("uid://dn0xcdvu6gg3s")
var sondage_scene: PackedScene = preload("uid://dlcw1fiuvx3jb")
var intru_scene: PackedScene = preload("uid://c4isehxqm3jet")
var petit_bac_scene: PackedScene = preload("uid://bgq22voepda2o")

# Questions data variables
var qcm_data_array: Array[QCMQuestion]
var vrai_faux_data_array: Array[VraiFauxQuestion]
var sondage_array: Array[String]
var intru_data_array: Array[IntruQuestion]
var petit_bac_array: Array[String]

var qut_arrays: Dictionary[QuestionTypes, String] = {
	QuestionTypes.QCM: "qcm_data_array",
	QuestionTypes.VRAI_FAUX: "vrai_faux_data_array",
	QuestionTypes.SONDAGE: "sondage_array",
	QuestionTypes.INTRU: "intru_data_array",
	QuestionTypes.PETIT_BAC: "petit_bac_array",
}


# ===========================
# Functions
# ===========================
func _ready() -> void:
	_init_question_arrays()
	

func _init_question_arrays() -> void:
	_parse_qcm_array()
	_parse_vrai_faux_array()
	_parse_sondage_array()
	_parse_intru_array()
	_parse_petit_bac()
	
	qcm_data_array.shuffle()
	vrai_faux_data_array.shuffle()
	sondage_array.shuffle()
	intru_data_array.shuffle()
	petit_bac_array.shuffle()


# ==============================================================================
# Getters
# ==============================================================================
func get_qcm_streak(nbr_of_question: int = 7) -> Array[QCMQuestion]:
	var qcm_streak: Array[QCMQuestion]
	for q in get_streak(QuestionTypes.QCM, nbr_of_question):
		qcm_streak.append(q)
	return qcm_streak

func get_vrai_faux_questions(nbr_of_question: int = 10) -> Array[VraiFauxQuestion]:
	var vf_streak: Array[VraiFauxQuestion]
	for q in get_streak(QuestionTypes.VRAI_FAUX, nbr_of_question):
		vf_streak.append(q)
	return vf_streak

func get_sondage_streak(nbr_of_question: int = 6) -> Array[String]:
	var sondage_streak: Array[String]
	for q in get_streak(QuestionTypes.SONDAGE, nbr_of_question):
		sondage_streak.append(q)
	return sondage_streak

func get_intru_streak(nbr_of_question: int = 3) -> Array[IntruQuestion]:
	var intru_streak: Array[IntruQuestion]
	for q in get_streak(QuestionTypes.INTRU, nbr_of_question):
		intru_streak.append(q)
	return intru_streak


func get_petit_bac_streak(nbr_of_theme: int = 3) -> Array[String]:
	var petit_bac_streak: Array[String]
	for theme in get_streak(QuestionTypes.PETIT_BAC, nbr_of_theme):
		petit_bac_streak.append(theme)
	return petit_bac_streak


func get_streak(question_type: QuestionTypes, nbr_of_question: int) -> Array[Variant]:
	var question_type_name = QuestionTypes.find_key(question_type)
	var question_array: Array = get(qut_arrays[question_type])
	var new_array: Array
	for i in range(nbr_of_question):
		if question_array.size() > 0:
			new_array.append(question_array.pop_back())
		else:
			push_error("No remaining question in ", question_type_name, ".")
			break
	return new_array


# ==============================================================================
# Parsing
# ==============================================================================
func _parse_qcm_array() -> void:
	var raw_array: Array[Dictionary] = qcm_data.records
	qcm_data_array.clear()
	for question in raw_array:
		var new_qcm_question := QCMQuestion.new()
		new_qcm_question.titre = question.titre
		new_qcm_question.reponse_1 = question.reponse_1
		new_qcm_question.reponse_2 = question.reponse_2
		new_qcm_question.reponse_3 = question.reponse_3
		new_qcm_question.reponse_4 = question.reponse_4
		new_qcm_question.reponse_correcte = question.reponse_correcte
		new_qcm_question.reponse_correcte_2 = question.reponse_correcte_2
		new_qcm_question.text_mediation = question.text_mediation
		qcm_data_array.append(new_qcm_question)


func _parse_vrai_faux_array() -> void:
	var raw_array: Array[Dictionary] = vrai_faux_data.records
	vrai_faux_data_array.clear()
	for question in raw_array:
		var new_vf_question := VraiFauxQuestion.new()
		new_vf_question.titre = question.titre
		new_vf_question.reponse = true if question.reponse.contains("TRUE") else false
		new_vf_question.text_mediation = question.text_mediation
		vrai_faux_data_array.append(new_vf_question)


func _parse_sondage_array() -> void:
	var raw_sondage_array: Array[Dictionary] = sondage_data.records
	sondage_array.clear()
	for question in raw_sondage_array:
		sondage_array.append(question.question)


func _parse_intru_array() -> void:
	var raw_intru_array: Array[Dictionary] = intru_data.records
	intru_data_array.clear()
	for question in raw_intru_array:
		var new_intru_quest := IntruQuestion.new()
		new_intru_quest.element_1_name = question.element_1_nom
		new_intru_quest.element_1_img = question.element_1_image
		new_intru_quest.element_2_name = question.element_2_nom
		new_intru_quest.element_2_img = question.element_2_image
		new_intru_quest.element_3_name = question.element_3_nom
		new_intru_quest.element_3_img = question.element_3_image
		new_intru_quest.element_4_name = question.element_4_nom
		new_intru_quest.element_4_img = question.element_4_image
		new_intru_quest.intru = question.intru
		new_intru_quest.text_mediation = question.text_mediation
		intru_data_array.append(new_intru_quest)


func _parse_petit_bac() -> void:
	var raw_petit_bac: Array[Dictionary] = petit_bac_data.records
	petit_bac_array.clear()
	for question in raw_petit_bac:
		petit_bac_array.append(question.theme)
