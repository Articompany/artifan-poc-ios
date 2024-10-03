//
//  DestinationLinkModifier.swift
//  NavigationCoordinator
//
//  Created by Alex Nagy on 06.07.2023.
//

import SwiftUI

struct DestinationLinkModifier<Destination: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    var onDismiss: (() -> Void)?
    @ViewBuilder var destination: () -> Destination
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            Group {
                groupContent(content)
            }
            .onChange(of: isPresented) { _, newValue in
                if !newValue {
                    onDismiss?()
                }
            }
        } else {
            Group {
                groupContent(content)
            }
            .onChange(of: isPresented) { newValue in
                if !newValue {
                    onDismiss?()
                }
            }
        }
    }
    
    @ViewBuilder
    func groupContent(_ content: Content) -> some View {
        content
            .background(
                NavigationLink(isActive: $isPresented, destination: destination, label: {
                    EmptyView()
                })
            )
    }
}

