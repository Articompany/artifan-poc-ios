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
    
    let categories = ["Todos", "Dalinas", "Payasos"]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var filteredShows: [ShowModel] {
        if selectedCategory == "Todos" {
            return viewModel.shows
        } else {
            return viewModel.shows.filter { $0.category?.name == selectedCategory }
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
                ListShowsGrid(items: filteredShows, numOfColumns: 2)
                    .refreshable {
                        await fetchShowsAvailables(refresh: true)
                    }
            }
            .navigationTitle("Shows")
            .task {
                await fetchShowsAvailables()
            }
        }
    }
    
    private func fetchShowsAvailables(refresh: Bool = false) async {
        await viewModel.fetchShows(refreshLocalData: refresh)
    }
}

#Preview {
    ListShowsScreen()
}
