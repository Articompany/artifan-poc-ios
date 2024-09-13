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
                    .scaledToFit()
                    // .frame(height: 200)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 150)
                    .cornerRadius(8)
            }
            VStack(alignment: .leading, spacing: 15) {
                Text(show.title)
                    .font(.title)
                HStack {
                    HStack(spacing: 10) {
                        if let socialMedia = show.socialMedia {
                            ForEach(socialMedia) { social in
                                Text(social.name)
                            }
                        }
                    }
                    Spacer()
                    Text(show.city)
                        .font(.caption2)
                }
                Text(show.description)
                    .font(.footnote)
                    .padding(.top, 30)
                
                if let photos = show.photos {
                    HStack {
                        ForEach(photos) { photo in
                            KFImage(URL(string: photo.url))
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                        }
                    }
                }
                Spacer()
            }.padding()
        }.ignoresSafeArea()
    }
}

#Preview {
    ShowView(show: ShowModel(id: 1, title: "Titulo", description: "Description of show is really long, and use many sentences ", city: "Arequipa", banner: ShowModel.BannerModel(id: 1, url: "https://artifan-dev.s3.sa-east-1.amazonaws.com/muz2_77c68d55ee.jpg"), category: nil, photos: [], whatsapp: 961509457, socialMedia: nil))
}
