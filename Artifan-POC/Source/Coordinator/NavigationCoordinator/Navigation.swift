//
//  NavigationProxy.swift
//  NavigationCoordinator
//
//  Created by Alex Nagy on 13.02.2024.
//

import SwiftUI
import Combine

@MainActor
class Navigation: ObservableObject {
    
    @Published var stack: [NavigationStep] = []
    @Published var isPresented: [Bool] = []
    @Published var destinationIndex: Int = -1
    
    @Published var isPopping = false
    
    @Published var dismissedDestination: Destination? = nil
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(root: Destination? = nil) {
        stack = [.init(push: root)]
    }
    
    // MARK: - actions
    
    /// Pushes a view onto the coordinator navigation stack
    /// - Parameters:
    ///   - destination: destination view
    ///   - type: the type of navigation; default is `.link`
    ///   - onComplete: callback trigerred when the navigation finished
    ///   - onDismiss: callback trigerred when the `destination` is dismissed
    func push(_ destination: Destination, type: NavigationType = .link, onComplete: @escaping (() -> Void), onDismiss: @escaping (() -> Void)) {
        present(destination, type: type, onComplete: onComplete, onDismiss: onDismiss)
    }
    
    /// Pushes a view onto the coordinator navigation stack
    /// - Parameters:
    ///   - destination: destination view
    ///   - type: the type of navigation; default is `.link`
    ///   - onComplete: callback trigerred when the navigation finished
    func push(_ destination: Destination, type: NavigationType = .link, onComplete: @escaping (() -> Void)) {
        present(destination, type: type, onComplete: onComplete, onDismiss: nil)
    }
    
    /// Pushes a view onto the coordinator navigation stack
    /// - Parameters:
    ///   - destination: destination view
    ///   - type: the type of navigation; default is `.link`
    ///   - onDismiss: callback trigerred when the `destination` is dismissed
    func push(_ destination: Destination, type: NavigationType = .link, onDismiss: @escaping (() -> Void)) {
        present(destination, type: type, onComplete: nil, onDismiss: onDismiss)
    }
    
    /// Pushes a view onto the coordinator navigation stack
    /// - Parameters:
    ///   - destination: destination view
    ///   - type: the type of navigation; default is `.link`
    func push(_ destination: Destination, type: NavigationType = .link) {
        present(destination, type: type, onComplete: nil, onDismiss: nil)
    }
    
    /// Pops the last n views from the coordinator navigation stack
    /// - Parameters:
    ///   - last: the number of views to be popped; defaults to 1
    ///   - oneByOne: should the pop dismiss the destinations one by one, defaults to `false`
    ///   - onComplete: callback trigerred when the navigation finished
    func pop(last: Int = 1, oneByOne: Bool = false, onComplete: (() -> Void)? = nil) {
        guard last > 0 else { return }
        let last = min(last, isPresented.count)
        
        if last == 1 {
            popTheLast(onComplete: onComplete)
        } else {
            if oneByOne {
                popTheLast(last, onComplete: onComplete)
            } else {
                popToFirstLink(last: last, onComplete: onComplete)
            }
        }
    }
    
    /// Pops to a specific destination from the coordinator navigation stack
    /// - Parameters:
    ///   - destination: the destination view
    ///   - oneByOne: should the pop dismiss the destinations one by one, defaults to `false`
    ///   - onComplete: callback trigerred when the navigation finished
    func pop(to destination: Destination, oneByOne: Bool = false, onComplete: (() -> Void)? = nil) {
        let index = stack.firstIndex { navigationStep in
            navigationStep.destination == destination
        }
        guard let index = index else { return }
        let last = stack.count - 1 - index
        guard last > 0 else { return }
        pop(last: last, oneByOne: oneByOne, onComplete: onComplete)
    }
    
    /// Pops to root on a coordinator navigation stack
    /// - Parameters:
    ///   - type: the type of root
    ///   - oneByOne: should the pop dismiss the destinations one by one, defaults to `false`
    ///   - onComplete: callback trigerred when the navigation finished
    func popToRoot(_ type: RootType = .base, oneByOne: Bool = false, onComplete: (() -> Void)? = nil) {
        switch type {
        case .base:
            pop(last: destinationIndex, oneByOne: oneByOne, onComplete: onComplete)
        case .lastModal:
            let index = stack.lastIndex { navigationStep in
                navigationStep.type == .sheet || navigationStep.type == .fullScreenCover
            }
            guard let index = index else { return }
            let destination = stack[index].destination
            guard let destination else { return }
            pop(to: destination, oneByOne: oneByOne, onComplete: onComplete)
        case .firstModal:
            let index = stack.firstIndex { navigationStep in
                navigationStep.type == .sheet || navigationStep.type == .fullScreenCover
            }
            guard let index = index else { return }
            let destination = stack[index].destination
            guard let destination else { return }
            pop(to: destination, oneByOne: oneByOne, onComplete: onComplete)
        case .modal(let count):
            var modalCount = 0
            stack.forEach { navigationStep in
                if navigationStep.type == .sheet || navigationStep.type == .fullScreenCover {
                    modalCount += 1
                }
            }
            guard count >= 1, count <= modalCount else { return }
            
            var indexCount = 0
            var index = -1
            for i in 0..<stack.count {
                let navigationStep = stack[i]
                if navigationStep.type == .sheet || navigationStep.type == .fullScreenCover {
                    indexCount += 1
                    if indexCount == count {
                        index = i
                    }
                }
            }
            if index != -1 {
                let destination = stack[index].destination
                guard let destination else { return }
                pop(to: destination, oneByOne: oneByOne, onComplete: onComplete)
            }
            
        }
    }
    
    /// Replaces the current view with a new destination on a coordinator navigation stack
    /// - Parameter destination: the new view
    /// - Parameter onComplete: callback trigerred when the replacement finished
    func replace(with destination: Destination, onComplete: (() -> Void)? = nil) {
        stack[destinationIndex].destination = destination
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001, execute: {
            onComplete?()
        })
    }
    
    // MARK: - async/await
    
    /// Pushes a view onto the coordinator navigation stack
    /// - Parameters:
    ///   - type: the type of navigation; default is `.link
    ///   - destination: destination view
    func push(_ destination: Destination, type: NavigationType = .link, onDismiss: (() -> Void)? = nil) async {
        await withCheckedContinuation { continuation in
            push(destination, type: type) {
                continuation.resume()
            } onDismiss: {
                onDismiss?()
            }
        }
    }
    
    /// Pops the last n views from the coordinator navigation stack
    /// - Parameters:
    ///   - last: the number of views to be popped; defaults to 1
    ///   - oneByOne: should the pop dismiss the destinations one by one, defaults to `false`
    func pop(last: Int = 1, oneByOne: Bool = false) async {
        await withCheckedContinuation { continuation in
            pop(last: last, oneByOne: oneByOne) {
                continuation.resume()
            }
        }
    }
    
    /// Pops to a specific destination from the coordinator navigation stack
    /// - Parameters:
    ///   - destination: the destination view
    ///   - oneByOne: should the pop dismiss the destinations one by one, defaults to `false`
    func pop(to destination: Destination, oneByOne: Bool = false) async {
        await withCheckedContinuation { continuation in
            pop(to: destination, oneByOne: oneByOne) {
                continuation.resume()
            }
        }
    }
    
    /// Pops to root on a coordinator navigation stack
    /// - Parameters:
    ///   - type: the type of root
    ///   - oneByOne: should the pop dismiss the destinations one by one, defaults to `false`
    func popToRoot(_ type: RootType = .base, oneByOne: Bool = false) async {
        await withCheckedContinuation { continuation in
            popToRoot(type, oneByOne: oneByOne) {
                continuation.resume()
            }
        }
    }
    
    /// Replaces the current view with a new destination on a coordinator navigation stack
    /// - Parameter destination: the new view
    func replace(with destination: Destination) async {
        await withCheckedContinuation { continuation in
            replace(with: destination) {
                continuation.resume()
            }
        }
    }
    
    // MARK: - Internal
    
    /// Removes a swiped down sheet from the stack
    func removeSwipedSheet() {
        let lastSheetIndex = stack.lastIndex { naviagtionStep in
            naviagtionStep.type == .sheet
        }
        guard let lastSheetIndex else { return }
        let last = stack.count - lastSheetIndex
        remove(last, didSwipeSheet: true)
    }
    
    // MARK: - Private
    
    /// Pushes a view onto the coordinator navigation stack
    /// - Parameters:
    ///   - destination: destination view
    ///   - type: the type of navigation; default is `.link`
    ///   - onComplete: callback trigerred when the navigation finished
    ///   - onDismiss: callback trigerred when the `destination` is dismissed
    private func present(_ destination: Destination, type: NavigationType, onComplete: (() -> Void)?, onDismiss: (() -> Void)?) {
        switch type {
        case .link:
            stack.append(.init(push: destination))
        case .sheet:
            stack.append(.init(present: destination))
        case .fullScreenCover:
#if !os(macOS)
            stack.append(.init(cover: destination))
#else
            stack.append(.init(present: destination))
#endif
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001, execute: {
            self.isPresented.append(true)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001 + 0.6, execute: {
            onComplete?()
        })
        
        var cancellable: AnyCancellable?
        cancellable = self.$dismissedDestination.receive(on: DispatchQueue.main).sink { dismissedDestination in
            if destination == dismissedDestination {
                self.dismissedDestination = nil
                cancellable?.cancel()
                onDismiss?()
            }
        }
        cancellable?.store(in: &cancellables)
    }
    
    /// Pops the last destinations
    /// - Parameter last: destinations count
    private func popLast(_ last: Int) {
        isPopping = true
        isPresented[destinationIndex - 1] = false
        
        let lastSheetIndex = stack.lastIndex { naviagtionStep in
            naviagtionStep.type == .sheet
        }
        
        if let lastSheetIndex = lastSheetIndex {
            if isPopping {
                remove(1)
                isPopping = false
            } else {
                let last = stack.count - lastSheetIndex
                remove(last)
            }
        } else {
            remove(1)
        }
    }
    
    /// Removes the last destination(s)
    /// - Parameter last: count of destinations
    private func remove(_ last: Int, didSwipeSheet: Bool = false) {
        if didSwipeSheet {
            stack.removeLast(last)
            isPresented.removeLast(last)
            destinationIndex -= last
        } else {
            guard stack.last?.type != .sheet else { return }
            stack.removeLast(last)
            isPresented.removeLast(last)
            destinationIndex -= last
        }
    }
    
    /// Pops the last n views from the coordinator navigation stack
    /// - Parameters:
    ///   - last: the number of views to be popped; defaults to 1
    ///   - onComplete: callback trigerred when the navigation finished
    private func popTheLast(_ last: Int = 1, onComplete: (() -> Void)? = nil) {
        for i in 0..<last {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001 + 0.6 * Double(i), execute: {
                self.popLast(last)
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001 + 0.6 * Double(last - 1), execute: {
            onComplete?()
        })
    }
    
    /// Pops to the nearest link destination from the coordinator navigation stack
    /// - Parameters:
    ///   - last: the number of views to be popped
    ///   - onComplete: callback trigerred when the navigation finished
    private func popToFirstLink(last: Int, onComplete: (() -> Void)? = nil) {
        let currentNavigationStepIndex = stack.count - 1
        var firstLinkIndex = -1
        var searching = true
        
        for i in 0..<last {
            if searching {
                let previousNavigationStepIndex = stack.count - i - 1
                if stack[previousNavigationStepIndex].type == .link {
                    firstLinkIndex = previousNavigationStepIndex
                } else {
                    searching = false
                }
            }
        }
        
        if firstLinkIndex == currentNavigationStepIndex || firstLinkIndex == -1 {
            pop {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.001 + 0.6, execute: {
                    self.pop(last: last - 1, onComplete: onComplete)
                })
            }
        } else {
            stack[firstLinkIndex].destination = stack[currentNavigationStepIndex].destination
            
            var removableIndexes: [Int] = []
            for j in firstLinkIndex..<currentNavigationStepIndex {
                removableIndexes.append(j + 1)
            }
            
            destinationIndex -= removableIndexes.count
            
            stack.remove(atOffsets: IndexSet(removableIndexes))
            
            var removableIsPresentedIndexes: [Int] = []
            removableIndexes.forEach { index in
                removableIsPresentedIndexes.append(index - 1)
            }
            isPresented.remove(atOffsets: IndexSet(removableIsPresentedIndexes))
            pop {
                let remaining = last - removableIndexes.count - 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.001 + 0.6, execute: {
                    if remaining > 0 {
                        self.pop(last: remaining, onComplete: onComplete)
                    } else {
                        onComplete?()
                    }
                })
            }
        }
    }
    
}
