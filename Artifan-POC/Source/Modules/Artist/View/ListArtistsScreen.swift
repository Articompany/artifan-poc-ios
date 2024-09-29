//
//  ListArtists.swift
//  Artifan-POC
//
//  Created by Victor Castro on 29/09/24.
//

import SwiftUI

struct ListArtistsScreen: View {
    
    @State private var vm = ArtistViewModel()
    
    var body: some View {
        VStack {
            AlertError(vm.errorView)
            if vm.isLoading {
                Text("Loading artists...")
            }
            AFGridItems(items: vm.artists, numOfColumns: 2)
                .refreshable {
                    await vm.syncArtists()
                }
            
        }.task {
            await vm.syncArtists()
        }
    }
}

#Preview {
    ListArtistsScreen()
}
