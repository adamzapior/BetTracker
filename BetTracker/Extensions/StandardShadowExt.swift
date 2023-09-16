import Foundation
import SwiftUI

extension View {
    func standardShadow() -> some View {
        shadow(color: Color.black.opacity(0.14), radius: 5, x: 5, y: 5)
    }
}
