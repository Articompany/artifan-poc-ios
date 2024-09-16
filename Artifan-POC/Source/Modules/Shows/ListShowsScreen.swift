//
//  ListShowsScreen.swift
//  Artifan-POC
//
//  Created by Victor Castro on 10/08/24.
//

import SwiftUI
import Kingfisher

struct ListShowsScreen: View {
    @StateObject private var viewModel = ShowsViewModel()
    @State private var selectedCategory: String = "Todos"
    @State private var searchText: String = ""
    
    let categories = ["Todos", "Dalinas", "Payasos"]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var filteredShows: [ShowModel] {
        var showsCategorized: [ShowModel] = []
        // var filteredShows: [ShowModel] = []
        
        if selectedCategory == "Todos" {
            showsCategorized = viewModel.shows
        } else {
            showsCategorized = viewModel.shows.filter { $0.category?.name == selectedCategory }
        }
        
        if searchText.isEmpty {
            return showsCategorized
        } else {
            return showsCategorized.filter { $0.title.contains(searchText) || $0.description.contains(searchText) }
        }
        
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Categorías", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                ScrollView {
                    ListShowsGrid(items: filteredShows, numOfColumns: 2)
                }.refreshable {
                    await fetchShowsAvailables(refresh: true)
                }
            }
            .navigationTitle("Búsqueda y diversión")
            .searchable(text: $searchText, prompt: "Buscar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Perfil presionado")
                    }) {
                        Image(systemName: "person.crop.circle")
                            .font(.title2)
                    }
                }
            }
        }
        .task {
            await fetchShowsAvailables()
        }
    }
    
    private func fetchShowsAvailables(refresh: Bool = false) async {
        await viewModel.fetchShows(refreshLocalData: refresh)
    }
}

#Preview {
    ListShowsScreen()
}
