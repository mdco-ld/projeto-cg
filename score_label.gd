extends Label
var score = 0

func _on_player_catch() -> void:
	score += 1
	text = "Pontos: %s" % score
