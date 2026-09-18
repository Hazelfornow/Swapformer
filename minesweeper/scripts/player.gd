extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@onready var flipped_2d: AnimatedSprite2D = $Flipped2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var red: TileMapLayer = $"../MainBlocks/red"
@onready var blue: TileMapLayer = $"../MainBlocks/blue"
var switched = false




func _ready() -> void:
	red.modulate.a = .5
	red.set_deferred("collision_enabled", false)
	blue.modulate.a = 1
	blue.set_deferred("collision_enabled", true)
	flipped_2d.modulate.a = 0


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Switch"):
		if switched:
			red.modulate.a = .5
			red.set_deferred("collision_enabled", false)
			blue.modulate.a = 1
			blue.set_deferred("collision_enabled", true)
			flipped_2d.modulate.a = 0
			animated_sprite_2d.modulate.a = 1
			switched = false
		else:
			red.modulate.a = 1
			red.set_deferred("collision_enabled", true)
			blue.modulate.a = .5
			blue.set_deferred("collision_enabled", false)
			flipped_2d.modulate.a = 1
			animated_sprite_2d.modulate.a = 0
			switched = true
			

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if is_on_floor() == false:
		animated_sprite_2d.play("jump")
		flipped_2d.play("jump")
		if velocity.y > 0:
			animated_sprite_2d.play("fall")
			flipped_2d.play("fall")
	else:
		if direction:
			animated_sprite_2d.play("move")
			flipped_2d.play("move")
		else:
			animated_sprite_2d.play("idle")
			flipped_2d.play("idle")
	
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
