/*
 *  SPDX-FileCopyrightText: 2024 jpenrici <jpenrici@gmail.com>
 *  SPDX-License-Identifier: LGPL-2.1-or-later
 */

import QtQuick

import org.kde.plasma.configuration


ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: "configure"
        source: "configGeneral.qml"
    }
}
