//
//  SplashScreen.swift
//  Artifan-POC
//
//  Created by Victor Castro on 29/09/24.
//

import SwiftUI

struct SplashScreen: View {
    
    @State var widthLogo: Double = 220
    @EnvironmentObject private var coordinator: CoordinatorManager
    
    var body: some View {
        ZStack {
            VStack {
                Image("Artifan")
                    .resizable()
                    .scaledToFit()
                    .frame(width: widthLogo)
                    .animation(.easeInOut(duration: 0.4), value: widthLogo)
            }
            
            LottieComponent(name: .confetti, loopMode: .playOnce) {}
        }
        .task {
            await animatationToHideLogo()
            
            if !isPreview {
                await checkSession()
            }
        }
    }
    
    private func checkSession() async {
        coordinator.root = .dashboard
    }
    
    private func animatationToHideLogo() async {
        try? await Task.sleep(for: .seconds(2.7))
        widthLogo = 0
        try? await Task.sleep(for: .seconds(0.5))
    }
}

#Preview {
    SplashScreen()
}
