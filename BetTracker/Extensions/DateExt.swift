import Foundation

extension Date {
    func formatSelectedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/yyyy"
        return dateFormatter.string(from: self)
    }
}

