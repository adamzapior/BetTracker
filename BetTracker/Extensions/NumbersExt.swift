import Foundation

extension Double {
    func doubleWith2Digits() -> Double {
        Double(String(format: "%.2f", self)) ?? self
    }
}

extension Double {
    func formattedWith2Digits() -> String {
        String(format: "%.2f", self)
    }
}
