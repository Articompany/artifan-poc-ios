//
//  DashboardScreen.swift
//  Artifan-POC
//
//  Created by Victor Castro on 29/09/24.
//

import SwiftUI
import Kingfisher
import AlertToast

struct DashboardScreen: View {
    
    @State private var vm = ArtistViewModel()
    @State private var hasLoaded: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                AFGridItems(items: vm.artists, numOfColumns: 2)
                    .refreshable {
                        await vm.syncArtists()
                    }
                
            }
            .task {
                if !hasLoaded {
                    await vm.syncArtists()
                    hasLoaded = true
                }
            }
            .navigationTitle("List of artists")
            .toast(isPresenting: .constant(vm.error != nil)) {
                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: "Error to load artists", subTitle: vm.error?.localizedDescription)
            }
        }
    }
}

#Preview {
    DashboardScreen()
}
