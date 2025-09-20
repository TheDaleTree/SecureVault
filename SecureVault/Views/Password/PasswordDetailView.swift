//
//  PasswordDetailView.swift
//  SecureVault
//
//  Created by Kirill Babiy on 16.09.2025.
//

import SwiftUI

struct PasswordDetailView: View {
    let password: PasswordModel
    @EnvironmentObject var localizationManager: LocalizationManager
    @Environment(\.dismiss) private var dismiss
    @State private var showPassword = false
    @State private var decryptedPassword = ""
    @State private var copied = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: password.category.systemImage)
                            .font(.system(size: 50))
                            .foregroundColor(password.category.color)
                        
                        Text(password.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(password.category.displayName)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                    
                    // Fields
                    VStack(spacing: 16) {
                        if !password.username.isEmpty {
                            DetailField(
                                title: localized(.username),
                                value: password.username,
                                systemImage: "person.fill"
                            ) {
                                copyToClipboard(password.username)
                            }
                        }
                        
                        DetailField(
                            title: localized(.password),
                            value: showPassword ? decryptedPassword : "••••••••",
                            systemImage: "lock.fill",
                            trailing: {
                                Button(action: { showPassword.toggle() }) {
                                    Image(systemName: showPassword ? "eye.slash" : "eye")
                                        .foregroundColor(.secondary)
                                }
                            }
                        ) {
                            copyToClipboard(decryptedPassword)
                        }
                        
                        if !password.website.isEmpty {
                            DetailField(
                                title: localized(.website),
                                value: password.website,
                                systemImage: "globe"
                            ) {
                                copyToClipboard(password.website)
                            }
                        }
                        
                        if !password.notes.isEmpty {
                            DetailField(
                                title: localized(.notes),
                                value: password.notes,
                                systemImage: "note.text"
                            ) {
                                copyToClipboard(password.notes)
                            }
                        }
                    }
                    .padding()
                    
                    // Dates
                    VStack(alignment: .leading, spacing: 8) {
                        Label("\(localized(.created)): \(password.createdAt.formatted())", systemImage: "calendar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Label("\(localized(.updated)): \(password.updatedAt.formatted())", systemImage: "clock")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
            }
            .navigationTitle(localized(.details))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localized(.done)) { dismiss() }
                }
            }
        }
        .onAppear {
            loadPassword()
        }
        .overlay(alignment: .top) {
            if copied {
                Text(localized(.copied))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 50)
            }
        }
    }
    
    private func loadPassword() {
        if let encryptedData = password.encryptedPassword,
           let decrypted = CryptoManager.shared.decrypt(encryptedData) {
            decryptedPassword = decrypted
        }
    }
    
    private func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
        
        withAnimation {
            copied = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                copied = false
            }
        }
    }
}

struct DetailField<Trailing: View>: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    let title: String
    let value: String
    let systemImage: String
    let trailing: Trailing?
    let onCopy: () -> Void
    
    init(
        title: String,
        value: String,
        systemImage: String,
        @ViewBuilder trailing: () -> Trailing = { EmptyView() },
        onCopy: @escaping () -> Void
    ) {
        self.title = title
        self.value = value
        self.systemImage = systemImage
        self.trailing = trailing()
        self.onCopy = onCopy
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: systemImage)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                Text(value)
                    .font(.body)
                
                Spacer()
                
                trailing
                
                Button(action: onCopy) {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

extension DetailField where Trailing == EmptyView {
    init(
        title: String,
        value: String,
        systemImage: String,
        onCopy: @escaping () -> Void
    ) {
        self.init(
            title: title,
            value: value,
            systemImage: systemImage,
            trailing: { EmptyView() },
            onCopy: onCopy
        )
    }
}
