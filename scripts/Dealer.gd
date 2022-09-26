extends Hand
class_name Dealer

func play_turn():
	in_play_cards[1].face_up()
	while (count_high <= 16):
		yield(self.hit(), "completed")
