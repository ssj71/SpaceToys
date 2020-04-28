extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dir = Vector3(0,0,0)
const speed = .08

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fire():
	var s = $"../ship2"
	if not s:
		s = $"../OQ_ARVROrigin/OQ_LeftController/Feature_poopRigidBodyGrab/ship2"
	if not s:
		s = $"../OQ_ARVROrigin/OQ_RightController/Feature_RigidBodyGrab/ship2"
	if s:
		dir = (s.global_transform.origin - global_transform.origin).normalized()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var c = move_and_collide(speed*delta*dir)
	if c:
		if c.collider.get_name() == "walls":
			queue_free()
		elif c.collider.get_name() == "ship2":
			c.collider.boom()
#	pass

func hit_ship():
	pass



