//
//  NavigationCoordinator.swift
//  NavigationCoordinator
//
//  Created by Alex Nagy on 13.02.2024.
//

import SwiftUI

@MainActor
struct NavigationCoordinator<Content: View>: View {
    
    @ViewBuilder var content: () -> Content
    
    /// Container view for coordinator navigation
    /// - Parameter content: the content view
    init(content: @escaping () -> Content) {
        self.content = content
    }
    
    @Environment(\.navigation) var navigation
    @State private var isPresented = false
    @State private var navigationStep = NavigationStep(push: .none)
    @State private var destinationIndex = -1
    @State private var dismissedDestination: Destination? = nil
    
    var body: some View {
        content()
            .navigation(navigationStep.type, isPresented: $isPresented, onDismiss: {
                navigation.dismissedDestination = dismissedDestination
                if navigationStep.type == .sheet {
                    navigation.removeSwipedSheet()
                }
            }, destination: {
                if destinationIndex != -1, destinationIndex < navigation.stack.count - 1 {
                    navigation.stack[destinationIndex + 1].destination
                        .navigationBarBackButtonHidden()
                }
            })
            .onReceive(navigation.$isPresented) { isPresented in
                if destinationIndex != -1, destinationIndex < isPresented.count {
                    self.isPresented = isPresented[destinationIndex]
                }
            }
            .onChange(of: isPresented) { _, newValue in
                if newValue {
                    guard destinationIndex == -1 || destinationIndex >= navigation.stack.count else { return }
                    dismissedDestination = navigation.stack[destinationIndex + 1].destination
                }
            }
            .onReceive(navigation.$stack) { stack in
                if destinationIndex != -1, destinationIndex < stack.count - 1 {
                    self.navigationStep = stack[destinationIndex + 1]
                }
            }
            .onFirstAppear {
                destinationIndex = navigation.stack.count - 1
                navigation.destinationIndex = destinationIndex
            }
    }
}
