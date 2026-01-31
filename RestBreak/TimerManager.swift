//
//  TimerManager.swift
//  RestBreak
//
//  Manages work and rest timers.
//

import Foundation
import SwiftUI
import Combine

class TimerManager: ObservableObject {
    @Published var isRunning: Bool = false
    @Published var isResting: Bool = false
    @Published var workSecondsElapsed: Int = 0
    @Published var restSecondsRemaining: Int = 0
    
    @AppStorage("workDurationMinutes") private var workDurationMinutes: Int = 25
    @AppStorage("restDurationMinutes") private var restDurationMinutes: Int = 5
    
    private var timer: Timer?
    private var restScreenController: RestScreenController?
    
    init() {
        // Auto-start work timer on launch
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.startWork()
        }
    }
    
    var workDuration: Int {
        get { workDurationMinutes }
        set { workDurationMinutes = newValue }
    }
    
    var restDuration: Int {
        get { restDurationMinutes }
        set { restDurationMinutes = newValue }
    }
    
    var workTimeRemaining: String {
        let totalSeconds = max(0, (workDurationMinutes * 60) - workSecondsElapsed)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var restTimeRemaining: String {
        let minutes = max(0, restSecondsRemaining) / 60
        let seconds = max(0, restSecondsRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func startWork() {
        guard !isRunning else { return }
        isRunning = true
        isResting = false
        workSecondsElapsed = 0
        startWorkTimer()
    }
    
    func stopWork() {
        stopTimer()
        isRunning = false
        isResting = false
        workSecondsElapsed = 0
        restSecondsRemaining = 0
        dismissRestScreen()
    }
    
    func emergencyExit() {
        print("[RestBreak] Emergency exit triggered")
        
        // Stop everything
        stopTimer()
        
        // Update state
        isResting = false
        workSecondsElapsed = 0
        restSecondsRemaining = 0
        
        // Dismiss screen
        dismissRestScreen()
        
        // Restart work timer after cleanup
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self, self.isRunning else { return }
            self.startWorkTimer()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startWorkTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.workTick()
        }
        // Add to common run loop mode to keep running during UI interactions
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    private func workTick() {
        workSecondsElapsed += 1
        
        if workSecondsElapsed >= workDurationMinutes * 60 {
            startRest()
        }
    }
    
    private func startRest() {
        print("[RestBreak] Starting rest period")
        stopTimer()
        isResting = true
        restSecondsRemaining = restDurationMinutes * 60
        
        showRestScreen()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.restTick()
        }
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    private func restTick() {
        restSecondsRemaining -= 1
        print("[RestBreak] Rest tick: \(restSecondsRemaining) seconds remaining")
        
        if restSecondsRemaining <= 0 {
            endRest()
        }
    }
    
    private func endRest() {
        print("[RestBreak] Rest period ended")
        stopTimer()
        isResting = false
        workSecondsElapsed = 0
        
        dismissRestScreen()
        
        // Restart work timer
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self, self.isRunning else { return }
            self.startWorkTimer()
        }
    }
    
    private func showRestScreen() {
        restScreenController = RestScreenController(timerManager: self)
        restScreenController?.showRestScreen()
    }
    
    private func dismissRestScreen() {
        print("[RestBreak] Dismissing rest screen")
        restScreenController?.dismissRestScreen()
        restScreenController = nil
    }
    
    deinit {
        stopTimer()
    }
}
