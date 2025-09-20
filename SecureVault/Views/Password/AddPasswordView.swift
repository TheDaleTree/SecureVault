//
//  AddPasswordView.swift
//  SecureVault
//
//  Created by Kirill Babiy on 16.09.2025.
//

import SwiftUI

struct AddPasswordView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var localizationManager: LocalizationManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var username = ""
    @State private var password = ""
    @State private var website = ""
    @State private var notes = ""
    @State private var selectedCategory: PasswordCategory = .personal
    @State private var showPassword = false
    @State private var showGenerator = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(localized(.mainInfo)) {
                    TextField(localized(.title), text: $title)
                    
                    TextField(localized(.username), text: $username)
                        .autocapitalization(.none)
                    
                    HStack {
                        if showPassword {
                            TextField(localized(.password), text: $password)
                                .autocapitalization(.none)
                        } else {
                            SecureField(localized(.password), text: $password)
                        }
                        
                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.secondary)
                        }
                        
                        Button(action: { showGenerator = true }) {
                            Image(systemName: "wand.and.stars")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Section(localized(.additionalInfo)) {
                    TextField(localized(.website), text: $website)
                        .autocapitalization(.none)
                        .keyboardType(.URL)
                    
                    Picker(localized(.category), selection: $selectedCategory) {
                        ForEach(PasswordCategory.allCases, id: \.self) { category in
                            Label(category.displayName, systemImage: category.systemImage)
                                .tag(category)
                        }
                    }
                    
                    TextField(localized(.notes), text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(localized(.newPassword))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localized(.cancel)) { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localized(.save)) {
                        savePassword()
                    }
                    .disabled(title.isEmpty || password.isEmpty)
                }
            }
            .sheet(isPresented: $showGenerator) {
                GeneratorSheet(generatedPassword: $password)
            }
        }
    }
    
    private func savePassword() {
        var newPassword = PasswordModel(
            title: title,
            username: username,
            website: website,
            notes: notes,
            category: selectedCategory
        )
        
        if let encrypted = CryptoManager.shared.encrypt(password) {
            newPassword.encryptedPassword = encrypted
            dataStore.addPassword(newPassword)
            dismiss()
        }
    }
}
