extends Spatial

const mode = "shoot"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var s1
var s2
var shiptype = "rc" #"classic" #rc or classic


# Called when the node enters the scene tree for the first time.
func _ready():
	if shiptype == "classic":
		var ship = load("ship2.tscn")
		s1 = ship.instance()
		s2 = ship.instance()
		s2.set_name("ship1")
		add_child(s1)
		add_child(s2)
		s2.kill()
		$"../InfoLabel".set_label_text("Grab the Ship!")
	else:
		s1 = load("res://shipRC.tscn").instance()
		add_child(s1)
		s2 = s1
		$"../InfoLabel".set_label_text("Point Left controller and pull trigger to MOVE\nPoint Right controller and pull trigger to SHOOT")
	reset()

var firsttime = true
func _process(delta):
	if firsttime:
		$"..".fadein()
		firsttime = false

func reset():
	s2.kill()
	s1.birth()
	$"../MineFactory".clearall()
	$"../MineFactory".ship = s1
	$scorekeeper.reset()

const buffer = .1
onready var top = $walls.height
onready var rad = $walls.radius
onready var rng = $"../MineFactory".rng
var poffset = 0.0
func place(item, avoid):
	item.translation = avoid
	while (item.translation - avoid).length() < buffer:
		var z = rng.randf_range(buffer,top-buffer)
		var ang = rng.randf_range(0,2*PI)
		var dist = rng.randf_range(0,rad-buffer)
		item.translation = Vector3(dist*cos(ang), z, dist*sin(ang))
	#item.translation = Vector3(0,1,poffset) #this is for debugling
	#poffset += .1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var once = false
func ship_down():
	if s1.lenable or s1.renable:
		$"../MineFactory".ship = s1
	elif s2.lenable or s2.renable:
		$"../MineFactory".ship = s2
	else:
		s1.visible = false
		s2.visible = false
		$scorekeeper.show_scores()
		$"../MineFactory".ship = null
		$"..".show_buttons()
		if not once:
			once = true
			#reset()
