/*
    SPDX-FileCopyrightText: 2013 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.kquickcontrolsaddons 2.0

PlasmaCore.ToolTipArea {
    id: root
    objectName: "org.kde.desktop-CompactApplet"
    anchors.fill: parent

    mainText: Plasmoid.toolTipMainText
    subText: Plasmoid.toolTipSubText
    location: Plasmoid.location
    active: !Plasmoid.expanded
    textFormat: Plasmoid.toolTipTextFormat
    mainItem: Plasmoid.toolTipItem ? Plasmoid.toolTipItem : null

    property Item fullRepresentation
    property Item compactRepresentation
    property Item expandedFeedback: expandedItem

    onCompactRepresentationChanged: {
        if (compactRepresentation) {
            compactRepresentation.anchors.fill = null;
            compactRepresentation.parent = compactRepresentationParent;
            compactRepresentation.anchors.fill = compactRepresentationParent;
            compactRepresentation.visible = true;
        }
        root.visible = true;
    }

    onFullRepresentationChanged: {
        if (fullRepresentation) {
            fullRepresentation.anchors.fill = null;
            fullRepresentation.parent = appletParent;
            fullRepresentation.anchors.fill = appletParent;
        }
    }

    FocusScope {
        id: compactRepresentationParent
        anchors.fill: parent
        activeFocusOnTab: true
        onActiveFocusChanged: {
            // When the scope gets the active focus, try to focus its first descendant,
            // if there is on which has activeFocusOnTab
            if (!activeFocus) {
                return;
            }
            let nextItem = nextItemInFocusChain();
            let candidate = nextItem;
            while (candidate.parent) {
                if (candidate === compactRepresentationParent) {
                    nextItem.forceActiveFocus();
                    return;
                }
                candidate = candidate.parent;
            }
        }

        Accessible.name: root.mainText
        Accessible.description: i18n("Open %1", root.subText)
        Accessible.role: Accessible.Button
        Accessible.onPressAction: Plasmoid.nativeInterface.activated()

        Keys.onPressed: {
            switch (event.key) {
                case Qt.Key_Space:
                case Qt.Key_Enter:
                case Qt.Key_Return:
                case Qt.Key_Select:
                    Plasmoid.nativeInterface.activated();
                    break;
            }
        }
    }

    PlasmaCore.FrameSvgItem {
        id: expandedItem

        // skip containerMargins code from plasma-desktop, as we are not on a panel here.

        anchors.fill: parent
        imagePath: "widgets/tabbar"
        visible: fromCurrentTheme && opacity > 0
        prefix: {
            let prefix;
            switch (Plasmoid.location) {
            case PlasmaCore.Types.LeftEdge:
                prefix = "west-active-tab";
                break;
            case PlasmaCore.Types.TopEdge:
                prefix = "north-active-tab";
                break;
            case PlasmaCore.Types.RightEdge:
                prefix = "east-active-tab";
                break;
            default:
                prefix = "south-active-tab";
            }
            if (!hasElementPrefix(prefix)) {
                prefix = "active-tab";
            }
            return prefix;
        }
        opacity: Plasmoid.expanded ? 1 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: PlasmaCore.Units.shortDuration
                easing.type: Easing.InOutQuad
            }
        }
    }

    Timer {
        id: expandedSync
        interval: 100
        onTriggered: Plasmoid.expanded = popupWindow.visible;
    }

    Connections {
        target: Plasmoid.action("configure")
        function onTriggered() {
            if (Plasmoid.hideOnWindowDeactivate) {
                Plasmoid.expanded = false
            }
        }
    }

    Connections {
        target: Plasmoid.self
        function onContextualActionsAboutToShow() { root.hideImmediately() }
    }

    PlasmaCore.Dialog {
        id: popupWindow
        objectName: "popupWindow"
        flags: Qt.WindowStaysOnTopHint
        visible: Plasmoid.expanded && fullRepresentation
        visualParent: root.compactRepresentation
        location: Plasmoid.location
        hideOnWindowDeactivate: Plasmoid.hideOnWindowDeactivate
        backgroundHints: (Plasmoid.containmentDisplayHints & PlasmaCore.Types.DesktopFullyCovered) ? PlasmaCore.Dialog.SolidBackground : PlasmaCore.Dialog.StandardBackground

        property var oldStatus: PlasmaCore.Types.UnknownStatus
        appletInterface: {
            if (!fullRepresentation || !fullRepresentation.appletInterface)
                return null
            return fullRepresentation.appletInterface
        }
        type: PlasmaCore.Dialog.AppletPopup

        //It's a MouseEventListener to get all the events, so the eventfilter will be able to catch them
        mainItem: MouseEventListener {
            id: appletParent

            focus: true

            Keys.onEscapePressed: {
                Plasmoid.expanded = false;
            }

            LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
            LayoutMirroring.childrenInherit: true

            Layout.minimumWidth: fullRepresentation ? fullRepresentation.Layout.minimumWidth : 0
            Layout.minimumHeight: fullRepresentation ? fullRepresentation.Layout.minimumHeight : 0

            Layout.preferredWidth: fullRepresentation ? fullRepresentation.Layout.preferredWidth : -1
            Layout.preferredHeight: fullRepresentation ? fullRepresentation.Layout.preferredHeight : -1

            Layout.maximumWidth: fullRepresentation ? fullRepresentation.Layout.maximumWidth : Infinity
            Layout.maximumHeight: fullRepresentation ? fullRepresentation.Layout.maximumHeight : Infinity

            width: {
                if (root.fullRepresentation !== null) {
                    /****/ if (root.fullRepresentation.Layout.preferredWidth > 0) {
                        return root.fullRepresentation.Layout.preferredWidth;
                    } else if (root.fullRepresentation.implicitWidth > 0) {
                        return root.fullRepresentation.implicitWidth;
                    }
                }
                return PlasmaCore.Theme.mSize(PlasmaCore.Theme.defaultFont).width * 35;
            }
            height: {
                if (root.fullRepresentation !== null) {
                    /****/ if (fullRepresentation.Layout.preferredHeight > 0) {
                        return fullRepresentation.Layout.preferredHeight;
                    } else if (fullRepresentation.implicitHeight > 0) {
                        return fullRepresentation.implicitHeight;
                    }
                }
                return PlasmaCore.Theme.mSize(PlasmaCore.Theme.defaultFont).height * 25;
            }

            onActiveFocusChanged: {
                if (activeFocus && fullRepresentation) {
                    fullRepresentation.forceActiveFocus()
                }
            }

            // skip a line between the applet dialog and the panel code from plasma-desktop, as we are not on a panel here.
        }

        onVisibleChanged: {
            if (!visible) {
                expandedSync.restart();
                Plasmoid.status = oldStatus;
            } else {
                oldStatus = Plasmoid.status;
                Plasmoid.status = PlasmaCore.Types.RequiresAttentionStatus;
                // This call currently fails and complains at runtime:
                // QWindow::setWindowState: QWindow::setWindowState does not accept Qt::WindowActive
                popupWindow.requestActivate();
            }
        }
    }
}
