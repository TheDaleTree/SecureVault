//
//  LoginView.swift
//  SecureVault
//
//  Created by Kirill Babiy on 16.09.2025.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @Binding var isLocked: Bool
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Logo
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text(localized(.appName))
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(localized(.appDescription))
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            // Buttons
            VStack(spacing: 20) {
                Button(action: authenticateWithBiometrics) {
                    Label(localized(.enterWithFaceID), systemImage: "faceid")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: authenticateWithPassword) {
                    Label(localized(.usePassword), systemImage: "key.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .alert(localized(.error), isPresented: $showError) {
            Button(localized(.ok), role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = localized(.appDescription)
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    if success {
                        withAnimation {
                            isLocked = false
                        }
                    } else {
                        errorMessage = localized(.authenticationFailed)
                        showError = true
                    }
                }
            }
        } else {
            errorMessage = localized(.authenticationError)
            showError = true
        }
    }
    
    private func authenticateWithPassword() {
        // Для демонстрации просто разблокируем
        withAnimation {
            isLocked = false
        }
    }
}
