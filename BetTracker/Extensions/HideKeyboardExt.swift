//
//  HideKeyboardExt.swift
//  BetTracker
//
//  Created by Adam Zapiór on 05/05/2023.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
