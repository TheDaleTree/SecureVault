//
//  CryptoManager.swift
//  SecureVault
//
//  Created by Kirill Babiy on 16.09.2025.
//

import Foundation
import CryptoKit

final class CryptoManager {
    static let shared = CryptoManager()
    
    private let keyTag = "com.securevault.encryptionkey"
    private var symmetricKey: SymmetricKey?
    
    private init() {
        self.symmetricKey = getOrCreateKey()
    }
    
    // MARK: - Key Management
    
    private func getOrCreateKey() -> SymmetricKey {
        // Пытаемся получить ключ из Keychain
        if let keyData = retrieveKeyFromKeychain() {
            return SymmetricKey(data: keyData)
        } else {
            // Создаём новый ключ
            let newKey = SymmetricKey(size: .bits256)
            let keyData = newKey.withUnsafeBytes { Data($0) }
            saveKeyToKeychain(keyData)
            return newKey
        }
    }
    
    private func saveKeyToKeychain(_ keyData: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyTag,
            kSecValueData as String: keyData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        // Удаляем старый ключ если есть
        SecItemDelete(query as CFDictionary)
        
        // Добавляем новый
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("Error saving key to keychain: \(status)")
        }
    }
    
    private func retrieveKeyFromKeychain() -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyTag,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess {
            return result as? Data
        }
        
        return nil
    }
    
    // MARK: - Encryption/Decryption
    
    func encrypt(_ string: String) -> Data? {
        guard let key = symmetricKey,
              let data = string.data(using: .utf8) else {
            return nil
        }
        
        do {
            let sealed = try AES.GCM.seal(data, using: key)
            return sealed.combined
        } catch {
            print("Encryption error: \(error)")
            return nil
        }
    }
    
    func decrypt(_ data: Data) -> String? {
        guard let key = symmetricKey else { return nil }
        
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            let decrypted = try AES.GCM.open(sealedBox, using: key)
            return String(data: decrypted, encoding: .utf8)
        } catch {
            print("Decryption error: \(error)")
            return nil
        }
    }
    
    // MARK: - Password Hashing
    
    func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
