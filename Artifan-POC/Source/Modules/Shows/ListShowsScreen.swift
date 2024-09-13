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
                
                ListShowsGrid(gridItems: viewModel.showsItem, numOfColumns: 2)
//                ScrollView {
//                    LazyVGrid(columns: columns, spacing: 16) {
//                        ForEach(filteredShows) { show in
//                            NavigationLink(destination: ShowView(show: show)) {
//                                VStack(alignment: .leading) {
//                                    if let bannerURL = show.banner?.url {
//                                        KFImage(URL(string: bannerURL))
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(height: 150)
//                                            .cornerRadius(8)
//                                    } else {
//                                        Rectangle()
//                                            .fill(Color.gray)
//                                            .frame(height: 150)
//                                            .cornerRadius(8)
//                                    }
//                                    Text(show.title)
//                                        .font(.title3)
//                                        .lineLimit(2)
//                                    
//                                    Text(show.city)
//                                        .font(.subheadline)
//                                        .foregroundColor(.secondary)
//                                }
//                                .padding()
//                                .background(Color.white)
//                                .cornerRadius(10)
//                                .shadow(radius: 4)
//                            }
//                        }
//                    }
//                    .padding(.all, 16)
//                }
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
