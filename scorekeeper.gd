extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score = 0 
var minescleared = 0
var scorefile = "user://highscores"
const topkept = 15
var scoredata
var killname = "ace"

# Called when the node enters the scene tree for the first time.
func _ready():
	if $"..".shiptype == "rc":
		scorefile = "user://rchighscores"
	hide_scores()

func reset():
	score = 0
	minescleared = 0
	hide_scores()

func add_score(plus):
	score += plus
	$score.set_label_text("%06d" % (score))
	
func mine_cleared():
	minescleared += 1
	
func show_scores():
	scoredata = load_file_data(scorefile)
	if scoredata:
		if len(scoredata) < topkept or scoredata[-1][1] < score:
			newhigh()
	else:
		scoredata = []
		newhigh()
	$hinames.visible = true
	$hiscores.visible = true
	$hiextra.visible = true
	$extra.visible = true
	$extra.set_label_text("lvl %d, %d mines" % [$"../../MineFactory".level, minescleared])
	print_scores()
	
func newhigh():
	$OQ_UI2DKeyboard.set_prompt(killname)
	$OQ_UI2DKeyboard.visible = true
	$"../../OQ_ARVROrigin/OQ_RightController/Feature_UIRayCast".visible = true
	$"../..".show_prompt("Enter name for new high score!",10)

func hide_scores():
	$hinames.visible = false
	$hiscores.visible = false
	$hiextra.visible = false
	$extra.visible = false
	$OQ_UI2DKeyboard.visible = false
	$"../../OQ_ARVROrigin/OQ_RightController/Feature_UIRayCast".visible = false

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
	killname = text
	$OQ_UI2DKeyboard.visible = false
	$"../../InfoLabel".visible = false
	$"../../OQ_ARVROrigin/OQ_RightController/Feature_UIRayCast".visible = false
	var data = [killname,score,$"../../MineFactory".level,minescleared]
	var inserted = false
	for i in range(len(scoredata)):
		if scoredata[i][1] < score:
			scoredata.insert(i,data)
			inserted = true
			break
	if len(scoredata) >= topkept:
		scoredata.remove(topkept)
	if not inserted:
		scoredata.append(data)
	#scoredata = [] #WARNING uncommenting this line deletes all scores!
	save_file_data(scorefile,scoredata)
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

