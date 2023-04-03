extends Node


@export var mob_scene: PackedScene
@export var player_scene: PackedScene


@onready var player = $Player


func _ready():
	$UserInterface/Retry.hide()
	

func _unhandled_input(event):
	if event.is_action_pressed('ui_accept') and $UserInterface/Retry.visible:
		# Restart the current scene
		get_tree().reload_current_scene()


func _on_timer_timeout():
	
	if !is_instance_valid(player):
		return
	
	# Create a new instance of the Mob scene.
	var mob: Node = mob_scene.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	#var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	var mob_spawn_location = $SpawnPath/SpawnLocation
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()

	var player_position = player.position
	mob.initialize(mob_spawn_location.position, player_position)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
	# We connect the mob to the score label to update the score upon squashing one.
	mob.squashed.connect($UserInterface/ScoreLabel._on_Mob_squashed.bind())


func _on_player_hit():
	# We stop the mob timer and wait for the player to respawn
	$MobTimer.stop()
	
	var retry_rect = $UserInterface/Retry
	var retry_label = $UserInterface/Retry/RetryLabel
	
	var tween = get_tree().create_tween()
	tween.tween_callback(retry_rect.show)
	tween.tween_property(retry_rect, "color", Color(0,0,0,0), 0)
	tween.tween_property(retry_rect, "color", Color(0,0,0,0.4), 0.5)
	tween.tween_callback(retry_label.show)
	
#	# Create single user timer and wait 2 seconds
#	await get_tree().create_timer(2.0).timeout
#
#	# Instantiate player from player scene and add it to the scene tree
#	player = player_scene.instantiate()
#	player.position = Vector3.ZERO
#	add_child(player)
#
#	# Connect hit signal to Main script
#	player.hit.connect(_on_player_hit.bind())
#
#	# Reset score
#	var score_label = $UserInterface/ScoreLabel
#	score_label.score = 0
#	score_label.text = "Score: 0"
#
#	# Restart mob timer
#	$MobTimer.start()

	
