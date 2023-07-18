class_name CircularFillBar
extends TextureProgressBar

func update_progress(progress:float, max_progress:float) -> void:
    radial_fill_degrees = progress / max_progress * 360.0
