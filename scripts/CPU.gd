extends Hand
class_name CPU

func play_turn():
	while (count_low <= 16):
		yield(self.hit(), "completed")
	yield(self.stay(), "completed")


