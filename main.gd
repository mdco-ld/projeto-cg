extends Node3D

var mob_scene = preload("res://mob.tscn")
var amigo_scene = preload("res://amigo.tscn")

var health = 5
var score = 0

func _ready():
	$UserInterface/RetryScreen.hide()
	$UserInterface/NextLevelScreen.hide()

func _on_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	var mob_spawn_location = get_node("SpawnPath/SpawnPosition")
	mob_spawn_location.progress_ratio = randf()
	mob.initialize(mob_spawn_location.position, $Player)
	add_child(mob)

func _on_amigo_timer_timeout() -> void:
	var amigo = amigo_scene.instantiate()
	var amigo_spawn_location = get_node("SpawnPath/SpawnPosition")
	amigo_spawn_location.progress_ratio = randf()
	amigo.initialize(amigo_spawn_location.position, $Player)
	add_child(amigo)


func _on_player_hit() -> void:
	health -= 1
	if(health <= 0):
		$AmigoTimer.stop()
		$MobTimer.stop()
		$Player.queue_free()
		$UserInterface/RetryScreen.show()
		
func _on_player_catch() -> void:
	score += 1
	if(score >= 10):
		$AmigoTimer.stop()
		$MobTimer.stop()
		$Player.queue_free()
		$UserInterface/NextLevelScreen.show()

		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("ui_accept") and $UserInterface/RetryScreen.visible:
		get_tree().reload_current_scene()
	if event.is_action("ui_accept") and $UserInterface/NextLevelScreen.visible:
		get_tree().change_scene_to_file("res://level_2.tscn")


func _on_player_moved() -> void:
	var camera_pivot = $CameraPivot.position
	var player_position = $Player.position
	camera_pivot = Vector3(player_position.x, player_position.y, player_position.z)
	$CameraPivot.position = camera_pivot
