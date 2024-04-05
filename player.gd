extends Area2D
signal hit #player object sends out hit signal when colliding with other objects

#export lets value be set in the inspector e.g. public on c# unity
@export var speed = 400 #how fast player will move
var screen_size #Size of the game window

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
#Called when restarting the game	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(_body):
	hide() #hides player model upon collision
	hit.emit() #emits hit signal
	#turn off players hitbox to prevent continious hits deferred causes enginge to wait till its safe to disable
	$CollisionShape2D.set_deferred("disabled", true)
