//
//  ArtistDetailScreen.swift
//  Artifan-POC
//
//  Created by Victor Castro on 29/09/24.
//

import SwiftUI
import Kingfisher

struct ArtistDetailScreen: View {
    @State private var showActionSheet = false
    
    let gridItem: AFGridItem
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Info")
                    Text("Fotos")
                }.padding()
                
                VStack {
                    KFImage(URL(string: gridItem.image))
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .clipShape(.rect(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 150,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 0
                        ))
                    
                    Text(gridItem.title)
                        .font(.title)
                        .padding(.vertical)
                    
                    Spacer()
                }
            }
            
            Button(action: {
                showActionSheet = true
            }) {
                Text("Contactar")
                    .font(.title3)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .ignoresSafeArea()
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("Elige una opción"),
                buttons: [
                    .default(Text("Llamar a 906151515"), action: {
                        // Acción para llamar al número
                        if let url = URL(string: "tel://906151515") {
                            UIApplication.shared.open(url)
                        }
                    }),
                    .default(Text("Contactar por Messenger"), action: {
                        // Acción para abrir Messenger
                        if let url = URL(string: "https://m.me/username") {
                            UIApplication.shared.open(url)
                        }
                    }),
                    .default(Text("Ingresar a Instagram"), action: {
                        // Acción para abrir Instagram
                        if let url = URL(string: "https://instagram.com") {
                            UIApplication.shared.open(url)
                        }
                    }),
                    .cancel()
                ]
            )
        }
    }
}


#Preview {
    ArtistDetailScreen(gridItem: AFGridItem(id: "1", title: "Titulo", image: "https://artifan-dev.s3.sa-east-1.amazonaws.com/large_k0_c1f85d1c5f.jpg", height: 200))
}
