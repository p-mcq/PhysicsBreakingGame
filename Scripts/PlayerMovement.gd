extends RigidBody3D

var targetVelocity = Vector3()

@export var speed: float = 1200

# Mouse Stuff
@export var mouseSensitivity: float = 0.001
@export var twistInput: float = 0
@export var pitchInput: float = 0

@onready var twist: Node3D = %Twist
@onready var pitch: Node3D = %Pitch


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	# Move the player
	var input = Vector3.ZERO
	input.x = Input.get_axis("Turn_Left", "Turn_Right")
	input.z = Input.get_axis("Forward", "Backward")
	input = input.normalized()
	apply_central_force(twist.basis * input * speed * delta)

func _process(_delta: float) -> void:
	twist.rotate_y(twistInput)
	pitch.rotate_x(pitchInput)
	pitch.rotation.x = clamp(
		pitch.rotation.x,
		deg_to_rad(-30),
		deg_to_rad(30)
	)
	pitchInput = 0
	twistInput = 0
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if _event is InputEventMouseMotion:
		var mouseEvent = _event as InputEventMouseMotion
		twistInput = -mouseEvent.relative.x * mouseSensitivity
		pitchInput = -mouseEvent.relative.y * mouseSensitivity
