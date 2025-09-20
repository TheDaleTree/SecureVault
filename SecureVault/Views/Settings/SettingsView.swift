//
//  SettingsView.swift
//  SecureVault
//
//  Created by Kirill Babiy on 16.09.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataStore: DataStore
    @AppStorage("requireBiometric") private var requireBiometric = true
    @AppStorage("autoLockTimeout") private var autoLockTimeout = 60.0
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Безопасность") {
                    Toggle("Требовать Face ID", isOn: $requireBiometric)
                    
                    Picker("Автоблокировка", selection: $autoLockTimeout) {
                        Text("30 секунд").tag(30.0)
                        Text("1 минута").tag(60.0)
                        Text("5 минут").tag(300.0)
                        Text("15 минут").tag(900.0)
                    }
                }
                
                Section("Данные") {
                    HStack {
                        Text("Всего паролей")
                        Spacer()
                        Text("\(dataStore.passwords.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Удалить все пароли") {
                        showDeleteAlert = true
                    }
                    .foregroundColor(.red)
                }
                
                Section("О приложении") {
                    HStack {
                        Text("Версия")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Настройки")
            .alert("Удалить все пароли?", isPresented: $showDeleteAlert) {
                Button("Отмена", role: .cancel) { }
                Button("Удалить", role: .destructive) {
                    dataStore.deleteAllPasswords()
                }
            } message: {
                Text("Это действие нельзя отменить")
            }
        }
    }
}
