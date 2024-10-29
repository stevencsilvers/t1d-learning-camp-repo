extends CanvasModulate


@export_color_no_alpha var sunrise : Color
@export_color_no_alpha var day : Color
@export_color_no_alpha var sunset : Color
@export_color_no_alpha var dusk : Color
@export_color_no_alpha var night : Color



func set_time(time : String):
	match(time):
		"sunrise":
			set_color(sunrise)
		"sunset":
			set_color(sunset)
		"dusk":
			set_color(dusk)
		"night":
			set_color(night)
		_:
			set_color(day)
