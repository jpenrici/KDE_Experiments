/*
 *  SPDX-FileCopyrightText: 2023 jpenrici <jpenrici@gmail.com>
 *  SPDX-License-Identifier: LGPL-2.1-or-later
 */

import QtQuick 2.4

import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: "configure"
        source: "configGeneral.qml"
    }
}
