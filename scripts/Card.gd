extends Sprite
class_name Card

var front = ""
var back = preload("res://textures/cards/back.png")

func set_card(number, suit, isUp):
	front = load("res://textures/cards/" + number + "_of_" + suit + ".png")
	if (isUp):
		self.texture = front
	else:
		self.texture = back
	
func face_up():
	self.texture = front
