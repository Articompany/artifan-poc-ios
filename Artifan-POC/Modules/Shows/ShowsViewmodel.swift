//
//  ShowsViewmodel.swift
//  Artifan-POC
//
//  Created by Victor Castro on 10/08/24.
//

import SwiftUI

@MainActor
class ShowsViewModel: ObservableObject {
    
    @Published var shows: [ShowModel] = []
    
    func fetchShows() async throws {
        
        let path = "/api/shows"
        
        let queryItems = [
            URLQueryItem(name: "populate", value: "*"),
        ]
        
        let response = try await APIManager.shared.call(
            path: path,
            method: .get,
            queryItems: queryItems,
            responseType: ShowsResponseDTO.self
        )
        
        let shows: [ShowModel] = response.data.map { showDTO in
            let banner = ShowModel.Banner(id: showDTO.attributes.banner?.data.id ?? 0, url: showDTO.attributes.banner?.data.attributes.url)
            let category = ShowModel.Category(id: showDTO.attributes.category?.data.id ?? 0, name: showDTO.attributes.category?.data.attributes.name ?? "")
            let show = ShowModel(id: showDTO.id, title: showDTO.attributes.title, description: showDTO.attributes.description ?? "", city: showDTO.attributes.city, banner: banner, category: category)
            
            return show
        }
        
        self.shows = shows
    }
}
