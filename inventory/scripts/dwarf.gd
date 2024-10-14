extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D

var is_dragging = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:

	if is_dragging:
		global_position = get_global_mouse_position()
			
	if(Global.playing):
		
	# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

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
		#move_and_collide(velocity * delta)
		move_and_slide()
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_action_pressed("mb_left"):
		if event.pressed:
			is_dragging = false
	
