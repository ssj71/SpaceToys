extends CollisionShape


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const length = 1.5
const angle = 2.5*PI/180.0


# Called when the node enters the scene tree for the first time.
func _ready():
	var side = length*tan(angle/2.0) 
	for i in range(6):
		shape.points[i] *= side
		shape.points[i][2] = length

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
