extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D


@onready var level = get_node("/root/main/level")
@onready var playerArea : TileMapLayer = level.get_node("/root/main/level/Player Area")
@onready var camera = get_node("/root/main/cam_container/Camera2D")

var is_dragging = false

const SPEED = 150
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:

	if is_dragging:
		global_position = get_global_mouse_position()
	
			
	if(Global.playing):
		
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
			
			#### reset player set if player reaches fall speed of 1000 or more
			if velocity.y >= 1000:
				Global.playerArea.remove_child(Global.playerArea.get_node("dwarf"))
				Global.player_count -= 1

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
				sprite.flip_h = false
			elif direction < 0:
				sprite.flip_h = true
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			

			

		#var collided_tile = 
		move_and_slide()
		
		#if collided_tile != Vector2.ZERO:
			#var tile_id = get_parent().get_cell_v(collided_tile).get_tile()
			#if tile_id == 3:
				#print("COIN HIT")
			
		
func _input(event: InputEvent) -> void:
	if Global.playing and event is InputEventMouseButton and Input.is_action_pressed("mb_left"):
		if event.pressed:
			is_dragging = false
			camera.enabled = false
			
	
