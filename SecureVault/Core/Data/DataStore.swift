//
//  DataStore.swift
//  SecureVault
//
//  Created by Kirill Babiy on 16.09.2025.
//

import Foundation
import SwiftUI

class DataStore: ObservableObject {
    static let shared = DataStore()
    
    @Published var passwords: [PasswordModel] = []
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let dataFileURL: URL
    
    private init() {
        self.dataFileURL = documentsDirectory.appendingPathComponent("passwords.encrypted")
        loadPasswords()
    }
    
    // MARK: - CRUD Operations
    
    func addPassword(_ password: PasswordModel) {
        passwords.append(password)
        savePasswords()
    }
    
    func updatePassword(_ password: PasswordModel) {
        if let index = passwords.firstIndex(where: { $0.id == password.id }) {
            passwords[index] = password
            savePasswords()
        }
    }
    
    func deletePassword(_ password: PasswordModel) {
        passwords.removeAll { $0.id == password.id }
        savePasswords()
    }
    
    func deleteAllPasswords() {
        passwords.removeAll()
        savePasswords()
    }
    
    // MARK: - Search and Filter
    
    func searchPasswords(query: String) -> [PasswordModel] {
        guard !query.isEmpty else { return passwords }
        
        return passwords.filter { password in
            password.title.localizedCaseInsensitiveContains(query) ||
            password.username.localizedCaseInsensitiveContains(query) ||
            password.website.localizedCaseInsensitiveContains(query) ||
            password.notes.localizedCaseInsensitiveContains(query)
        }
    }
    
    func passwordsByCategory(_ category: PasswordCategory) -> [PasswordModel] {
        passwords.filter { $0.category == category }
    }
    
    func favoritePasswords() -> [PasswordModel] {
        passwords.filter { $0.isFavorite }
    }
    
    // MARK: - Persistence
    
    private func savePasswords() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(passwords)
            
            // Шифруем данные перед сохранением
            if let encryptedData = CryptoManager.shared.encrypt(String(data: data, encoding: .utf8) ?? "") {
                try encryptedData.write(to: dataFileURL)
            }
        } catch {
            print("Error saving passwords: \(error)")
        }
    }
    
    private func loadPasswords() {
        guard FileManager.default.fileExists(atPath: dataFileURL.path) else {
            // Создаём тестовые данные для демонстрации
            createSampleData()
            return
        }
        
        do {
            let encryptedData = try Data(contentsOf: dataFileURL)
            
            // Расшифровываем данные
            if let decryptedString = CryptoManager.shared.decrypt(encryptedData),
               let data = decryptedString.data(using: .utf8) {
                let decoder = JSONDecoder()
                passwords = try decoder.decode([PasswordModel].self, from: data)
            }
        } catch {
            print("Error loading passwords: \(error)")
        }
    }
    
    // MARK: - Sample Data
    
    private func createSampleData() {
        let samplePasswords = [
            PasswordModel(
                title: "Apple ID",
                username: "user@example.com",
                website: "apple.com",
                category: .personal
            ),
            PasswordModel(
                title: "Gmail",
                username: "user@gmail.com",
                website: "gmail.com",
                category: .personal
            ),
            PasswordModel(
                title: "GitHub",
                username: "developer",
                website: "github.com",
                category: .work
            )
        ]
        
        // Устанавливаем пароли для примера
        for var password in samplePasswords {
            if let encrypted = CryptoManager.shared.encrypt("Password123!") {
                password.encryptedPassword = encrypted
                passwords.append(password)
            }
        }
        
        savePasswords()
    }
    
    // MARK: - Statistics
    
    func passwordsCount() -> Int {
        passwords.count
    }
    
    func weakPasswordsCount() -> Int {
        passwords.filter { password in
            guard let encryptedPassword = password.encryptedPassword,
                  let decrypted = CryptoManager.shared.decrypt(encryptedPassword) else {
                return false
            }
            return PasswordGenerator.strength(of: decrypted) == .weak
        }.count
    }
    
    func duplicatePasswordsCount() -> Int {
        var passwordTexts: [String] = []
        
        for password in passwords {
            if let encryptedPassword = password.encryptedPassword,
               let decrypted = CryptoManager.shared.decrypt(encryptedPassword) {
                passwordTexts.append(decrypted)
            }
        }
        
        let uniquePasswords = Set(passwordTexts)
        return passwordTexts.count - uniquePasswords.count
    }
}
