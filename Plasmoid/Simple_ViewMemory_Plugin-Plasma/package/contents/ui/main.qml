/*
 *  SPDX-FileCopyrightText: 2023 jpenrici <jpenrici@gmail.com>
 *  SPDX-License-Identifier: LGPL-2.1-or-later
 */

import QtQuick 2.1
import QtQuick.Layouts 1.1

import org.kde.plasma.components 3.0 as PC3
import org.kde.plasma.core 2.1 as PlasmaCore
import org.kde.plasma.plasmoid 2.0


Item {
    id: main

    property bool wasExpanded : false
    property string textMemory     : "Memory Used [Total Memory GB]"
    property string textMemoryUsed : "Memory Used  GB"
    property string textMemoryTotal: "Total Memory GB"

    Plasmoid.switchWidth : PlasmaCore.Units.gridUnit * 8
    Plasmoid.switchHeight: PlasmaCore.Units.gridUnit * 8

    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground | PlasmaCore.Types.ConfigurableBackground

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    Plasmoid.toolTipMainText: "Simple Memory Viewer"
    Plasmoid.toolTipSubText : "Example"

    Plasmoid.compactRepresentation: MouseArea {

        Layout.minimumWidth   : PlasmaCore.units.iconSizes.medium
        Layout.minimumHeight  : PlasmaCore.units.iconSizes.medium
        Layout.preferredHeight: Layout.minimumHeight
        Layout.maximumHeight  : Layout.minimumHeight

        PC3.Label {
            text: main.textMemory
        }

        onClicked: {
            if (mouse.button == Qt.LeftButton) {
                wasExpanded = !wasExpanded
                Plasmoid.expanded = wasExpanded
            }
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
        interval: 60000  // milliseconds
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
            main.textMemory      = i18n("[%1GB]", memArray[0])
            main.textMemoryUsed  = i18n("Memory Used : %1 GB", memArray[0])
            main.textMemoryTotal = i18n("Memory Total: %1 GB", memArray[1])
        }
    }

    function alert() {
        // TO DO
    }
}
