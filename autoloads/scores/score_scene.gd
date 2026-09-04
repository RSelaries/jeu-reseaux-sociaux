class_name ScoreScene
extends CanvasLayer


enum DisplayPositions { BOTTOM_BAR, TOP_SCORE }

@export var display_positions: DisplayPositions


@onready var famille_1_progress: ColorRect = %Famille1Progress
@onready var famille_2_progress: ColorRect = %Famille2Progress

@onready var famille_1_score_label: Label = %Famille1ScoreLabel
@onready var famille_2_score_label: Label = %Famille2ScoreLabel

@onready var famille_1_nom: Label = %Famille1Nom
@onready var famille_2_nom: Label = %Famille2Nom

@onready var scores: Control = %Scores


func _ready() -> void:
	ScoreManager.scores_changed.connect(_on_scores_changed)
	famille_1_nom.text = ScoreManager.nom_famille_1.to_upper()
	famille_2_nom.text = ScoreManager.nom_famille_2.to_upper()
	_on_scores_changed()


func _on_scores_changed() -> void:
	famille_1_score_label.text = str(ScoreManager.famille_1_score)
	famille_2_score_label.text = str(ScoreManager.famille_2_score)
	if ScoreManager.famille_1_score == 0 and ScoreManager.famille_2_score == 0:
		_set_famille_1_percent(0.5)
	else:
		var score_total = ScoreManager.famille_1_score + ScoreManager.famille_2_score
		var fam_1_scr_percent: float = ScoreManager.famille_1_score / float(score_total)
		fam_1_scr_percent = clamp(fam_1_scr_percent, 0.05, 0.95)
		_set_famille_1_percent(fam_1_scr_percent)
	


func _set_famille_1_percent(percent: float) -> void:
	#var full = famille_1_progress.size.x
	#var pxl_size = full * percent
	famille_1_progress.anchor_right = percent
	famille_2_progress.anchor_left = percent
