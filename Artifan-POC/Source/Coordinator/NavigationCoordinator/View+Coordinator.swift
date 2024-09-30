//
//  View+Coordinator.swift
//  NavigationCoordinator
//
//  Created by Alex Nagy on 13.02.2024.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    /// Presents a view when a binding to a Boolean value that you
    /// provide is true.
    /// - Parameters:
    ///   - type: The type of navigation.
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the sheet that you create in the modifier's.
    ///     `destination` closure.
    ///   - onDismiss: The closure to execute when dismissing the `destination`.
    ///   - destination: A closure that returns the content of the `destination`.
    func navigation<Destination: View>(_ type: NavigationType,
                                       isPresented: Binding<Bool>,
                                       onDismiss: (() -> Void)? = nil,
                                       @ViewBuilder destination: @escaping () -> Destination) -> some View {
        switch type {
        case .link:
            self.modifier(DestinationLinkModifier(isPresented: isPresented, onDismiss: onDismiss, destination: destination))
        case .sheet:
            self.sheet(isPresented: isPresented, onDismiss: onDismiss) {
                destination()
            }
        case .fullScreenCover:
#if !os(macOS)
            self.fullScreenCover(isPresented: isPresented, onDismiss: onDismiss) {
                destination()
            }
#else
            self.sheet(isPresented: isPresented, onDismiss: onDismiss) {
                destination()
            }
#endif
        }
    }
    
    @MainActor 
    @ViewBuilder
    /// Sets the view a destination
    func destination(navigationBarBackButtonHidden: Bool = false) -> some View {
        NavigationCoordinator {
            self.navigationBarBackButton(isShown: !navigationBarBackButtonHidden)
        }
        .modifier(DestinationViewModifier())
    }
}
