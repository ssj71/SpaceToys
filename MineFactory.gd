extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var start = true
var level = 0
onready var top = $"../walls".height/2.0-.1
onready var rad = $"../walls".radius-.01
var rng
var prox = preload("res://proximitymine.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	var a = prox.instance()
	a.visible = false
	a.boom()
	#add_child(a)=
	$"../ship2/Particles".restart()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start and get_children().size() == 0:
		level += 1
		produce(level)
#	pass


func produce(n):
	for i in range(n):
		var z = rng.randf_range(.01,top)
		var ang = rng.randf_range(0,2*PI)
		var dist = rng.randf_range(0,rad)
		var m = prox.instance()
		m.translation = Vector3(dist*cos(ang), z, dist*sin(ang))
		#m.translation = Vector3(0,0,.1*i)
		#print(m.translation)
		add_child(m)
		print(m.name)
