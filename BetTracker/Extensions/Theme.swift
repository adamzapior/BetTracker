import Foundation
import SwiftUI

struct ColorPalette {
    var background = Color("Background")
    var imageGradinetColor = Color("ImageGradinetColor")
    var onBackground = Color("OnBackground")
    var onError = Color("OnError")
    var primaryContainer = Color("primaryContainer")
    var onPrimary = Color("OnPrimary")
    var onPrimaryContainer = Color("OnPrimaryContainer")
    var secondary = Color("Secondary")
    var scheme = Color("Scheme")
    var shadow = Color("Shadow")
    var wonBetColor = Color("WonBetColor")
    var lostBetColor = Color("LostBetColor")
    var pendingBetColor = Color("PendingBetColor")
}

extension Color {
    static let ui = ColorPalette()
}
