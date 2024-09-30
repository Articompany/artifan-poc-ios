//
//  ListArtists.swift
//  Artifan-POC
//
//  Created by Victor Castro on 29/09/24.
//

import SwiftUI
import Kingfisher

struct DashboardScreen: View {
    
    @State private var vm = ArtistViewModel()
    @State private var hasLoaded: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                AlertError(vm.error)
                if vm.isLoading {
                    Text("Loading artists...")
                }
                AFGridItems(items: vm.artists, numOfColumns: 2)
                    .refreshable {
                        await vm.syncArtists()
                    }
                
            }.onAppear {
                Task {
                    if !hasLoaded {
                        await vm.syncArtists()
                        hasLoaded = true
                    }
                }
            }.navigationTitle("List of artists")
        }
    }
}

#Preview {
    DashboardScreen()
}
