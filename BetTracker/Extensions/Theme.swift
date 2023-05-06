//
//  Theme.swift
//  BetTrackerUI
//
//  Created by Adam Zapiór on 24/02/2023.
//

import Foundation
import SwiftUI

struct ColorPalette {
    var background = Color("Background")
    var error = Color("Primary")
    var errorContainer = Color("ErrorContainer")
    var imageGradinetColor = Color("ImageGradinetColor")
    var onBackground = Color("OnBackground")
    var onError = Color("OnError")
    var onErrorContainer = Color("OnErrorContainer")
    var primaryContainer = Color("primaryContainer")
    var onPrimary = Color("OnPrimary")
    var onPrimaryContainer = Color("OnPrimaryContainer")
    var secondary = Color("Secondary")
    var scheme = Color("Scheme")
}

extension Color {
    static let ui = ColorPalette()
}
