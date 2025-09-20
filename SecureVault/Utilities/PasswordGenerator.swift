//
//  PasswordGenerator.swift
//  SecureVault
//
//  Created by Kirill Babiy on 16.09.2025.
//

import Foundation

struct PasswordGenerator {
    
    struct Options {
        var length: Int = 16
        var includeUppercase: Bool = true
        var includeLowercase: Bool = true
        var includeNumbers: Bool = true
        var includeSymbols: Bool = true
        var excludeAmbiguous: Bool = true
        
        static let `default` = Options()
        
        static let pin = Options(
            length: 6,
            includeUppercase: false,
            includeLowercase: false,
            includeNumbers: true,
            includeSymbols: false
        )
        
        static let simple = Options(
            length: 12,
            includeUppercase: true,
            includeLowercase: true,
            includeNumbers: true,
            includeSymbols: false
        )
        
        static let strong = Options(
            length: 20,
            includeUppercase: true,
            includeLowercase: true,
            includeNumbers: true,
            includeSymbols: true
        )
    }
    
    private static let uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    private static let lowercaseLetters = "abcdefghijklmnopqrstuvwxyz"
    private static let numbers = "0123456789"
    private static let symbols = "!@#$%^&*()_+-=[]{}|;:,.<>?"
    
    private static let ambiguousCharacters = Set("0OoIl1")
    
    static func generate(with options: Options = .default) -> String {
        var characterSet = ""
        var requiredCharacters: [Character] = []
        
        // Добавляем наборы символов
        if options.includeUppercase {
            let chars = options.excludeAmbiguous ?
                uppercaseLetters.filter { !ambiguousCharacters.contains($0) } :
                uppercaseLetters
            characterSet += chars
            if let randomChar = chars.randomElement() {
                requiredCharacters.append(randomChar)
            }
        }
        
        if options.includeLowercase {
            let chars = options.excludeAmbiguous ?
                lowercaseLetters.filter { !ambiguousCharacters.contains($0) } :
                lowercaseLetters
            characterSet += chars
            if let randomChar = chars.randomElement() {
                requiredCharacters.append(randomChar)
            }
        }
        
        if options.includeNumbers {
            let chars = options.excludeAmbiguous ?
                numbers.filter { !ambiguousCharacters.contains($0) } :
                numbers
            characterSet += chars
            if let randomChar = chars.randomElement() {
                requiredCharacters.append(randomChar)
            }
        }
        
        if options.includeSymbols {
            characterSet += symbols
            if let randomChar = symbols.randomElement() {
                requiredCharacters.append(randomChar)
            }
        }
        
        guard !characterSet.isEmpty else {
            return ""
        }
        
        // Генерируем оставшиеся символы
        let remainingLength = max(0, options.length - requiredCharacters.count)
        var password = requiredCharacters
        
        for _ in 0..<remainingLength {
            if let randomChar = characterSet.randomElement() {
                password.append(randomChar)
            }
        }
        
        // Перемешиваем пароль
        return String(password.shuffled())
    }
    
    static func generatePassphrase(wordCount: Int = 4, separator: String = "-") -> String {
        let words = [
            "apple", "banana", "cherry", "dragon", "eagle", "forest", "galaxy", "harbor",
            "island", "jungle", "kitten", "lemon", "mountain", "nebula", "ocean", "phoenix",
            "quantum", "rainbow", "sunset", "thunder", "unicorn", "volcano", "waterfall",
            "yellow", "zebra", "alpha", "bravo", "charlie", "delta", "echo"
        ]
        
        var selectedWords: [String] = []
        
        for _ in 0..<wordCount {
            if let word = words.randomElement() {
                selectedWords.append(word.capitalized)
            }
        }
        
        // Добавляем случайное число
        if let randomNumber = (0...999).randomElement() {
            selectedWords.append(String(randomNumber))
        }
        
        return selectedWords.joined(separator: separator)
    }
    
    static func strength(of password: String) -> PasswordStrength {
        var score = 0
        let length = password.count
        
        // Проверка длины
        if length >= 8 { score += 1 }
        if length >= 12 { score += 1 }
        if length >= 16 { score += 1 }
        
        // Проверка типов символов
        if password.contains(where: { $0.isUppercase }) { score += 1 }
        if password.contains(where: { $0.isLowercase }) { score += 1 }
        if password.contains(where: { $0.isNumber }) { score += 1 }
        if password.contains(where: { symbols.contains($0) }) { score += 1 }
        
        switch score {
        case 0...2: return .weak
        case 3...4: return .fair
        case 5...6: return .good
        default: return .strong
        }
    }
}
