/*
 *  SPDX-FileCopyrightText: 2023 jpenrici <jpenrici@gmail.com>
 *  SPDX-License-Identifier: LGPL-2.1-or-later
 */

import QtQuick 2.4
import QtQuick.Layouts 1.1

import org.kde.plasma.components 3.0 as PC3
import org.kde.plasma.core 2.1 as PlasmaCore
import org.kde.plasma.plasmoid 2.0


Item {
    id: main

    property string textMemory     : "Memory Used [Total Memory GB]"
    property string textMemoryUsed : "?GB"
    property string textMemoryTotal: "?GB"
    property bool   alert: false

    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground | PlasmaCore.Types.ConfigurableBackground

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    Plasmoid.toolTipMainText: "Simple Memory Viewer"
    Plasmoid.toolTipSubText : "Example"

    Plasmoid.compactRepresentation: Rectangle {
        color: main.alert ? "#950000" : "#00674C"

        PC3.Label {
            id: label
            Layout.minimumWidth : textMetrics.width
            Layout.minimumHeight: textMetrics.height

            text: textMetrics.text

            font.pixelSize: plasmoid.configuration.fontSize * units.devicePixelRatio
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
            onClicked: plasmoid.expanded = !plasmoid.expanded
        }
    }

    Plasmoid.fullRepresentation: Item {

        Layout.minimumHeight  : PlasmaCore.Units.gridUnit *  8
        Layout.minimumWidth   : PlasmaCore.Units.gridUnit *  8
        Layout.preferredHeight: PlasmaCore.Units.gridUnit * 21
        Layout.preferredWidth : PlasmaCore.Units.gridUnit * 24
        Plasmoid.switchHeight : Layout.minimumHeight
        Plasmoid.switchWidth  : Layout.minimumWidth

        ColumnLayout {
            RowLayout {
                PC3.Label {
                    text: main.textMemoryUsed
                }
            }
            RowLayout {
                PC3.Label {
                    text: main.textMemoryTotal
                }
            }
        }
    }

    PlasmaCore.DataSource {
        id: timeSource
        engine: "time"   // plasmaengineexplorer
        connectedSources: ["Local"]
        interval: 30000  // milliseconds
        onNewData: { process() }
    }

    PlasmaCore.DataSource {
        id: executeSource
        engine: "executable"
        connectedSources: []
        onNewData: {
            console.log("Source name = ", sourceName)
            close(sourceName, executeSource.data[sourceName])
        }
    }

    function process() {
        var local  = "$HOME/.local/share/plasma/plasmoids/"
        var plugin = "com.plasmaplugin.jpenrici.simpleMemoryViewer"
        var script = "getMemory.sh"
        var cmd    = "/usr/bin/bash " + local + plugin + "/contents/code/" + script
        executeSource.connectSource(cmd)
    }

    function close(cmd, data) {
        if (data["stderr"] === "") {
            format(data["stdout"])
            console.log("Output      = ", data["stdout"] === "" ? "Empty" : data["stdout"])
        } else {
            console.log("Exit code   = ", data["exit code"])
            console.log("Exit status = ", data["exit status"])
            console.log("Error       = ", data["stderr"])
        }
        executeSource.disconnectSource(cmd)
    }

    function format(value) {
        const memArray = value.split(";")
        if (memArray.length > 1) {
            main.textMemory      = i18n("%1GB", memArray[0])
            main.textMemoryUsed  = i18n("Memory Used : %1 GB", memArray[0])
            main.textMemoryTotal = i18n("Memory Total: %1 GB", memArray[1])
            alert = (parseInt(memArray[0]) > plasmoid.configuration.memoryLimitAlert)
        }
    }
}
