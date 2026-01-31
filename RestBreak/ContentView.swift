//
//  ContentView.swift
//  RestBreak
//
//  Main settings and status view displayed in the menu bar popover.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var timerManager: TimerManager
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            Text("Rest Break")
                .font(.headline)
                .padding(.top, 8)
            
            Divider()
            
            // Status
            if timerManager.isRunning {
                statusSection
            }
            
            // Settings
            if !timerManager.isResting {
                settingsSection
            }
            
            Divider()
            
            // Controls
            controlsSection
            
            Divider()
            
            // Quit button
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .padding(.bottom, 8)
        }
        .padding(.horizontal, 16)
        .frame(width: 280)
    }
    
    private var statusSection: some View {
        VStack(spacing: 8) {
            if timerManager.isResting {
                Label("Resting", systemImage: "bed.double.fill")
                    .foregroundColor(.green)
                Text("Time remaining: \(timerManager.restTimeRemaining)")
                    .font(.title2)
                    .monospacedDigit()
            } else {
                Label("Working", systemImage: "desktopcomputer")
                    .foregroundColor(.blue)
                Text("Next break in: \(timerManager.workTimeRemaining)")
                    .font(.title2)
                    .monospacedDigit()
            }
        }
        .padding(.vertical, 8)
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Settings")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Text("Work duration:")
                Spacer()
                Stepper("\(timerManager.workDuration) min", value: Binding(
                    get: { timerManager.workDuration },
                    set: { timerManager.workDuration = $0 }
                ), in: 1...120)
                .disabled(timerManager.isRunning)
            }
            
            HStack {
                Text("Rest duration:")
                Spacer()
                Stepper("\(timerManager.restDuration) min", value: Binding(
                    get: { timerManager.restDuration },
                    set: { timerManager.restDuration = $0 }
                ), in: 1...60)
                .disabled(timerManager.isRunning)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var controlsSection: some View {
        HStack(spacing: 12) {
            if timerManager.isRunning {
                Button(action: {
                    timerManager.stopWork()
                }) {
                    Label("Stop", systemImage: "stop.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            } else {
                Button(action: {
                    timerManager.startWork()
                }) {
                    Label("Start Working", systemImage: "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ContentView()
        .environmentObject(TimerManager())
}
