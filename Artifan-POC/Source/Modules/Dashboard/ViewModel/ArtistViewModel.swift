//
//  ArtistViewModel.swift
//  Artifan-POC
//
//  Created by Victor Castro on 28/09/24.
//

import Foundation

@Observable
class ArtistViewModel {
    var artists: [ArtistModel] = []
    var isLoading: Bool = false
    var error: Error?
    
    func syncArtists() async {
        isLoading = true
        defer { isLoading = false }
        do {
            artists = try await fetchArtistsFromApi()
            error = nil
        } catch {
            self.error = error
        }
    }
    
    func fetchArtistsFromApi() async throws -> [ArtistModel] {
        let path = "/api/artists"
        
        let queryItems = [
            URLQueryItem(name: "[fields][0]", value: "id"),
            URLQueryItem(name: "[fields][1]", value: "name"),
            URLQueryItem(name: "[fields][2]", value: "city"),
            URLQueryItem(name: "populate[category][fields][0]", value: "name"),
            URLQueryItem(name: "populate[banner][fields][0]", value: "url"),
            URLQueryItem(name: "populate[banner][fields][1]", value: "formats")
        ]
        
        let response = try await APIManager.shared.call(path: path, method: .get, queryItems: queryItems, responseType: ArtistModelDTO.self)
        
        let artists: [ArtistModel] = response.data.map { dto in
            dto.toModel()
        }
        
        return artists
    }
}
