extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tutstep = 0
var hidelabel = 0
var shiptype = "classic"
var fade = 0.0
var fadeval = 1.0
const fadespeed = 1.0 #seconds
var loading = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	
func tut(step):
	if(step > tutstep):
		tutstep = step
		if tutstep == 1:
			if shiptype == "classic":
				$InfoLabel.set_label_text("Pull the Trigger to Shoot!")
			else:
				$InfoLabel.set_label_text("Point Right controller and pull trigger to SHOOT!")
			$title.visible = false
		elif tutstep == 2:
			$InfoLabel.set_label_text("Shoot the Mines!")
		elif tutstep == 3:
			$title.visible = false
			$InfoLabel.visible = false

func bonus(plus,text):
	show_prompt(text+" +%d" % (plus),3)
	$scorekeeper.add_score(plus)

func show_prompt(text, time):
	$InfoLabel.set_label_text(text)
	$InfoLabel.visible = true
	hidelabel = time

func show_buttons():
	$button0.visible = true
	$button1.visible = true
	$button1/ButtonArea.monitoring = true

func hide_buttons():
	$button0.visible = false
	$button1.visible = false
	$button1/ButtonArea.monitoring = false

var t = 0.0
var firsttime = true
func _process(delta):
	if hidelabel:
		hidelabel -= delta
		if hidelabel <= 0:
			hidelabel = 0
			$InfoLabel.visible = false
	t += delta
	if t> 2 && firsttime:
		#_on_button0_button_pressed() #uncomment to autopick classic
		firsttime = false
	if fade != 0.0:
		fadeval += fade
		var c = max(0.0,min(1.0, fadeval));
		vr.set_default_layer_color_scale(Color(c, c, c, c));
		if fadeval >= 1.0 or fadeval <= 0.0:
			fade = 0.0
			fadeval = max(0.0,min(1.0, fadeval))
			if loading:
				loading = false
				loadgame()

func fadein():
	fade = 1.0/fadespeed/70.0 #fps is 70ish

func fadeout():
	fade = -1.0/fadespeed/70.0

var firstchoice = true

func _on_button0_button_pressed():
	if firstchoice:
		shiptype = "classic"
		firstchoice = false
		loadprep()
	else:
		hide_buttons()
		$gamemode.reset()

func _on_button1_button_pressed():
	if firstchoice:
		shiptype = "rc"
		firstchoice = false
		loadprep()
	else:
		get_tree().reload_current_scene()

func loadgame():
	var b = $"MineFactory/activebullets".get_child(0)
	if b != null:
		$"MineFactory/activebullets".remove_child(b)
		$"MineFactory/pools/bullet".add_child(b)
	var mode = load("res://gamemodeshoot.tscn").instance()
	mode.shiptype = shiptype
	add_child(mode)
	
func loadprep():
	loading = true
	hide_buttons()
	$button0/label.set_label_text("reset")
	$button1/label.set_label_text("change mode")
	fadeout()
