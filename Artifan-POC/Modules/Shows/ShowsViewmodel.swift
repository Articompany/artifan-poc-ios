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
                let showsFromApi = try await getShowsFromApi()
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
}
