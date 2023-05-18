import SwiftUI

struct BalanceRow: View {

    let cellTitle: String
    let valueText: String
    let font: Font

    let currency: String

    init(cellTitle: String, valueText: String, font: Font = .headline, currency: String) {
        self.cellTitle = cellTitle
        self.valueText = valueText
        self.font = font
        self.currency = currency
    }
    
    var body: some View {
        VStack {
            Text("\(cellTitle)")
                .font(.subheadline)
                .foregroundColor(Color.ui.onPrimaryContainer)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(alignment: .center) {
               

                Text("\(valueText) \(currency)")
                    .font(font)
                    .foregroundColor(Color.ui.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 6)
            }
            .padding(.vertical, 3)
            .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.ui.onPrimary)
        }
        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 3, y: 2)
    }
}
