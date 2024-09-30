//
//  ArtistDetailScreen.swift
//  Artifan-POC
//
//  Created by Victor Castro on 29/09/24.
//

import SwiftUI
import Kingfisher

struct ArtistDetailScreen: View {
    
    let gridItem: AFGridItem
    
    var body: some View {
        VStack {
            KFImage(URL(string: gridItem.image))
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text(gridItem.title)
                .font(.largeTitle)
                .padding()
            
            Spacer()
        }
        .navigationTitle(gridItem.title)
        .padding()
    }
}


#Preview {
    ArtistDetailScreen(gridItem: AFGridItem(id: "1", title: "Titulo", image: "https://artifan-dev.s3.sa-east-1.amazonaws.com/large_k0_c1f85d1c5f.jpg", height: 200))
}
