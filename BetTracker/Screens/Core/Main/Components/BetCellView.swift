import SwiftUI

struct BetCellView: View {
    @Environment(\.colorScheme) var colorScheme

    let bet: BetModel
    let currency: String
    
    private var statusColor: Color {
        bet.isWon.map { isWon in
            isWon ? Color.ui.wonBetColor : Color.ui.lostBetColor
        } ?? Color.ui.pendingBetColor
    }
    
    var body: some View {
        VStack(spacing: 6) {
            teamsSection
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
    
    // MARK: UI Sections
    
    private var teamsSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                TeamNameView(name: bet.team1, isSelected: bet.selectedTeam == .team1)
                TeamNameView(name: bet.team2, isSelected: bet.selectedTeam == .team2)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 6)
        }
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
    
    // MARK: UI Elements
    
    private var amountText: String {
        let amount = bet.isWon != nil ? bet.score?.doubleValue : bet.amount.doubleValue
        return "\(amount?.formattedWith2Digits() ?? "") \(currency.uppercased())"
    }
    
    private var accessibilityLabel: String {
        "Bet: \(bet.team1) vs \(bet.team2)"
    }
    
    private var accessibilityHint: String {
        let status = bet.isWon.map { $0 ? "Won" : "Lost" } ?? "Pending"
        return "Odds: \(bet.odds.doubleValue.formattedWith2Digits()). Amount: \(amountText). Status: \(status)"
    }
}

// MARK: Extracted local views

fileprivate struct TeamNameView: View {
    let name: String
    let isSelected: Bool
    
    var body: some View {
        Text(name)
            .font(.body)
            .bold()
            .foregroundColor(isSelected ? Color.ui.scheme : Color.ui.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}


extension Optional where Wrapped == Bool {
    func map<T>(ifTrue: () -> T, ifFalse: () -> T) -> T? {
        switch self {
        case .some(true): return ifTrue()
        case .some(false): return ifFalse()
        case .none: return nil
        }
    }
}

struct BetCellView_Previews: PreviewProvider {
    static var previews: some View {
        let placeholderBet = BetModel(
            id: 1,
            date: Date(),
            team1: "Team A",
            team2: "Team B",
            selectedTeam: .team1,
            league: "Premier League",
            amount: NSDecimalNumber(string: "100.00"),
            odds: NSDecimalNumber(string: "2.5"),
            category: .football,
            tax: NSDecimalNumber(string: "10"),
            profit: NSDecimalNumber(string: "150.00"),
            note: "This is a test bet.",
            isWon: nil,
            betNotificationID: nil,
            score: NSDecimalNumber(string: "0.00")
        )

        BetCellView(bet: placeholderBet, currency: "PLN")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

extension Bool? {
    func fold<T>(
        ifTrue: () -> T,
        ifFalse: () -> T,
        ifNil: () -> T
    ) -> T {
        if self == true {
            return ifTrue()
        } else if self == false {
            return ifFalse()
        } else {
            return ifNil()
        }
    }
}
