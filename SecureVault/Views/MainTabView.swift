//
//  MainTabView.swift
//  SecureVault
//
//  Created by Kirill Babiy on 16.09.2025.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        TabView {
            PasswordListView()
                .tabItem {
                    Label(localized(.passwords), systemImage: "key.fill")
                }
            
            GeneratorView()
                .tabItem {
                    Label(localized(.generator), systemImage: "wand.and.stars")
                }
            
            SettingsView()
                .tabItem {
                    Label(localized(.settings), systemImage: "gear")
                }
        }
    }
}
