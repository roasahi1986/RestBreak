//
//  RestBreakApp.swift
//  RestBreak
//
//  A macOS app that enforces rest breaks during work.
//

import SwiftUI

@main
struct RestBreakApp: App {
    @StateObject private var timerManager = TimerManager()
    
    init() {
        // Timer will auto-start in TimerManager.init()
    }
    
    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environmentObject(timerManager)
        } label: {
            Label {
                Text("Rest Break")
            } icon: {
                Image(systemName: timerManager.isResting ? "bed.double.fill" : "timer")
            }
        }
        .menuBarExtraStyle(.window)
    }
}
