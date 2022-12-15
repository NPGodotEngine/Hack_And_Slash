class_name Attachment
extends Component

# Attachment type
##
# `STOCK` gun stock
# `TRIGGER` gun trigger
# `AMMO` gun ammo
# `BARREL` gun barrel
# `ALT` fun alternative fire
enum AttachmentType {
    STOCK = 1,
    TRIGGER = 2,
    AMMO = 4,
    BARREL = 8,
    ALT = 16
}

export (AttachmentType) var attachment_type
export (float, -1.0, 1.0) var damage_multiplier = 0.0
export (float, -1.0, 1.0) var accuracy_multiplier = 0.0

