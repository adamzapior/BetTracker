import SwiftUI

struct BetslipCellView: View {
    let bet: BetslipModel
    let currency: String
    
    private var statusColor: Color {
        bet.isWon.map { isWon in
            isWon ? Color.ui.wonBetColor : Color.ui.lostBetColor
        } ?? Color.ui.pendingBetColor
    }
    
    var body: some View {
        VStack(spacing: 6) {
            betNameSection
            Divider()
            oddsSection
            amountSection
        }
        .frame(minHeight: 80)
        .padding(.vertical, 12)
        .padding(.horizontal, 6)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.ui.onPrimary)
        )
        .standardShadow()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
    }
    
    // MARK: - UI Sections

    private var betNameSection: some View {
        Text(bet.name)
            .font(.body)
            .bold()
            .foregroundColor(Color.ui.scheme)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 6)
    }
    
    private var oddsSection: some View {
        HStack {
            Spacer()
            Text(bet.odds.doubleValue.formattedWith2Digits())
                .bold()
                .font(.callout)
                .foregroundColor(Color.ui.secondary)
                .padding(.horizontal, 12)
//                .padding(.vertical, 4)
//                .background(
//                    Capsule()
//                        .fill(Color.ui.onPrimary)
//                )
        }
        .padding(.top, 6)
        .padding(.horizontal, 24)
    }
    
    private var amountSection: some View {
        HStack {
            Spacer()
            Text(amountText)
                .bold()
                .font(.callout)
                .foregroundColor(Color.ui.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(statusColor)
                )
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - UI Elements
    
    private var amountText: String {
        let amount = bet.isWon != nil ? bet.score?.doubleValue : bet.amount.doubleValue
        return "\(amount?.formattedWith2Digits() ?? "") \(currency.uppercased())"
    }
    
    private var accessibilityLabel: String {
        "Betslip: \(bet.name)"
    }
    
    private var accessibilityHint: String {
        let status = bet.isWon.map { $0 ? "Won" : "Lost" } ?? "Pending"
        return "Odds: \(bet.odds.doubleValue.formattedWith2Digits()). Amount: \(amountText). Status: \(status)"
    }
}

// MARK: - Preview

struct BetslipCell_Previews: PreviewProvider {
    static var previews: some View {
        let sampleBet = BetslipModel(
            id: 1,
            date: Date(),
            name: "Sample Bet",
            amount: NSDecimalNumber(string: "100.00"),
            odds: NSDecimalNumber(string: "2.50"),
            category: .basketball,  // Przykład, upewnij się, że masz poprawny model Category
            tax: NSDecimalNumber(string: "5.00"),
            profit: NSDecimalNumber(string: "200.00"),
            note: "Great match!",
            isWon: true, // Możesz zmieniać wartości, aby przetestować różne stany
            betNotificationID: "123",
            score: NSDecimalNumber(string: "300.00")
        )
        
        return BetslipCellView(bet: sampleBet, currency: "USD")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
