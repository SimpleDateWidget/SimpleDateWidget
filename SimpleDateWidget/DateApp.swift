//
//  DateApp.swift
//  Date
//
//  Created by BAproductions on 1/18/22.
//

import SwiftUI

class TransparentWindowView: NSView {
  override func viewDidMoveToWindow() {
    window?.backgroundColor = .clear
    super.viewDidMoveToWindow()
  }
}

struct TransparentWindow: NSViewRepresentable {
   func makeNSView(context: Self.Context) -> NSView { return TransparentWindowView() }
   func updateNSView(_ nsView: NSView, context: Context) { }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    let currentDate = Date()
    func applicationDidFinishLaunching(_ notification: Notification) {
        for window in NSApplication.shared.windows {
            window.tabbingMode = .disallowed
            window.appearance = .none
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.backgroundColor = .controlBackgroundColor
            window.showsResizeIndicator = false
            window.showsToolbarButton = false
            window.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.isHidden = true
            window.standardWindowButton(NSWindow.ButtonType.zoomButton)!.isHidden = true
            window.standardWindowButton(NSWindow.ButtonType.closeButton)!.isHidden = true
            window.hasShadow = false
            window.titlebarSeparatorStyle = .none
            window.toolbarStyle = .unifiedCompact
        }
    }
    func applicationDidBecomeActive(_ notification: Notification) {
        NSWindow.allowsAutomaticWindowTabbing = false
        UserDefaults.standard.set(true, forKey: "NSFullScreenMenuItemEverywhere")
        if let mainMenu = NSApp.mainMenu {
              DispatchQueue.main.async {
                  if let fileMenu = mainMenu.items.first(where: { $0.title == "File" }) {
                      mainMenu.removeItem(fileMenu)
                  }
                  if let editMenu = mainMenu.items.first(where: { $0.title == "Edit" }) {
                      mainMenu.removeItem(editMenu)
                  }
                  if let viewMenu = mainMenu.items.first(where: { $0.title == "View" }) {
                      mainMenu.removeItem(viewMenu)
                  }
                  if let windowMenu = mainMenu.items.first(where: { $0.title == "Window" }) {
                      mainMenu.removeItem(windowMenu)
                  }
                  if let helpMenu = mainMenu.items.first(where: { $0.title == "Help" }) {
                      mainMenu.removeItem(helpMenu)
                  }
              }
          }
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString("\(currentDate.formatDT(format: "MM/dd/yyyy"))", forType: NSPasteboard.PasteboardType.string)
        NSApp.terminate(self)
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
