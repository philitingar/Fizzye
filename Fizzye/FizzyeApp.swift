//
//  FizzyeApp.swift
//  Fizzye
//
//  Created by Timea Bartha on 9/12/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAnalytics

@main
struct FizzyeApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
