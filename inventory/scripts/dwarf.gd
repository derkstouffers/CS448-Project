extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D


@onready var level = get_node("/root/main/level")
@onready var playerArea : TileMapLayer = level.get_node("/root/main/level/Player Area")
@onready var camera = get_node("/root/main/cam_container/Camera2D")
@onready var fireball = preload("res://scenes/fire_attack.tscn")
var is_dragging = false
var on_ladder = false
const SPEED = 150
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:

				
	if Global.playing:	
		camera.enabled = false
		# Add the gravity.
		if not is_on_floor() and !on_ladder:
			velocity += get_gravity() * delta
			
			#### reset player set if player reaches fall speed of 2500 or more
			if velocity.y >= 2500:
				Global.playerArea.get_node("dwarf").position = Global.playerArea.map_to_local((Vector2i(Global.playerArea.get_used_cells_by_id(4)[0].x, Global.playerArea.get_used_cells_by_id(4)[0].y - 5)))
		
		if on_ladder:
			if Input.is_action_pressed("jump"):
				velocity.y = -SPEED*delta*10
			if Input.is_action_pressed("down"):
				velocity.y = SPEED*delta*10
			else:
				velocity.y = 0
			
	# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			$AnimatedSprite2D.play("jump")
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
		var direction := Input.get_axis("left", "right")
		if direction:
			$AnimatedSprite2D.play("walk")
			velocity.x = direction * SPEED
			if direction > 0:
				Global.attack_direction = 1
				sprite.flip_h = false
			elif direction < 0:
				Global.attack_direction = -1
				sprite.flip_h = true
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
			
		
		
		if Input.is_action_pressed("attack"):
			var fire_attack = fireball.instantiate()
			
			
			if Global.attack_direction == 1:
				
				fire_attack.direction = 1
				Global.playerArea.add_child(fire_attack)
				fire_attack.position.x = Global.playerArea.get_node("dwarf").position.x  + 15
				fire_attack.position.y = Global.playerArea.get_node("dwarf").position.y
			if Global.attack_direction == -1:
				fire_attack.direction = -1
				Global.playerArea.add_child(fire_attack)
				fire_attack.position.x = Global.playerArea.get_node("dwarf").position.x  - 15
				fire_attack.position.y = Global.playerArea.get_node("dwarf").position.y
			
		move_and_slide()	
		

		
## BUG with ladder I think it registers exitting and entering at the same time and therefore player gets stuck between ladders
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group('slime'):
		print("collided")
	#if area.is_in_group('ladder'):
		#on_ladder = true
		#print("climbing")


#func _on_area_2d_area_exited(area: Area2D) -> void:
	#if area.is_in_group('ladder'):
		#await get_tree().create_timer(0.1).timeout
		 #
		#print("exiting")
		#on_ladder = false
