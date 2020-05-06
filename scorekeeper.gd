extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score = -700 #because of our hacks of exploding mines at startup, we have to preload the score
var minescleared = 0
const scorefile = "user://highscores"
const topkept = 15
var scoredata

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func add_score(plus):
	score += plus
	$score.set_label_text("%06d" % (score))
	
func mine_cleared():
	minescleared += 1
	
func show_scores():
	scoredata = load_file_data(scorefile)
	if scoredata:
		if len(scoredata) < topkept or scoredata[topkept][1] < score:
			newhigh()
	else:
		scoredata = []
		newhigh()
	$hinames.visible = true
	$hiscores.visible = true
	$hiextra.visible = true
	$extra.visible = true
	$extra.set_label_text("lvl %d, %d mines" % [$"../MineFactory".level, minescleared])
	print_scores()
	
func newhigh():
	$OQ_UI2DKeyboard.visible = true
	$"../OQ_ARVROrigin/OQ_RightController/Feature_UIRayCast".visible = true
	$OQ_UI2DKeyboard.set_prompt("ace")
	$"..".show_prompt("Enter name for new high score!",10)
	#print($OQ_UI2DKeyboard/OQ_UI2DCanvas_TextInput/TextEdit)
	#for child in $OQ_UI2DKeyboard/OQ_UI2DCanvas_TextInput.get_children():
	#	print(child.name)

func hide_scores():
	$hinames.visible = false
	$hiscores.visible = false
	$hiextra.visible = false
	$extra.visible = false
	
func print_scores():
	var nms = "Hi-Scores:\n"
	var scr = "\n"
	var xtr = "\n\n"
	for s in scoredata:
		nms += "%s\n"%s[0]
		scr += "%6d\n"%s[1]
		xtr += "(%2d, %3d)\n\n"%[s[2],s[3]]
	$hinames.set_label_text(nms)
	$hiscores.set_label_text(scr)
	$hiextra.set_label_text(xtr)
	
func _on_OQ_UI2DKeyboard_text_input_enter(text):
	$OQ_UI2DKeyboard.visible = false
	$"../InfoLabel".visible = false
	$"../OQ_ARVROrigin/OQ_RightController/Feature_UIRayCast".visible = false
	var data = [text,score,$"../MineFactory".level,minescleared]
	var inserted = false
	for i in range(len(scoredata)):
		if scoredata[i][1] < score:
			scoredata.insert(i,data)
			inserted = true
	if len(scoredata) >= topkept:
		scoredata.remove(topkept)
	if not inserted:
		scoredata.append(data)
	#scoredata = [] #WARNING uncommenting this line deletes all scores!
	save_file_data(scorefile,scoredata)
	print("data",scoredata)
	print_scores()
		
func save_file_data(path, data):
	var f = File.new()
	f.open(path, File.WRITE)
	f.store_var(data)
	f.close()
	
func load_file_data(path):
	var f = File.new()
	if f.file_exists(path):
		f.open(path, File.READ)
		var data = f.get_var()
		f.close()
		return data
	return null

