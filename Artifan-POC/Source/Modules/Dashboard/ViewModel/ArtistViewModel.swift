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
    var artist: ArtistModel?
    var isLoading: Bool = false
    var error: Error?
    
    func getArtistBy(id: String) async {
        isLoading = true
        artist = nil
        defer { isLoading = false }
        do {
            artist = try await fetchOneArtistFromApi(id)
            error = nil
        } catch {
            artist = nil
            self.error = error
        }
    }
    
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
    
    func fetchOneArtistFromApi(_ id: String) async throws -> ArtistModel {
        let path = "/api/artists/\(id)"
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "populate", value: "*")
        ]
        
        let response = try await APIManager.shared.call(path: path, method: .get, queryItems: queryItems, responseType: OneArtistResponseDTO.self)
        
        let artist: ArtistModel = response.data.toModel()
        
        return artist
    }
    
    func fetchArtistsFromApi() async throws -> [ArtistModel] {
        let path = "/api/artists"
        
        let fields = ["id", "documentId", "name", "city", "description"]
        let categoryFields = ["documentId", "name"]
        let bannerFields = ["url", "formats"]
        
        var queryItems: [URLQueryItem] = []

        for (index, field) in fields.enumerated() {
            queryItems.append(URLQueryItem(name: "[fields][\(index)]", value: field))
        }
        
        for (index, field) in categoryFields.enumerated() {
            queryItems.append(URLQueryItem(name: "populate[category][fields][\(index)]", value: field))
        }
        
        for (index, field) in bannerFields.enumerated() {
            queryItems.append(URLQueryItem(name: "populate[banner][fields][\(index)]", value: field))
        }
        
        let response = try await APIManager.shared.call(path: path, method: .get, queryItems: queryItems, responseType: ListArtistsResponseDTO.self)
        
        let artists: [ArtistModel] = response.data.map { dto in
            dto.toModel()
        }
        
        return artists
    }
}
