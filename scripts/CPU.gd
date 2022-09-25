extends Hand
class_name CPU

func play_turn():
	while (count_low <= 16):
		self.hit()
	if (count_low > 21):
		return "bust"
	return
