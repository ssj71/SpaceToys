extends Spatial

const mode = "shoot"
var s1
var s2
var shiptype = "rc" #"classic" #rc or classic
var reserve

# Called when the node enters the scene tree for the first time.
func _ready():
	if shiptype == "classic":
		var ship = load("ship2.tscn")
		s1 = ship.instance()
		s2 = ship.instance()
		s2.set_name("ship1")
		add_child(s1)
		add_child(s2)
		var las = s2.get_node("Crosshair/laser")
		var mat = las.material.duplicate()
		las.set_material(mat)
		s2.kill()
		reserve = s2
		$"../InfoLabel".set_label_text("Grab the Ship!")
	else:
		s1 = load("res://shipRC.tscn").instance()
		add_child(s1)
		s2 = s1
		$"../InfoLabel".set_label_text("Point Left controller and pull trigger to MOVE")
	reset()

var firsttime = true
func _process(delta):
	if firsttime:
		$"..".fadein()
		firsttime = false

func reset():
	s2.kill()
	s1.birth()
	reserve = s2
	$"../MineFactory".clearall()
	$"../MineFactory".ship = s1
	$scorekeeper.reset()
	$PowerUp.hide()

const buffer = .1
onready var top = $walls.height
onready var rad = $walls.radius
onready var rng = $"../MineFactory".rng
var poffset = 0.0
func place(item, avoid):
	var pos = avoid
	while (pos - avoid).length() < buffer:
		var z = rng.randf_range(buffer,top-buffer)
		var ang = rng.randf_range(0,2*PI)
		var dist = rng.randf_range(0,rad-buffer)
		pos = Vector3(dist*cos(ang), z, dist*sin(ang))
	item.global_transform.origin = pos
	#item.translation = Vector3(0,1,poffset) #this is for debugling
	#poffset += .1

func newlevel(level):
	$newlevel.play()
	if level % 3 == 2:
		var n = rng.randi_range(1,100)
		if n <= 35:
			$PowerUp.setPUtype("upgrade")
			place($PowerUp,$"../MineFactory".ship.global_transform.origin)
		elif n <= 45 and shiptype == "classic" and reserve != null:
			reserve.birth()
			place(reserve,$"../MineFactory".ship.global_transform.origin)
			reserve = null
		else:
			$PowerUp.setPUtype("points")
			place($PowerUp,$"../MineFactory".ship.global_transform.origin)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var once = false
func ship_down():
	if s1.lenable or s1.renable:
		$"../MineFactory".ship = s1
		reserve = s2
	elif s2.lenable or s2.renable:
		$"../MineFactory".ship = s2
		reserve = s1
	else:
		#game over bruh
		s1.visible = false
		s2.visible = false
		$scorekeeper.show_scores()
		$"../MineFactory".ship = null
		$"..".show_buttons()
		if not once:
			once = true
			#reset()
