extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var start = true
var level = 0
onready var top = $"../walls".height/2.0-.1
onready var rad = $"../walls".radius-.1
var rng
var prox = preload("res://proximitymine.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	var a = prox.instance()
	add_child(a)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start and get_children().size() == 0:
		level += 1
		produce(level)
#	pass


func produce(n):
	for i in range(n):
		var z = rng.randf_range(.1,top)
		var ang = rng.randf_range(0,2*PI)
		var dist = rng.randf_range(0,rad)
		var m = prox.instance()
		m.translation = Vector3(dist*cos(ang), z, dist*sin(ang))
		#print(m.translation)
		add_child(m)
