//
//  CustomShadowExt.swift
//  BetTracker
//
//  Created by Adam Zapiór on 31/08/2023.
//

import Foundation
import SwiftUI

extension View {
    func standardShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.14), radius: 5, x: 5, y: 5)
    }
}


extension View {
    func standardShadow2() -> some View {
        self.shadow(color: Color.black.opacity(0.10), radius: 5, x: 5, y: 5)
    }
}
