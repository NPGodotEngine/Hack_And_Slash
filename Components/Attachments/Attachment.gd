class_name Attachment
extends Component

# Attachment type
var attachment_type: int = Global.AttachmentType.STOCK

# Attachment damage multiplier
export (float, -1.0, 1.0) var damage_multiplier = 0.0

# Attachment accuracy multiplier
export (float, -1.0, 1.0) var accuracy_multiplier = 0.0

# Call to cancel action that attachement's 
#is currently performing 
##
# Usually do noting but for ammo
# like beam this can tell beam ammo
# to stop the beam that is casting
func cancel_action() -> void:
	pass

