//
//  ShowView.swift
//  Artifan-POC
//
//  Created by Victor Castro on 16/08/24.
//

import SwiftUI
import Kingfisher

struct ShowView: View {
    let show: ShowModel
    
    var body: some View {
        VStack {
            if let bannerURL = show.banner?.url {
                KFImage(URL(string: bannerURL))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 150)
                    .cornerRadius(8)
            }
            Text(show.title)
            HStack {
                if let socialMedia = show.socialMedia {
                    ForEach(socialMedia) { social in
                        Text(social.name)
                    }
                }
            }
        }
    }
}

#Preview {
    ShowView(show: ShowModel(id: 1, title: "Titulo", description: "", city: "Arequipa", banner: nil, category: nil, photos: [], whatsapp: 961509457, socialMedia: nil))
}
