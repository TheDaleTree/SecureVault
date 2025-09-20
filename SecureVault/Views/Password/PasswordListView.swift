//
//  PasswordListView.swift
//  SecureVault
//
//  Created by Kirill Babiy on 16.09.2025.
//

import SwiftUI

struct PasswordListView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var searchText = ""
    @State private var showingAddPassword = false
    @State private var selectedPassword: PasswordModel?
    
    var filteredPasswords: [PasswordModel] {
        if searchText.isEmpty {
            return dataStore.passwords
        } else {
            return dataStore.searchPasswords(query: searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredPasswords) { password in
                    PasswordRowView(password: password)
                        .onTapGesture {
                            selectedPassword = password
                        }
                }
                .onDelete(perform: deletePasswords)
            }
            .navigationTitle("Пароли")
            .searchable(text: $searchText, prompt: "Поиск")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddPassword = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPassword) {
                AddPasswordView()
            }
            .sheet(item: $selectedPassword) { password in
                PasswordDetailView(password: password)
            }
        }
    }
    
    private func deletePasswords(at offsets: IndexSet) {
        for index in offsets {
            dataStore.deletePassword(filteredPasswords[index])
        }
    }
}

struct PasswordRowView: View {
    let password: PasswordModel
    
    var body: some View {
        HStack {
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
