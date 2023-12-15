//
//  DateApp.swift
//  Date
//
//  Created by BAproductions on 1/18/22.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    let currentDate = Date()
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        guard let app = aNotification.object as? NSApplication else {
            fatalError("no application object")
        }

        guard app.windows.count > 0 else {
            fatalError("no windows")
        }
        app.setActivationPolicy(.prohibited)
        app.windows.first?.titleVisibility = .hidden
        app.windows.first?.titlebarAppearsTransparent = true
        app.windows.first?.isMovableByWindowBackground = true
        app.windows.first?.backgroundColor = .clear
        app.windows.first?.canHide = false
        app.windows.first?.isOpaque = false
        app.windows.first?.hasShadow = false
        app.windows.first?.isRestorable = false
        app.windows.first?.isDocumentEdited = false
        app.windows.first?.showsResizeIndicator = false
        app.windows.first?.showsToolbarButton = false
        app.windows.first?.styleMask = .titled
        app.windows.first?.styleMask.insert(.borderless)
        app.windows.first?.level = .mainMenu
        app.windows.first?.standardWindowButton(.zoomButton)?.isHidden = true
        app.windows.first?.standardWindowButton(.closeButton)?.isHidden = true
        app.windows.first?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        app.setActivationPolicy(.prohibited)
        app.appearance = .none
        NSWindow.allowsAutomaticWindowTabbing = false
        if let mainMenu = NSApp .mainMenu {
            DispatchQueue.main.async {
                for item in mainMenu.items {
                    mainMenu.removeItem(item);
                }
            }
        }
        app.windows.first?.toggleFullScreen(self)
        app.windows.first?.miniaturize(self)
        app.windows.first?.setIsMiniaturized(true)
        app.windows.first?.setIsZoomed(true)
        app.windows.first?.setIsVisible(true)
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString("\(currentDate.formatDT(format: "MM/dd/yyyy"))", forType: NSPasteboard.PasteboardType.string)
        NSApp.terminate(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

@main
struct DateApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
        }
    }
}
