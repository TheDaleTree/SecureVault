//
//  PasswordListView.swift
//  SecureVault
//
//  Created by Kirill Babiy on 16.09.2025.
//

import SwiftUI

struct PasswordListView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var searchText = ""
    @State private var showingAddPassword = false
    @State private var selectedPassword: PasswordModel?
    @State private var selectedPasswords = Set<UUID>()
    @State private var isSelectionMode = false
    @State private var showDeleteConfirmation = false
    
    var filteredPasswords: [PasswordModel] {
        if searchText.isEmpty {
            return dataStore.passwords
        } else {
            return dataStore.searchPasswords(query: searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if filteredPasswords.isEmpty {
                    Spacer()
                    Text(localized(.noPasswords))
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    List(selection: $selectedPasswords) {
                        ForEach(filteredPasswords) { password in
                            PasswordRowView(password: password, isSelected: selectedPasswords.contains(password.id))
                                .onTapGesture {
                                    if isSelectionMode {
                                        toggleSelection(for: password)
                                    } else {
                                        selectedPassword = password
                                    }
                                }
                        }
                        .onDelete(perform: deletePasswords)
                    }
                    .listStyle(PlainListStyle())
                    .environment(\.editMode, .constant(isSelectionMode ? .active : .inactive))
                }
            }
            .navigationTitle(localized(.passwords))
            .searchable(text: $searchText, prompt: localized(.search))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if isSelectionMode {
                        Button(localized(.cancel)) {
                            isSelectionMode = false
                            selectedPasswords.removeAll()
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        if isSelectionMode {
                            Button(action: deleteSelectedPasswords) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .disabled(selectedPasswords.isEmpty)
                        } else {
                            Button(action: { isSelectionMode = true }) {
                                Image(systemName: "checkmark.circle")
                            }
                            
                            Button(action: { showingAddPassword = true }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddPassword) {
                AddPasswordView()
            }
            .sheet(item: $selectedPassword) { password in
                PasswordDetailView(password: password)
            }
            .alert(localized(.deleteConfirmation), isPresented: $showDeleteConfirmation) {
                Button(localized(.cancel), role: .cancel) { }
                Button(localized(.delete), role: .destructive) {
                    for id in selectedPasswords {
                        if let password = dataStore.passwords.first(where: { $0.id == id }) {
                            dataStore.deletePassword(password)
                        }
                    }
                    selectedPasswords.removeAll()
                    isSelectionMode = false
                }
            } message: {
                Text(localized(.cannotUndo))
            }
        }
    }
    
    private func toggleSelection(for password: PasswordModel) {
        if selectedPasswords.contains(password.id) {
            selectedPasswords.remove(password.id)
        } else {
            selectedPasswords.insert(password.id)
        }
    }
    
    private func deletePasswords(at offsets: IndexSet) {
        for index in offsets {
            dataStore.deletePassword(filteredPasswords[index])
        }
    }
    
    private func deleteSelectedPasswords() {
        showDeleteConfirmation = true
    }
}

struct PasswordRowView: View {
    let password: PasswordModel
    let isSelected: Bool
    
    var body: some View {
        HStack {
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
            
            Image(systemName: password.category.systemImage)
                .foregroundColor(password.category.color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(password.title)
                    .font(.headline)
                
                if !password.username.isEmpty {
                    Text(password.username)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if password.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
}
