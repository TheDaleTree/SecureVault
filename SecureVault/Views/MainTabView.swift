//
//  MainTabView.swift
//  SecureVault
//
//  Created by Kirill Babiy on 16.09.2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            PasswordListView()
                .tabItem {
                    Label("Пароли", systemImage: "key.fill")
                }
            
            GeneratorView()
                .tabItem {
                    Label("Генератор", systemImage: "wand.and.stars")
                }
            
            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gear")
                }
        }
    }
}
