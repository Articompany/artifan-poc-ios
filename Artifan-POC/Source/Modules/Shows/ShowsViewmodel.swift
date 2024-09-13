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
    @Published var error: Error?
    
    private let storage = LocalStorageManager.shared
    
    func fetchShows(refreshLocalData: Bool = false) async {
        if refreshLocalData {
            storage.resetAll()
        }
        var localShowsStored: [ShowModel] = []
        
        localShowsStored = storage.getObject(forKey: "savedShows", defaultValue: [])
        
        if localShowsStored.isEmpty {
            do {
                let showsFromApi = try await getShowsFromJson()
                storage.setObject(showsFromApi, forKey: "savedShows")
                localShowsStored = showsFromApi
            } catch {
                
            }
        }
        
        self.shows = localShowsStored
        
    }
    
    func getShowsFromApi() async throws -> [ShowModel] {
        
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
            showDTO.toModel()
        }
        
        return shows
    }
    
    func getShowsFromJson() async throws -> [ShowModel] {
        guard let url = Bundle.main.url(forResource: "shows", withExtension: "json") else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let showsResponse = try decoder.decode(ShowsResponseJSONDTO.self, from: data)
            
            return showsResponse.data
        } catch {
            print("Error al cargar o decodificar el archivo shows.json: \(error)")
            return []
        }
    }
}
