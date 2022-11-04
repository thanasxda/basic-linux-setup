/*
 *  Copyright 2013 Marco Martin <mart@kde.org>
 *  Copyright 2014 Kai Uwe Broulik <kde@privat.broulik.de>
 *  Copyright 2022 Kyle Paulsen <kyle.a.paulsen@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
 */

import QtQuick 2.5
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.0
import org.kde.kquickcontrols 2.0 as KQuickControls
import org.kde.kirigami 2.5 as Kirigami

Kirigami.ScrollablePage {
    id: root
    property alias cfg_Color: colorButton.color
    property int cfg_FillMode
    property alias cfg_Blur: blurRadioButton.checked
    property int cfg_WallpaperDelay: 60
    property int cfg_WallpaperLimit: 100
    property string cfg_Subreddit: "earthporn wallpaper"
    property string cfg_SubredditSection
    property string cfg_SubredditSectionTime
    property string cfg_PreferOrientation
    property bool cfg_ShowPostTitle: false
    property bool cfg_AllowNSFW: false

    Kirigami.FormLayout {
        twinFormLayouts: parentLayout
        wideMode: true

        ComboBox {
            id: resizeComboBox
            Kirigami.FormData.label: i18nd("plasma_wallpaper_org.kde.image", "Positioning:")
            model: [
                {
                    'label': i18nd("plasma_wallpaper_org.kde.image", "Scaled and Cropped"),
                    'fillMode': Image.PreserveAspectCrop
                },
                {
                    'label': i18nd("plasma_wallpaper_org.kde.image","Scaled"),
                    'fillMode': Image.Stretch
                },
                {
                    'label': i18nd("plasma_wallpaper_org.kde.image","Scaled, Keep Proportions"),
                    'fillMode': Image.PreserveAspectFit
                },
                {
                    'label': i18nd("plasma_wallpaper_org.kde.image", "Centered"),
                    'fillMode': Image.Pad
                },
                {
                    'label': i18nd("plasma_wallpaper_org.kde.image","Tiled"),
                    'fillMode': Image.Tile
                }
            ]

            textRole: "label"
            onCurrentIndexChanged: cfg_FillMode = model[currentIndex]["fillMode"]
            Component.onCompleted: setMethod();

            function setMethod() {
                for (var i = 0; i < model.length; i++) {
                    if (model[i]["fillMode"] === wallpaper.configuration.FillMode) {
                        resizeComboBox.currentIndex = i;
                        var tl = model[i]["label"].length;
                        //resizeComboBox.textLength = Math.max(resizeComboBox.textLength, tl+5);
                    }
                }
            }
        }

        ButtonGroup { id: backgroundGroup }

        RadioButton {
            id: blurRadioButton
            visible: cfg_FillMode === Image.PreserveAspectFit || cfg_FillMode === Image.Pad
            Kirigami.FormData.label: i18nd("plasma_wallpaper_org.kde.image", "Background:")
            text: i18nd("plasma_wallpaper_org.kde.image", "Blur")
            ButtonGroup.group: backgroundGroup
        }

        RowLayout {
            id: colorRow
            visible: cfg_FillMode === Image.PreserveAspectFit || cfg_FillMode === Image.Pad
            RadioButton {
                id: colorRadioButton
                text: i18nd("plasma_wallpaper_org.kde.image", "Solid color")
                checked: !cfg_Blur
                ButtonGroup.group: backgroundGroup
            }
            KQuickControls.ColorButton {
                id: colorButton
                dialogTitle: i18nd("plasma_wallpaper_org.kde.image", "Select Background Color")
            }
        }

        TextField {
            id: subredditInput
            text: cfg_Subreddit
            Kirigami.FormData.label: i18n("Subreddits:")
            onTextChanged: {
                cfg_Subreddit = text;
            }
        }

        ComboBox {
            id: subredditSectionDropdown
            Kirigami.FormData.label: i18n("Section:")
            model: [
                {
                    'label': i18n("Hot"),
                    'value': "hot"
                },
                {
                    'label': i18n("New"),
                    'value': "new"
                },
                {
                    'label': i18n("Rising"),
                    'value': "rising"
                },
                {
                    'label': i18n("Controversial"),
                    'value': "controversial"
                },
                {
                    'label': i18n("Top"),
                    'value': "top"
                },
                {
                    'label': i18n("Gilded"),
                    'value': "gilded"
                }
            ]
            textRole: "label"
            onActivated: cfg_SubredditSection = model[currentIndex].value
            Component.onCompleted: {
                for (let x = 0; x < model.length; x++) {
                    if (model[x].value === cfg_SubredditSection) {
                        currentIndex = x;
                        break;
                    }
                }
            }
        }

        ComboBox {
            id: subredditSectionTimeDropdown
            Kirigami.FormData.label: i18n("Find images in last:")
            model: [
                {
                    'label': i18n("Hour"),
                    'value': "hour"
                },
                {
                    'label': i18n("Day"),
                    'value': "day"
                },
                {
                    'label': i18n("Week"),
                    'value': "week"
                },
                {
                    'label': i18n("Month"),
                    'value': "month"
                },
                {
                    'label': i18n("Year"),
                    'value': "year"
                },
                {
                    'label': i18n("Forever"),
                    'value': "forever"
                }
            ]
            textRole: "label"
            onActivated: cfg_SubredditSectionTime = model[currentIndex].value
            Component.onCompleted: {
                for (let x = 0; x < model.length; x++) {
                    if (model[x].value === cfg_SubredditSectionTime) {
                        currentIndex = x;
                        break;
                    }
                }
            }
        }

        ComboBox {
            id: preferOrientationDropdown
            Kirigami.FormData.label: i18n("Prefer image orientation:")
            model: [
                {
                    'label': i18n("Any"),
                    'value': "any"
                },
                {
                    'label': i18n("Landscape"),
                    'value': "landscape"
                },
                {
                    'label': i18n("Portrait"),
                    'value': "portrait"
                }
            ]
            textRole: "label"
            onActivated: cfg_PreferOrientation = model[currentIndex].value
            Component.onCompleted: {
                for (let x = 0; x < model.length; x++) {
                    if (model[x].value === cfg_PreferOrientation) {
                        currentIndex = x;
                        break;
                    }
                }
            }
        }

        SpinBox {
            id: delaySpinBox
            value: cfg_WallpaperDelay
            onValueChanged: cfg_WallpaperDelay = value
            Kirigami.FormData.label: i18n("Wallpaper timer (min):")
            stepSize: 1
            from: 1
            to: 50000
            editable: true
        }

        SpinBox {
            id: limitSpinBox
            value: cfg_WallpaperLimit
            onValueChanged: cfg_WallpaperLimit = value
            Kirigami.FormData.label: i18n("Limit results to:")
            stepSize: 1
            from: 1
            to: 100
            editable: true
        }

        CheckBox {
            Kirigami.FormData.label: i18n("Show post title:")
            checked: cfg_ShowPostTitle
            onToggled: {
                cfg_ShowPostTitle = checked;
            }
        }

        CheckBox {
            Kirigami.FormData.label: i18n("Allow NSFW:")
            checked: cfg_AllowNSFW
            onToggled: {
                cfg_AllowNSFW = checked;
            }
        }

        Button {
            text: "Reroll Wallpaper"
            onClicked: {
                wallpaper.configuration.RefetchSignal = !wallpaper.configuration.RefetchSignal;
            }
        }

        Label {
            Kirigami.FormData.label: i18n("Current Wallpaper:")
            id: currentWallpaperLink
            wrapMode: Text.Wrap
            Layout.preferredWidth: 400
            onLinkActivated: Qt.openUrlExternally(link)
            text: `<html><a href="${wallpaper.configuration.currentWallpaperLink}">${wallpaper.configuration.currentWallpaperText || ""}</a></html>`
        }
    }
}
