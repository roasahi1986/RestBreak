//
//  RestScreenView.swift
//  RestBreak
//
//  Full-screen rest break overlay view.
//

import SwiftUI
import AppKit

// NSVisualEffectView wrapper for frosted glass effect
struct VisualEffectBackground: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        view.isEmphasized = true
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.clear.cgColor
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
        nsView.state = .active
    }
}

struct RestScreenView: View {
    @ObservedObject var timerManager: TimerManager
    @State private var isButtonDisabled = false
    
    var body: some View {
        ZStack {
            // Frosted glass effect - uses behindWindow to blur desktop/apps
            VisualEffectBackground(
                material: .fullScreenUI,
                blendingMode: .behindWindow
            )
            
            // Subtle dark tint overlay for better text contrast
            Color.black.opacity(0.15)
            
            // Content
            VStack(spacing: 30) {
                Spacer()
                
                // Rest icon
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.white.opacity(0.8))
                
                // Rest message
                Text("Time to Rest")
                    .font(.system(size: 56, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("Take a break from your screen")
                    .font(.system(size: 22))
                    .foregroundStyle(.white.opacity(0.7))
                
                Spacer()
                    .frame(height: 40)
                
                // Large countdown timer
                Text(timerManager.restTimeRemaining)
                    .font(.system(size: 180, weight: .thin, design: .monospaced))
                    .foregroundStyle(.white)
                
                Text("remaining")
                    .font(.system(size: 24, weight: .light))
                    .foregroundStyle(.white.opacity(0.6))
                
                Spacer()
                
                // Emergency button
                Button(action: handleEmergencyExit) {
                    HStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text(isButtonDisabled ? "Exiting..." : "Emergency Exit")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 14)
                    .background(isButtonDisabled ? Color.gray : Color.red.opacity(0.8))
                    .cornerRadius(10)
                }
                .buttonStyle(.plain)
                .disabled(isButtonDisabled)
                
                Spacer()
                    .frame(height: 50)
            }
        }
    }
    
    private func handleEmergencyExit() {
        guard !isButtonDisabled else { return }
        isButtonDisabled = true
        
        // Small delay to let the UI update, then exit
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            timerManager.emergencyExit()
        }
    }
}

#Preview {
    RestScreenView(timerManager: TimerManager())
}
