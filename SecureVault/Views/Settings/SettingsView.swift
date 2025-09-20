//
//  SettingsView.swift
//  SecureVault
//
//  Created by Kirill Babiy on 16.09.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var localizationManager: LocalizationManager
    @AppStorage("requireBiometric") private var requireBiometric = true
    @AppStorage("autoLockTimeout") private var autoLockTimeout = 60.0
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                // Language Section
                Section(localized(.language)) {
                    ForEach(LocalizationManager.Language.allCases, id: \.self) { language in
                        HStack {
                            Text("\(language.flag) \(language.displayName)")
                            Spacer()
                            if localizationManager.selectedLanguage == language.rawValue {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            localizationManager.selectedLanguage = language.rawValue
                        }
                    }
                }
                
                // Security Section
                Section(localized(.security)) {
                    Toggle(localized(.requireFaceID), isOn: $requireBiometric)
                    
                    Picker(localized(.autoLock), selection: $autoLockTimeout) {
                        Text("30 \(timeUnitText(30))").tag(30.0)
                        Text("1 \(timeUnitText(60))").tag(60.0)
                        Text("5 \(timeUnitText(300))").tag(300.0)
                        Text("15 \(timeUnitText(900))").tag(900.0)
                    }
                }
                
                // Data Section
                Section(localized(.data)) {
                    HStack {
                        Text(localized(.totalPasswords))
                        Spacer()
                        Text("\(dataStore.passwords.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    Button(localized(.deleteAll)) {
                        showDeleteAlert = true
                    }
                    .foregroundColor(.red)
                }
                
                // About Section
                Section(localized(.about)) {
                    HStack {
                        Text(localized(.version))
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(localized(.settings))
            .alert(localized(.deleteAllConfirmation), isPresented: $showDeleteAlert) {
                Button(localized(.cancel), role: .cancel) { }
                Button(localized(.delete), role: .destructive) {
                    dataStore.deleteAllPasswords()
                }
            } message: {
                Text(localized(.cannotUndo))
            }
        }
    }
    
    private func timeUnitText(_ seconds: Double) -> String {
        switch seconds {
        case 30:
            return localized(.seconds)
        case 60:
            return localized(.minute)
        case 300, 900:
            return localized(.minutes)
        default:
            return localized(.minutes)
        }
    }
}
