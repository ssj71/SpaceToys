extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score = -700 #because of our hacks of exploding mines at startup, we have to preload the score
var minescleared = 0
var tutstep = 0
var hidelabel = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	
func tut(step):
	if(step > tutstep):
		tutstep = step
		if tutstep == 1:
			$InfoLabel.set_label_text("Pull the Trigger to Shoot!")
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
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hidelabel:
		hidelabel -= delta
		if hidelabel <= 0:
			hidelabel = 0
			$InfoLabel.visible = false
	


func _on_reset_button_button_pressed():
	$gamemode.reset()
