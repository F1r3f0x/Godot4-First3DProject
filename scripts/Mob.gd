extends CharacterBody3D


# Minimum speed of the mob in meters per second.
@export var min_speed = 10
# Maximum speed of the mob in meters per second.
@export var max_speed = 18


var was_squashed = false


# Emitted when the player jumped on the mob.
signal squashed


func initialize(start_position: Vector3, player_position: Vector3):
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Rotate this mob randomly within range of -45 and +45 degrees,
	# so that it doesn't move directly towards the player.
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	# We calculate a random speed (integer)
	var random_speed = randi_range(min_speed, max_speed)
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * random_speed
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)


func _on_visibility_notifier_screen_exited():
	# Remove node
	queue_free()
	


func squash():
	if was_squashed:
		return
		
	was_squashed = true
	squashed.emit()
	queue_free()


func _physics_process(_delta):
	move_and_slide()
	
