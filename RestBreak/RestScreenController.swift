//
//  RestScreenController.swift
//  RestBreak
//
//  Controls the full-screen rest break window.
//

import AppKit
import SwiftUI

class RestScreenController: NSObject, NSWindowDelegate {
    private var windows: [NSWindow] = []
    private weak var timerManager: TimerManager?
    private var isClosing = false
    
    init(timerManager: TimerManager) {
        self.timerManager = timerManager
        super.init()
    }
    
    func showRestScreen() {
        guard !isClosing else { return }
        
        // Create a window for each screen to cover everything
        for screen in NSScreen.screens {
            let window = createWindow(for: screen)
            windows.append(window)
            window.makeKeyAndOrderFront(nil)
        }
        
        // Hide the dock and menu bar
        NSApp.setActivationPolicy(.accessory)
        
        // Activate our app
        NSApp.activate(ignoringOtherApps: true)
        
        // Make the first window key
        windows.first?.makeKey()
    }
    
    private func createWindow(for screen: NSScreen) -> NSWindow {
        let window = NSWindow(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false,
            screen: screen
        )
        
        window.delegate = self
        // Level above popups/dropdowns (status=25, popUpMenu=101, screenSaver=1000)
        window.level = NSWindow.Level(rawValue: 102)  // Just above popUpMenu level
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        window.isOpaque = false
        window.hasShadow = false
        window.backgroundColor = NSColor.black.withAlphaComponent(0.001)  // Nearly transparent but enables blur
        window.ignoresMouseEvents = false
        window.acceptsMouseMovedEvents = true
        window.isReleasedWhenClosed = false
        
        // Position exactly at screen frame including menu bar area
        window.setFrame(screen.frame, display: true)
        
        // Set the SwiftUI view as content
        if let timerManager = timerManager {
            let restView = RestScreenView(timerManager: timerManager)
            let hostingView = NSHostingView(rootView: restView)
            window.contentView = hostingView
        }
        
        return window
    }
    
    func dismissRestScreen() {
        guard !isClosing else { return }
        isClosing = true
        
        // Restore dock and menu bar
        NSApp.setActivationPolicy(.accessory)
        
        // Close all windows
        let windowsToClose = windows
        windows.removeAll()
        
        // Close on next run loop to avoid issues
        DispatchQueue.main.async { [weak self] in
            for window in windowsToClose {
                window.contentView = nil
                window.orderOut(nil)
                window.close()
            }
            self?.isClosing = false
        }
    }
    
    // Prevent window from being closed by other means
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        return isClosing
    }
}
