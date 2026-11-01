import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

TextField {
    placeholderTextColor: config.color
    palette.text: config.color
    font.pointSize: config.fontSize
    font.family: config.font || "Noto Sans"
    background: Rectangle {
        radius: 100
        color: "#be5fca"
        border.color: "white"
        border.width: 2
    }
}
