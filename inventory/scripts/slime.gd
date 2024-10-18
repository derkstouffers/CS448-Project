extends CharacterBody2D


@onready var path_follow : PathFollow2D = $".."
@export var speed = 25

var is_dragging = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if is_dragging:
		global_position = get_global_mouse_position()
	
	#if Global.playing:
		
	# gravity
	if not is_on_floor():
			
		velocity += get_gravity() * delta
			
			
	# Activates the made path for the slimes		
	path_follow.progress += speed * delta
	
	
	$AnimatedSprite2D.play("bounce")
	
	## based on this implementation we need this to have the gravity work
	move_and_slide()



# Used for placing in world
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_action_pressed("mb_left"):
		if event.pressed:
			is_dragging = false
			
		
