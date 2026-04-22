pragma ComponentBehavior: Bound
import Qt5Compat.GraphicalEffects
import QtQuick

Icon {
    id: root
    property string iconColor

    layer.effect: ColorOverlay {
        color: root.iconColor
    }
}
