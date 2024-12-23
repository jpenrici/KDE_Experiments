/*
 *  SPDX-FileCopyrightText: 2023 jpenrici <jpenrici@gmail.com>
 *  SPDX-License-Identifier: LGPL-2.1-or-later
 */

import QtQuick 2.1
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.1


Item {
    id: page
    width: childrenRect.width
    height: childrenRect.height

    property alias cfg_memoryLimitAlert: spinbox.value

    ColumnLayout {
        RowLayout {
            Label {
                text: i18n("Alert when reaching:")
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
