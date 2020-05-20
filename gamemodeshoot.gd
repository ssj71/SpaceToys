extends Spatial

const mode = "shoot"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var s1 = $"ship2"
onready var s2 = $"ship1"


# Called when the node enters the scene tree for the first time.
func _ready():
	s1.birth()
	pass # Replace with function body.

func reset():
	s1.birth()
	s2.kill()
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
