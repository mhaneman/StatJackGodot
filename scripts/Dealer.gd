extends Hand
class_name Dealer

func play_turn():
	in_play_cards[1].face_up()
	while (count_high <= 16):
		self.hit()
		print(count_high)
	if (count_high > 21):
		return "bust"
	return count_high
