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
            HStack(spacing: 5) {
                VStack {
                    Button("Info") {}
                        .rotationEffect(.degrees(90))
                        .fixedSize()
                        .frame(width: 20, height: 120)
                    Button("Photos") {}
                        .rotationEffect(.degrees(90))
                        .fixedSize()
                        .frame(width: 20, height: 120)
                    Button("Contact") {}
                        .rotationEffect(.degrees(90))
                        .fixedSize()
                        .frame(width: 20, height: 120)
                    Spacer()
                }
                .padding(.top, 100)
                .frame(width: 40)
                
                VStack {
                    GeometryReader { geometry in
                        KFImage(URL(string: gridItem.image))
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: 300)
                            .clipShape(.rect(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 80,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 0
                            ))
                    }
                    .frame(height: 300)
                    
                    VStack(alignment: .leading) {
                        Text(gridItem.title)
                            .font(.title)
                            .padding(.vertical)
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer consequat erat mauris, vitae aliquam metus tincidunt ac. Cras porta ornare libero, id pharetra est suscipit eget. Mauris ultricies enim a est lobortis, vel facilisis urna vestibulum. Ut interdum urna nunc, a ultricies sapien iaculis quis. Mauris sit amet ligula purus. Vivamus non sem fringilla")
                    }.padding(.leading, 20)
                    Spacer()
                }
            }
            HStack {
                Button(action: {
                    showActionSheet = true
                }) {
                    Text("WhatsApp")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
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
            }.padding(.bottom, 20)
        }
        .ignoresSafeArea()
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("Elige una opción"),
                buttons: [
                    .default(Text("Llamar a 906151515"), action: {
                        openWhatsApp("51906151515")
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
    
    func openWhatsApp(_ phoneNumber: String) {
            // Crear la URL con el número de teléfono
            let whatsappURL = URL(string: "https://wa.me/\(phoneNumber)")!
            
            // Intentar abrir la URL con openURL
            if UIApplication.shared.canOpenURL(whatsappURL) {
                UIApplication.shared.open(whatsappURL)
            } else {
                // Si WhatsApp no está instalado o no se puede abrir
                print("No se pudo abrir WhatsApp")
            }
        }
}


#Preview {
    ArtistDetailScreen(gridItem: AFGridItem(id: "1", title: "Camilita Show infantilas", image: "https://artifan-dev.s3.sa-east-1.amazonaws.com/large_k0_c1f85d1c5f.jpg", height: 200))
}
