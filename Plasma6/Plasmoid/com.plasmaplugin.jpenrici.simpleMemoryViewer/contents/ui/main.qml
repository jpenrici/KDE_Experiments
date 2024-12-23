/*
 *  SPDX-FileCopyrightText: 2024 jpenrici <jpenrici@gmail.com>
 *  SPDX-License-Identifier: LGPL-2.1-or-later
 */

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PC
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors


PlasmoidItem {
    id: main

    property string textMemory     : "?GB" // "Memory Used [Total Memory GB]"
    property string textMemoryUsed : "?GB"
    property string textMemoryTotal: "?GB"
    property bool   alert: false

    readonly property int pause: 30000     // 30 seconds

    preferredRepresentation: compactRepresentation

    toolTipMainText: "Simple Memory Viewer"
    toolTipSubText : "Example"

    Sensors.Sensor {
        id: memoryUsedSensor
        sensorId: "memory/physical/used"
        updateRateLimit: main.pause
    }

    Sensors.Sensor {
        id: memoryTotalSensor
        sensorId: "memory/physical/total"
        updateRateLimit: main.pause
    }

    compactRepresentation: Rectangle {
        color: main.alert ? "#950000" : "#00674C"

        width : label.width  + (Kirigami.Units.smallSpacing * 2)
        height: label.height + (Kirigami.Units.smallSpacing * 2)
        radius: Kirigami.Units.smallSpacing

        PC.Label {
            id: label
            anchors.centerIn: parent

            width:  Math.max(textMetrics.width,  implicitWidth)
            height: Math.max(textMetrics.height, implicitHeight)

            text: textMetrics.text
            color: "white"

            font.pixelSize: Plasmoid.configuration.fontSize * Screen.devicePixelRatio
            horizontalAlignment: Text.AlignHCenter

            TextMetrics {
                id: textMetrics
                font.family   : label.font.family
                font.pixelSize: label.font.pixelSize
                text: main.textMemory
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                Plasmoid.expanded = !Plasmoid.expanded
                updateMemoryText()
            }
        }
    }

    fullRepresentation: Item {
        Layout.minimumHeight  : Kirigami.Units.gridUnit * 8
        Layout.minimumWidth   : Kirigami.Units.gridUnit * 8
        Layout.preferredHeight: Kirigami.Units.gridUnit * 21
        Layout.preferredWidth : Kirigami.Units.gridUnit * 24

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Kirigami.Units.smallSpacing
            spacing: Kirigami.Units.smallSpacing

            RowLayout {
                Layout.fillWidth: true
                PC.Label {
                    text: main.textMemoryUsed
                    Layout.alignment: Qt.AlignLeft
                }
            }

            RowLayout {
                Layout.fillWidth: true
                PC.Label {
                    text: main.textMemoryTotal
                    Layout.alignment: Qt.AlignLeft
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }

    Timer {
        id: updateTimer
        interval   : main.pause
        running    : true
        repeat     : true
        onTriggered: updateMemoryText()
    }

    Component.onCompleted: {
        updateMemoryText()
    }

    function updateMemoryText() {
        const memoryUsed  = memoryUsedSensor.value  / (1024 * 1024 * 1024)  // Convert to GB
        const memoryTotal = memoryTotalSensor.value / (1024 * 1024 * 1024)

        main.textMemory      = i18n("%1GB", Math.round(memoryUsed))
        main.textMemoryUsed  = i18n("Memory Used : %1 GB", memoryUsed.toPrecision(4))
        main.textMemoryTotal = i18n("Memory Total: %1 GB", memoryTotal.toPrecision(4))
        alert = (memoryUsed > Plasmoid.configuration.memoryLimitAlert)
    }
}
