//
//  Injected.swift
//  BetTracker
//
//  Created by Adam Zapiór on 16/09/2024.
//

import Foundation

@propertyWrapper
public struct Injected<T> {

    private let keyPath: KeyPath<DependencyInjection, T>
    
    public var wrappedValue: T {
        DependencyInjection.assembly[keyPath: keyPath]
    }
    
    init(_ keyPath: KeyPath<DependencyInjection, T>) {
        self.keyPath = keyPath
    }
}
