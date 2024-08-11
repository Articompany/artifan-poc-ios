//
//  ShowView.swift
//  Artifan-POC
//
//  Created by Victor Castro on 10/08/24.
//

import SwiftUI

struct ShowView: View {
    @StateObject private var viewModel = ShowViewModel()
    @State private var selectedCategory: String = "Todos"
    
    let categories = ["Todos", "Dalinas", "Payasos"]
    
    // Define el diseño de la cuadrícula
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var filteredShows: [Show] {
        if selectedCategory == "Todos" {
            return viewModel.shows
        } else {
            return viewModel.shows.filter { $0.attributes.category?.data.attributes.name == selectedCategory }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // SegmentedPicker para seleccionar la categoría
                Picker("Categorías", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredShows) { show in
                            VStack(alignment: .leading) {
                                if let bannerURL = show.attributes.banner?.data?.attributes.url {
                                    AsyncImage(url: URL(string: "http://localhost:1337\(bannerURL)")) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(height: 150)
                                    .cornerRadius(8)
                                } else {
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(height: 150)
                                        .cornerRadius(8)
                                }
                                
                                Text(show.attributes.title)
                                    .font(.headline)
                                    .lineLimit(1)
                                
                                Text(show.attributes.city)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 4)
                        }
                    }
                    .padding(.all, 16)
                }
            }
            .navigationTitle("Shows")
            .onAppear {
                viewModel.fetchShows()
            }
        }
    }
}

#Preview {
    ShowView()
}
