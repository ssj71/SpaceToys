extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var pos :Vector3


# Called when the node enters the scene tree for the first time.
func _ready():
	pos = translation
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func extend(l):
	$laserx.height = .04 + l
	$Collisionx.shape.height = .04 + l
	$laserz.height = .04 + l
	$Collisionz.shape.height = .04 + l

func scanforship():
	var c = move_and_collide(Vector3(0,0,0))
	if c:
		translation = pos
		if c.collider.get_name().match("ship*"):
			c.collider.boom()

func hit_ship():
	pass
