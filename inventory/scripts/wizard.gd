"""
	Wizard character
	
	If the user is in play mode, gives the character the ability to interact with objects, attacks, and have mobility.

"""

extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D


@onready var level = get_node("/root/main/level")
@onready var playerArea : TileMapLayer = level.get_node("/root/main/level/Player Area")
@onready var camera = get_node("/root/main/cam_container/Camera2D")
@onready var fireball = preload("res://scenes/fire_attack.tscn")
var is_dragging = false

const SPEED = 150
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:

				
	if Global.playing:	
		camera.enabled = false
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
			
			#### reset player set if player reaches fall speed of 2500 or more
			if velocity.y >= 2500:
				Global.playerArea.get_node("wizard").position = Global.playerArea.map_to_local((Vector2i(Global.playerArea.get_used_cells_by_id(4)[0].x, Global.playerArea.get_used_cells_by_id(4)[0].y - 5)))

	# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			$AnimatedSprite2D.play("wizard_jump")
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	
		var direction := Input.get_axis("left", "right")
		if direction:
			$AnimatedSprite2D.play("wizard_walk")
			velocity.x = direction * SPEED
			if direction > 0:
				Global.attack_direction = 1
				sprite.flip_h = false
			elif direction < 0:
				Global.attack_direction = -1
				sprite.flip_h = true
		else:
			$AnimatedSprite2D.play("wizard_idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
			
		
		# attack button pressed (space bar) creates an instance of the attack object, gives it directionality and position based on character.
		if Input.is_action_just_pressed("attack"):
			var fire_attack = fireball.instantiate()
			
			
			if Global.attack_direction == 1:
				
				fire_attack.direction = 1
				Global.playerArea.add_child(fire_attack)
				fire_attack.position.x = Global.playerArea.get_node("wizard").position.x  + 15
				fire_attack.position.y = Global.playerArea.get_node("wizard").position.y
			if Global.attack_direction == -1:
				fire_attack.direction = -1
				Global.playerArea.add_child(fire_attack)
				fire_attack.position.x = Global.playerArea.get_node("wizard").position.x  - 15
				fire_attack.position.y = Global.playerArea.get_node("wizard").position.y
		
		# lets player movement happen	
		move_and_slide()	
		

		
# checks interaction between wizard and slime (not doing anything right now)
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group('slime'):
		print("collided")
