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
    @State private var isLocked = true
    
    var body: some Scene {
        WindowGroup {
            RootView(isLocked: $isLocked)
                .environmentObject(dataStore)
        }
    }
}

struct RootView: View {
    @Binding var isLocked: Bool
    @EnvironmentObject var dataStore: DataStore
    
    var body: some View {
        if isLocked {
            LoginView(isLocked: $isLocked)
        } else {
            MainTabView()
        }
    }
}
