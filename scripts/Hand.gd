extends Node2D
class_name Hand

onready var shoe = get_node("/root/Shoe")

var card_scene = preload("res://scenes/Card.tscn")
onready var card_spot_1 = $Card1
onready var card_spot_2 = $Card2
onready var init_card_pos = card_spot_1.transform.origin
onready var init_card_spacing = abs(init_card_pos.x - card_spot_2.transform.origin.x)

var in_play_cards = []
# must count differntly based on the ace
var count_high = 0
var count_low = 0

	
func instance_card(isUp):
	var new_card = card_scene.instance()
	var new_card_value = shoe.get_rand_card()
	
	add_child(new_card)
	new_card.set_card(new_card_value[0], new_card_value[1], isUp)
	new_card.scale *= 0.2
	
	add_to_count(new_card_value[0])
	in_play_cards.append(new_card)
	
func reset():
	count_low = 0
	count_high = 0
	for i in in_play_cards:
		i.queue_free()
	in_play_cards.clear()

# eventually -> 
# yield( get_node("AnimationPlayer"), "finished" )
func hit(isUp=true):
	instance_card(isUp)
	card_pos()
	yield(get_tree().create_timer(1), "timeout")
	
func stay():
	yield(get_tree().create_timer(0.3), "timeout")

	
func add_to_count(card):
	if (card == "king" || card == "queen" || card == "jack"):
		count_high += 10
		count_low += 10
	elif (card == "ace"):
		count_high += 11
		count_low += 1
	else:
		count_high += int(card)
		count_low += int(card)
		
		
func card_pos():
	var pos = init_card_pos
	
	var card_spacing = init_card_spacing
	if (in_play_cards.size() > 2):
		card_spacing *= pow(in_play_cards.size() - 1, -1)
		
	for i in in_play_cards:
		i.transform.origin = pos
		pos.x += card_spacing 
	
	
