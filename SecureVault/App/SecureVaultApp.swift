//
//  SecureVaultApp.swift
//  SecureVault
//
//  Created by Kirill Babiy on 16.09.2025.
//

import SwiftUI

@main
struct SecureVaultApp: App {
    @StateObject private var dataStore = DataStore.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataStore)
                .environmentObject(localizationManager)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var isLocked = true
    
    var body: some View {
        if isLocked {
            LoginView(isLocked: $isLocked)
        } else {
            MainTabView()
        }
    }
}
