//
//  GeneratorView.swift
//  SecureVault
//
//  Created by Kirill Babiy on 16.09.2025.
//

import SwiftUI

struct GeneratorView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var generatedPassword = ""
    @State private var passwordLength: Double = 16
    @State private var includeUppercase = true
    @State private var includeLowercase = true
    @State private var includeNumbers = true
    @State private var includeSymbols = true
    @State private var excludeAmbiguous = true
    @State private var copied = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Generated Password Display
                    VStack(spacing: 16) {
                        Text(generatedPassword.isEmpty ? localized(.clickToGenerate) : generatedPassword)
                            .font(.system(.title3, design: .monospaced))
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 80)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        
                        if !generatedPassword.isEmpty {
                            HStack(spacing: 12) {
                                Button(action: copyPassword) {
                                    Label(localized(.copy), systemImage: "doc.on.doc")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                
                                Button(action: generatePassword) {
                                    Label(localized(.refresh), systemImage: "arrow.clockwise")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                    .padding()
                    
                    // Options
                    VStack(alignment: .leading, spacing: 16) {
                        Text(localized(.generatorSettings))
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(localized(.passwordLength)): \(Int(passwordLength))")
                            Slider(value: $passwordLength, in: 8...32, step: 1)
                        }
                        
                        Toggle(localized(.uppercaseLetters), isOn: $includeUppercase)
                        Toggle(localized(.lowercaseLetters), isOn: $includeLowercase)
                        Toggle(localized(.numbers), isOn: $includeNumbers)
                        Toggle(localized(.symbols), isOn: $includeSymbols)
                        Toggle(localized(.excludeSimilar), isOn: $excludeAmbiguous)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Generate Button
                    Button(action: generatePassword) {
                        Text(localized(.generatePassword))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.horizontal)
                }
            }
            .navigationTitle(localized(.generator))
            .onAppear {
                generatePassword()
            }
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
    
    private func generatePassword() {
        let options = PasswordGenerator.Options(
            length: Int(passwordLength),
            includeUppercase: includeUppercase,
            includeLowercase: includeLowercase,
            includeNumbers: includeNumbers,
            includeSymbols: includeSymbols,
            excludeAmbiguous: excludeAmbiguous
        )
        
        generatedPassword = PasswordGenerator.generate(with: options)
    }
    
    private func copyPassword() {
        UIPasteboard.general.string = generatedPassword
        
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

struct GeneratorSheet: View {
    @Binding var generatedPassword: String
    @EnvironmentObject var localizationManager: LocalizationManager
    @Environment(\.dismiss) private var dismiss
    @State private var localPassword = ""
    @State private var passwordLength: Double = 16
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(localPassword.isEmpty ? localized(.clickToGenerate) : localPassword)
                    .font(.system(.title3, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text("\(localized(.passwordLength)): \(Int(passwordLength))")
                    Slider(value: $passwordLength, in: 8...32, step: 1)
                }
                .padding()
                
                HStack(spacing: 12) {
                    Button(localized(.generate)) {
                        localPassword = PasswordGenerator.generate(
                            with: PasswordGenerator.Options(length: Int(passwordLength))
                        )
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button(localized(.use)) {
                        generatedPassword = localPassword
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .disabled(localPassword.isEmpty)
                }
                
                Spacer()
            }
            .navigationTitle(localized(.generator))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localized(.cancel)) { dismiss() }
                }
            }
            .onAppear {
                localPassword = PasswordGenerator.generate(
                    with: PasswordGenerator.Options(length: Int(passwordLength))
                )
            }
        }
    }
}
