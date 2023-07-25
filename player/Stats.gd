extends Node

signal score_changed

var _score = 0
var _highscore = 0

func add_score(value):
	_score += value;
	if(_score>_highscore):
		_highscore = _score
	score_changed.emit()

func reset_score():
	_score = 0
	
func get_score():
	return _score

func get_highscore():
	return _highscore
