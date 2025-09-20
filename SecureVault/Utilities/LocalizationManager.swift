//
//  LocalizationManager.swift
//  SecureVault
//
//  Created by Kirill Babiy on 20.09.2025.
//

import Foundation
import SwiftUI

// MARK: - Localization Manager
class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en" {
        didSet {
            objectWillChange.send()
        }
    }
    
    private init() {}
    
    enum Language: String, CaseIterable {
        case english = "en"
        case russian = "ru"
        case ukrainian = "uk"
        case german = "de"
        case spanish = "es"
        
        var displayName: String {
            switch self {
            case .english: return "English"
            case .russian: return "Русский"
            case .ukrainian: return "Українська"
            case .german: return "Deutsch"
            case .spanish: return "Español"
            }
        }
        
        var flag: String {
            switch self {
            case .english: return "🇬🇧"
            case .russian: return "🇷🇺"
            case .ukrainian: return "🇺🇦"
            case .german: return "🇩🇪"
            case .spanish: return "🇪🇸"
            }
        }
    }
    
    func string(for key: LocalizationKey) -> String {
        return key.localized(for: selectedLanguage)
    }
}

// MARK: - Localization Keys
enum LocalizationKey: String {
    // App
    case appName = "app_name"
    case appDescription = "app_description"
    
    // Authentication
    case login = "login"
    case logout = "logout"
    case enterWithFaceID = "enter_with_faceid"
    case enterWithTouchID = "enter_with_touchid"
    case usePassword = "use_password"
    case authenticationError = "authentication_error"
    case authenticationFailed = "authentication_failed"
    
    // Tabs
    case passwords = "passwords"
    case generator = "generator"
    case settings = "settings"
    
    // Password List
    case search = "search"
    case addPassword = "add_password"
    case newPassword = "new_password"
    case editPassword = "edit_password"
    case deletePassword = "delete_password"
    case noPasswords = "no_passwords"
    case deleteConfirmation = "delete_confirmation"
    case cannotUndo = "cannot_undo"
    
    // Password Fields
    case title = "title"
    case username = "username"
    case password = "password"
    case website = "website"
    case notes = "notes"
    case category = "category"
    case mainInfo = "main_info"
    case additionalInfo = "additional_info"
    
    // Categories
    case personal = "personal"
    case work = "work"
    case finance = "finance"
    case social = "social"
    case entertainment = "entertainment"
    case shopping = "shopping"
    case other = "other"
    
    // Generator
    case generatePassword = "generate_password"
    case passwordLength = "password_length"
    case uppercaseLetters = "uppercase_letters"
    case lowercaseLetters = "lowercase_letters"
    case numbers = "numbers"
    case symbols = "symbols"
    case excludeSimilar = "exclude_similar"
    case copy = "copy"
    case copied = "copied"
    case refresh = "refresh"
    
    // Settings
    case security = "security"
    case requireFaceID = "require_faceid"
    case requireTouchID = "require_touchid"
    case autoLock = "auto_lock"
    case data = "data"
    case totalPasswords = "total_passwords"
    case deleteAll = "delete_all"
    case deleteAllConfirmation = "delete_all_confirmation"
    case about = "about"
    case version = "version"
    case language = "language"
    case theme = "theme"
    case lightTheme = "light_theme"
    case darkTheme = "dark_theme"
    case systemTheme = "system_theme"
    
    // Actions
    case save = "save"
    case cancel = "cancel"
    case delete = "delete"
    case done = "done"
    case ok = "ok"
    case error = "error"
    case use = "use"
    case generate = "generate"
    
    // Time units
    case seconds = "seconds"
    case minute = "minute"
    case minutes = "minutes"
    
    // Password Details
    case details = "details"
    case created = "created"
    case updated = "updated"
    case lastUsed = "last_used"
    case showPassword = "show_password"
    case hidePassword = "hide_password"
    
    // Generator specific
    case clickToGenerate = "click_to_generate"
    case generatorSettings = "generator_settings"
    
    func localized(for language: String) -> String {
        return LocalizationStrings.strings[language]?[self.rawValue] ?? self.rawValue
    }
}

// MARK: - Localization Strings Storage
struct LocalizationStrings {
    static let strings: [String: [String: String]] = [
        "en": [
            // App
            "app_name": "SecureVault",
            "app_description": "Your passwords are protected",
            
            // Authentication
            "login": "Login",
            "logout": "Logout",
            "enter_with_faceid": "Enter with Face ID",
            "enter_with_touchid": "Enter with Touch ID",
            "use_password": "Use Password",
            "authentication_error": "Authentication Error",
            "authentication_failed": "Authentication failed",
            
            // Tabs
            "passwords": "Passwords",
            "generator": "Generator",
            "settings": "Settings",
            
            // Password List
            "search": "Search",
            "add_password": "Add Password",
            "new_password": "New Password",
            "edit_password": "Edit Password",
            "delete_password": "Delete Password",
            "no_passwords": "No passwords",
            "delete_confirmation": "Delete password?",
            "cannot_undo": "This action cannot be undone",
            
            // Password Fields
            "title": "Title",
            "username": "Username",
            "password": "Password",
            "website": "Website",
            "notes": "Notes",
            "category": "Category",
            "main_info": "Main Information",
            "additional_info": "Additional",
            
            // Categories
            "personal": "Personal",
            "work": "Work",
            "finance": "Finance",
            "social": "Social",
            "entertainment": "Entertainment",
            "shopping": "Shopping",
            "other": "Other",
            
            // Generator
            "generate_password": "Generate Password",
            "password_length": "Password Length",
            "uppercase_letters": "Uppercase Letters (A-Z)",
            "lowercase_letters": "Lowercase Letters (a-z)",
            "numbers": "Numbers (0-9)",
            "symbols": "Symbols (!@#$...)",
            "exclude_similar": "Exclude Similar (0, O, l, I)",
            "copy": "Copy",
            "copied": "Copied!",
            "refresh": "Refresh",
            
            // Settings
            "security": "Security",
            "require_faceid": "Require Face ID",
            "require_touchid": "Require Touch ID",
            "auto_lock": "Auto-Lock",
            "data": "Data",
            "total_passwords": "Total Passwords",
            "delete_all": "Delete All Passwords",
            "delete_all_confirmation": "Delete all passwords?",
            "about": "About",
            "version": "Version",
            "language": "Language",
            "theme": "Theme",
            "light_theme": "Light",
            "dark_theme": "Dark",
            "system_theme": "System",
            
            // Actions
            "save": "Save",
            "cancel": "Cancel",
            "delete": "Delete",
            "done": "Done",
            "ok": "OK",
            "error": "Error",
            "use": "Use",
            "generate": "Generate",
            
            // Time units
            "seconds": "seconds",
            "minute": "minute",
            "minutes": "minutes",
            
            // Password Details
            "details": "Details",
            "created": "Created",
            "updated": "Updated",
            "last_used": "Last used",
            "show_password": "Show password",
            "hide_password": "Hide password",
            
            // Generator specific
            "click_to_generate": "Click 'Generate' to create password",
            "generator_settings": "Settings"
        ],
        
        "ru": [
            // App
            "app_name": "SecureVault",
            "app_description": "Ваши пароли под защитой",
            
            // Authentication
            "login": "Вход",
            "logout": "Выход",
            "enter_with_faceid": "Войти с Face ID",
            "enter_with_touchid": "Войти с Touch ID",
            "use_password": "Использовать пароль",
            "authentication_error": "Ошибка аутентификации",
            "authentication_failed": "Не удалось выполнить аутентификацию",
            
            // Tabs
            "passwords": "Пароли",
            "generator": "Генератор",
            "settings": "Настройки",
            
            // Password List
            "search": "Поиск",
            "add_password": "Добавить пароль",
            "new_password": "Новый пароль",
            "edit_password": "Редактировать",
            "delete_password": "Удалить пароль",
            "no_passwords": "Нет паролей",
            "delete_confirmation": "Удалить пароль?",
            "cannot_undo": "Это действие нельзя отменить",
            
            // Password Fields
            "title": "Название",
            "username": "Имя пользователя",
            "password": "Пароль",
            "website": "Веб-сайт",
            "notes": "Заметки",
            "category": "Категория",
            "main_info": "Основная информация",
            "additional_info": "Дополнительно",
            
            // Categories
            "personal": "Личное",
            "work": "Работа",
            "finance": "Финансы",
            "social": "Соцсети",
            "entertainment": "Развлечения",
            "shopping": "Покупки",
            "other": "Другое",
            
            // Generator
            "generate_password": "Сгенерировать пароль",
            "password_length": "Длина пароля",
            "uppercase_letters": "Заглавные буквы (A-Z)",
            "lowercase_letters": "Строчные буквы (a-z)",
            "numbers": "Цифры (0-9)",
            "symbols": "Символы (!@#$...)",
            "exclude_similar": "Исключить похожие (0, O, l, I)",
            "copy": "Копировать",
            "copied": "Скопировано!",
            "refresh": "Обновить",
            
            // Settings
            "security": "Безопасность",
            "require_faceid": "Требовать Face ID",
            "require_touchid": "Требовать Touch ID",
            "auto_lock": "Автоблокировка",
            "data": "Данные",
            "total_passwords": "Всего паролей",
            "delete_all": "Удалить все пароли",
            "delete_all_confirmation": "Удалить все пароли?",
            "about": "О приложении",
            "version": "Версия",
            "language": "Язык",
            "theme": "Тема",
            "light_theme": "Светлая",
            "dark_theme": "Тёмная",
            "system_theme": "Системная",
            
            // Actions
            "save": "Сохранить",
            "cancel": "Отмена",
            "delete": "Удалить",
            "done": "Готово",
            "ok": "OK",
            "error": "Ошибка",
            "use": "Использовать",
            "generate": "Сгенерировать",
            
            // Time units
            "seconds": "секунд",
            "minute": "минута",
            "minutes": "минут",
            
            // Password Details
            "details": "Детали",
            "created": "Создан",
            "updated": "Изменён",
            "last_used": "Использован",
            "show_password": "Показать пароль",
            "hide_password": "Скрыть пароль",
            
            // Generator specific
            "click_to_generate": "Нажмите 'Сгенерировать' для создания пароля",
            "generator_settings": "Настройки"
        ],
        
        "uk": [
            // App
            "app_name": "SecureVault",
            "app_description": "Ваші паролі під захистом",
            
            // Authentication
            "login": "Вхід",
            "logout": "Вихід",
            "enter_with_faceid": "Увійти з Face ID",
            "enter_with_touchid": "Увійти з Touch ID",
            "use_password": "Використати пароль",
            "authentication_error": "Помилка автентифікації",
            "authentication_failed": "Не вдалося виконати автентифікацію",
            
            // Tabs
            "passwords": "Паролі",
            "generator": "Генератор",
            "settings": "Налаштування",
            
            // Password List
            "search": "Пошук",
            "add_password": "Додати пароль",
            "new_password": "Новий пароль",
            "edit_password": "Редагувати",
            "delete_password": "Видалити пароль",
            "no_passwords": "Немає паролів",
            "delete_confirmation": "Видалити пароль?",
            "cannot_undo": "Цю дію не можна скасувати",
            
            // Password Fields
            "title": "Назва",
            "username": "Ім'я користувача",
            "password": "Пароль",
            "website": "Веб-сайт",
            "notes": "Нотатки",
            "category": "Категорія",
            "main_info": "Основна інформація",
            "additional_info": "Додатково",
            
            // Categories
            "personal": "Особисте",
            "work": "Робота",
            "finance": "Фінанси",
            "social": "Соцмережі",
            "entertainment": "Розваги",
            "shopping": "Покупки",
            "other": "Інше",
            
            // Generator
            "generate_password": "Згенерувати пароль",
            "password_length": "Довжина паролю",
            "uppercase_letters": "Великі літери (A-Z)",
            "lowercase_letters": "Малі літери (a-z)",
            "numbers": "Цифри (0-9)",
            "symbols": "Символи (!@#$...)",
            "exclude_similar": "Виключити схожі (0, O, l, I)",
            "copy": "Копіювати",
            "copied": "Скопійовано!",
            "refresh": "Оновити",
            
            // Settings
            "security": "Безпека",
            "require_faceid": "Вимагати Face ID",
            "require_touchid": "Вимагати Touch ID",
            "auto_lock": "Автоблокування",
            "data": "Дані",
            "total_passwords": "Всього паролів",
            "delete_all": "Видалити всі паролі",
            "delete_all_confirmation": "Видалити всі паролі?",
            "about": "Про додаток",
            "version": "Версія",
            "language": "Мова",
            "theme": "Тема",
            "light_theme": "Світла",
            "dark_theme": "Темна",
            "system_theme": "Системна",
            
            // Actions
            "save": "Зберегти",
            "cancel": "Скасувати",
            "delete": "Видалити",
            "done": "Готово",
            "ok": "OK",
            "error": "Помилка",
            "use": "Використати",
            "generate": "Згенерувати",
            
            // Time units
            "seconds": "секунд",
            "minute": "хвилина",
            "minutes": "хвилин",
            
            // Password Details
            "details": "Деталі",
            "created": "Створено",
            "updated": "Змінено",
            "last_used": "Використано",
            "show_password": "Показати пароль",
            "hide_password": "Сховати пароль",
            
            // Generator specific
            "click_to_generate": "Натисніть 'Згенерувати' для створення паролю",
            "generator_settings": "Налаштування"
        ],
        
        "de": [
            // App
            "app_name": "SecureVault",
            "app_description": "Ihre Passwörter sind geschützt",
            
            // Authentication
            "login": "Anmelden",
            "logout": "Abmelden",
            "enter_with_faceid": "Mit Face ID anmelden",
            "enter_with_touchid": "Mit Touch ID anmelden",
            "use_password": "Passwort verwenden",
            "authentication_error": "Authentifizierungsfehler",
            "authentication_failed": "Authentifizierung fehlgeschlagen",
            
            // Tabs
            "passwords": "Passwörter",
            "generator": "Generator",
            "settings": "Einstellungen",
            
            // Password List
            "search": "Suchen",
            "add_password": "Passwort hinzufügen",
            "new_password": "Neues Passwort",
            "edit_password": "Bearbeiten",
            "delete_password": "Passwort löschen",
            "no_passwords": "Keine Passwörter",
            "delete_confirmation": "Passwort löschen?",
            "cannot_undo": "Diese Aktion kann nicht rückgängig gemacht werden",
            
            // Password Fields
            "title": "Titel",
            "username": "Benutzername",
            "password": "Passwort",
            "website": "Webseite",
            "notes": "Notizen",
            "category": "Kategorie",
            "main_info": "Hauptinformationen",
            "additional_info": "Zusätzlich",
            
            // Categories
            "personal": "Persönlich",
            "work": "Arbeit",
            "finance": "Finanzen",
            "social": "Sozial",
            "entertainment": "Unterhaltung",
            "shopping": "Einkaufen",
            "other": "Andere",
            
            // Generator
            "generate_password": "Passwort generieren",
            "password_length": "Passwortlänge",
            "uppercase_letters": "Großbuchstaben (A-Z)",
            "lowercase_letters": "Kleinbuchstaben (a-z)",
            "numbers": "Zahlen (0-9)",
            "symbols": "Symbole (!@#$...)",
            "exclude_similar": "Ähnliche ausschließen (0, O, l, I)",
            "copy": "Kopieren",
            "copied": "Kopiert!",
            "refresh": "Aktualisieren",
            
            // Settings
            "security": "Sicherheit",
            "require_faceid": "Face ID erforderlich",
            "require_touchid": "Touch ID erforderlich",
            "auto_lock": "Auto-Sperre",
            "data": "Daten",
            "total_passwords": "Gesamt Passwörter",
            "delete_all": "Alle Passwörter löschen",
            "delete_all_confirmation": "Alle Passwörter löschen?",
            "about": "Über",
            "version": "Version",
            "language": "Sprache",
            "theme": "Thema",
            "light_theme": "Hell",
            "dark_theme": "Dunkel",
            "system_theme": "System",
            
            // Actions
            "save": "Speichern",
            "cancel": "Abbrechen",
            "delete": "Löschen",
            "done": "Fertig",
            "ok": "OK",
            "error": "Fehler",
            "use": "Verwenden",
            "generate": "Generieren",
            
            // Time units
            "seconds": "Sekunden",
            "minute": "Minute",
            "minutes": "Minuten",
            
            // Password Details
            "details": "Details",
            "created": "Erstellt",
            "updated": "Aktualisiert",
            "last_used": "Zuletzt verwendet",
            "show_password": "Passwort anzeigen",
            "hide_password": "Passwort verbergen",
            
            // Generator specific
            "click_to_generate": "Klicken Sie auf 'Generieren', um ein Passwort zu erstellen",
            "generator_settings": "Einstellungen"
        ],
        
        "es": [
            // App
            "app_name": "SecureVault",
            "app_description": "Tus contraseñas están protegidas",
            
            // Authentication
            "login": "Iniciar sesión",
            "logout": "Cerrar sesión",
            "enter_with_faceid": "Entrar con Face ID",
            "enter_with_touchid": "Entrar con Touch ID",
            "use_password": "Usar contraseña",
            "authentication_error": "Error de autenticación",
            "authentication_failed": "La autenticación falló",
            
            // Tabs
            "passwords": "Contraseñas",
            "generator": "Generador",
            "settings": "Ajustes",
            
            // Password List
            "search": "Buscar",
            "add_password": "Añadir contraseña",
            "new_password": "Nueva contraseña",
            "edit_password": "Editar",
            "delete_password": "Eliminar contraseña",
            "no_passwords": "Sin contraseñas",
            "delete_confirmation": "¿Eliminar contraseña?",
            "cannot_undo": "Esta acción no se puede deshacer",
            
            // Password Fields
            "title": "Título",
            "username": "Nombre de usuario",
            "password": "Contraseña",
            "website": "Sitio web",
            "notes": "Notas",
            "category": "Categoría",
            "main_info": "Información principal",
            "additional_info": "Adicional",
            
            // Categories
            "personal": "Personal",
            "work": "Trabajo",
            "finance": "Finanzas",
            "social": "Social",
            "entertainment": "Entretenimiento",
            "shopping": "Compras",
            "other": "Otro",
            
            // Generator
            "generate_password": "Generar contraseña",
            "password_length": "Longitud de contraseña",
            "uppercase_letters": "Mayúsculas (A-Z)",
            "lowercase_letters": "Minúsculas (a-z)",
            "numbers": "Números (0-9)",
            "symbols": "Símbolos (!@#$...)",
            "exclude_similar": "Excluir similares (0, O, l, I)",
            "copy": "Copiar",
            "copied": "¡Copiado!",
            "refresh": "Actualizar",
            
            // Settings
            "security": "Seguridad",
            "require_faceid": "Requerir Face ID",
            "require_touchid": "Requerir Touch ID",
            "auto_lock": "Bloqueo automático",
            "data": "Datos",
            "total_passwords": "Total de contraseñas",
            "delete_all": "Eliminar todas las contraseñas",
            "delete_all_confirmation": "¿Eliminar todas las contraseñas?",
            "about": "Acerca de",
            "version": "Versión",
            "language": "Idioma",
            "theme": "Tema",
            "light_theme": "Claro",
            "dark_theme": "Oscuro",
            "system_theme": "Sistema",
            
            // Actions
            "save": "Guardar",
            "cancel": "Cancelar",
            "delete": "Eliminar",
            "done": "Hecho",
            "ok": "OK",
            "error": "Error",
            "use": "Usar",
            "generate": "Generar",
            
            // Time units
            "seconds": "segundos",
            "minute": "minuto",
            "minutes": "minutos",
            
            // Password Details
            "details": "Detalles",
            "created": "Creado",
            "updated": "Actualizado",
            "last_used": "Último uso",
            "show_password": "Mostrar contraseña",
            "hide_password": "Ocultar contraseña",
            
            // Generator specific
            "click_to_generate": "Haz clic en 'Generar' para crear una contraseña",
            "generator_settings": "Configuración"
        ]
    ]
}

// MARK: - View Extension for Easy Localization
extension View {
    func localized(_ key: LocalizationKey) -> String {
        LocalizationManager.shared.string(for: key)
    }
}
