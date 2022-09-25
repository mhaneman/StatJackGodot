extends Node
var rng = RandomNumberGenerator.new()

var suits = ["hearts", "diamonds", "clubs", "spades"]
var numbers = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "jack", "queen", "king", "ace"]

var shoe = []
func _ready():
	rng.randomize()
	new_shoe(1)

	
func new_shoe(shoe_size):
	shoe.empty()
	for i in shoe_size:
		for j in numbers:
			for k in suits:
				shoe.append([j, k])

func get_rand_card():
	var rand_shoe_pos = rng.randi_range(0, shoe.size() - 1)
	return shoe.pop_at(rand_shoe_pos)
