//
//  EnvironmentValues+Extensions.swift
//  RoutersDemo
//
//  Created by Itay Amzaleg on 10/03/2024.
//

import SwiftUI

struct CurrentTabKey: EnvironmentKey {
    static var defaultValue: Binding<ContentView.Tab> = .constant(.a)
}

extension EnvironmentValues {
    var currentTab: Binding<ContentView.Tab> {
        get { self[CurrentTabKey.self] }
        set { self[CurrentTabKey.self] = newValue }
    }
    
//    
//    var presentedSheet: Binding<PresentedSheet?> {
//        get { self[PresentedSheetKey.self] }
//        set { self[PresentedSheetKey.self] = newValue }
//    }
}
