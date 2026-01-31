//
//  SettingsManager.swift
//  RestBreak
//
//  Manages persistent settings using UserDefaults.
//

import Foundation
import SwiftUI

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @AppStorage("workDurationMinutes") var workDurationMinutes: Int = 25
    @AppStorage("restDurationMinutes") var restDurationMinutes: Int = 5
    
    private init() {}
}
