/*
    SPDX-FileCopyrightText: 2016 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

import org.kde.breeze.components
import "timer.js" as AutoTriggerTimer

ActionButton {
    // Use the Window color set so labels stay dark on the white logout background.
    Kirigami.Theme.inherit: false
    Kirigami.Theme.colorSet: Kirigami.Theme.Window

    Layout.alignment: Qt.AlignTop

    icon.width: Kirigami.Units.iconSizes.huge
    icon.height: Kirigami.Units.iconSizes.huge

    font.underline: false // See https://phabricator.kde.org/D9452
    opacity: activeFocus || hovered ? 1 : 0.75

    Keys.onPressed: (event) => {
        AutoTriggerTimer.cancelAutoTrigger();
        event.accepted = false;
    }
}
