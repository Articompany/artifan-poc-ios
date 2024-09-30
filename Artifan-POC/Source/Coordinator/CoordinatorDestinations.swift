//
//  Destination+Extension.swift
//  Artifan
//
//  Created by Victor Castro on 16/05/24.
//

import SwiftUI

extension Destination: View {
    
    static let splash = Destination()
    static let dashboard = Destination()
//    static let login = Destination()
//    static let signUp = Destination()
//    static let privateZone = Destination()
//    static let search = Destination()
//    static let profile = Destination()
//    static let show = Destination()
    
    var body: some View {
        switch self {
            
        case .splash:
            SplashScreen()
            
        case .dashboard:
            DashboardScreen()
            
//        case .login:
//            LoginScreen()
//                .destination(navigationBarBackButtonHidden: true)
//            
//        case .signUp:
//            SignUpScreen()
//                .destination(navigationBarBackButtonHidden: true)
//            
//        case .privateZone:
//            PrivateZone(store: Store(initialState: DashboardStore.State(favoriteShows: [], userSession: UserSessionStore.State())) { DashboardStore() })
//                .destination(navigationBarBackButtonHidden: true)
//            
//        case .search:
//            SearchScreen()
//                .destination()
//            
//        case .profile:
//            ProfileScreen()
//                .destination(navigationBarBackButtonHidden: true)
//            
//        case .show:
//            ShowScreen()
//                .destination()
            
        default:
            EmptyView()
                .destination()
        }
    }
}
