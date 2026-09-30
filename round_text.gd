extends Label

func _ready() -> void:
	GameManager.round_changed.connect(_on_round_changed)


func _on_round_changed(round: int) -> void:
	text = "Round: " + str(round)
