//
//  PasswordModel.swift
//  SecureVault
//
//  Created by Kirill Babiy on 16.09.2025.
//

import Foundation
import SwiftUI

// MARK: - Password Model
struct PasswordModel: Identifiable, Codable {
    let id: UUID
    var title: String
    var username: String
    var encryptedPassword: Data?
    var website: String
    var notes: String
    var category: PasswordCategory
    var createdAt: Date
    var updatedAt: Date
    var lastUsedAt: Date?
    var isFavorite: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        username: String = "",
        encryptedPassword: Data? = nil,
        website: String = "",
        notes: String = "",
        category: PasswordCategory = .personal,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        lastUsedAt: Date? = nil,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.title = title
        self.username = username
        self.encryptedPassword = encryptedPassword
        self.website = website
        self.notes = notes
        self.category = category
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastUsedAt = lastUsedAt
        self.isFavorite = isFavorite
    }
}

// MARK: - Password Category
enum PasswordCategory: String, CaseIterable, Codable {
    case personal = "personal"
    case work = "work"
    case finance = "finance"
    case social = "social"
    case entertainment = "entertainment"
    case shopping = "shopping"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .personal: return "Личное"
        case .work: return "Работа"
        case .finance: return "Финансы"
        case .social: return "Соцсети"
        case .entertainment: return "Развлечения"
        case .shopping: return "Покупки"
        case .other: return "Другое"
        }
    }
    
    var systemImage: String {
        switch self {
        case .personal: return "person.fill"
        case .work: return "briefcase.fill"
        case .finance: return "creditcard.fill"
        case .social: return "bubble.left.and.bubble.right.fill"
        case .entertainment: return "tv.fill"
        case .shopping: return "cart.fill"
        case .other: return "folder.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .personal: return .blue
        case .work: return .purple
        case .finance: return .green
        case .social: return .orange
        case .entertainment: return .pink
        case .shopping: return .yellow
        case .other: return .gray
        }
    }
}

// MARK: - Password Strength
enum PasswordStrength: String, CaseIterable {
    case weak = "Слабый"
    case fair = "Средний"
    case good = "Хороший"
    case strong = "Сильный"
    
    var color: Color {
        switch self {
        case .weak: return .red
        case .fair: return .orange
        case .good: return .yellow
        case .strong: return .green
        }
    }
    
    var score: Double {
        switch self {
        case .weak: return 0.25
        case .fair: return 0.5
        case .good: return 0.75
        case .strong: return 1.0
        }
    }
}
