class_name Attachment
extends Component

# Attachment type
export (Global.AttachmentType) var attachment_type = Global.AttachmentType.STOCK

# Attachment damage multiplier
export (float, -1.0, 1.0) var damage_multiplier = 0.0

# Attachment accuracy multiplier
export (float, -1.0, 1.0) var accuracy_multiplier = 0.0

