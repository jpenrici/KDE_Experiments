/*
 *  SPDX-FileCopyrightText: 2024 jpenrici <jpenrici@gmail.com>
 *  SPDX-License-Identifier: LGPL-2.1-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Item {
    id: page

    width : childrenRect.width
    height: childrenRect.height

    property alias cfg_memoryLimitAlert: spinbox.value

    ColumnLayout {
        RowLayout {
            Label {
                text: i18n("Alert when reaching: ")
            }
            SpinBox {
                id: spinbox
                from : 0
                to   : 1024
                value: 4
                editable: false
            }
        }
    }
}
