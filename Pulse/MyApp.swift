//
//  PulseApp.swift
//  Pulse
//
//  Created by Javier Canella Ramos on 18/01/26.
//

import SwiftUI

@main
struct MyApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    init() {
        FontRegistration.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ScreenHome()
            } else {
                OnboardingView()
            }
        }
    }
}
