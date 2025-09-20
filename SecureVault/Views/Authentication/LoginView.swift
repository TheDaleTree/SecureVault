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
            
            Text("SecureVault")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Ваши пароли под защитой")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            // Buttons
            VStack(spacing: 20) {
                Button(action: authenticateWithBiometrics) {
                    Label("Войти с Face ID", systemImage: "faceid")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: authenticateWithPassword) {
                    Label("Использовать пароль", systemImage: "key.fill")
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
        .alert("Ошибка", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Войдите для доступа к паролям") { success, error in
                DispatchQueue.main.async {
                    if success {
                        withAnimation {
                            isLocked = false
                        }
                    } else {
                        errorMessage = "Не удалось выполнить аутентификацию"
                        showError = true
                    }
                }
            }
        } else {
            errorMessage = "Face ID недоступен"
            showError = true
        }
    }
    
    private func authenticateWithPassword() {
        // Для демонстрации просто разблокируем
        // В реальном приложении здесь должна быть проверка мастер-пароля
        withAnimation {
            isLocked = false
        }
    }
}
