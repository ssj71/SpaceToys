extends Spatial

const mode = "shoot"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var s1
var s2
var shiptype = "classic" #rc or classic


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
	else:
		s1 = load("res://shipRC.tscn")
		add_child(s1)
		s2 = s1
	reset()
	pass # Replace with function body.

func reset():
	s2.kill()
	s1.birth()
	$scorekeeper.reset()
	$"../MineFactory".clearall()
	$"../MineFactory".ship = s1
	$"../reset_button".visible = false
	

	
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
		$"../reset_button".visible = true
		if not once:
			once = true
			#reset()
