import SwiftUI


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

struct BetCell: View {
    let bet: BetModel
    let currency: String

    var body: some View {
        VStack {

            VStack(spacing: 4) {
                Text(bet.team1)
                    .font(.body)
                    .bold()
                    .foregroundColor(
                        bet.selectedTeam == .team1
                            ? Color.ui.scheme
                            : Color.ui.secondary
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(bet.team2)
                    .font(.body)
                    .bold()
                    .foregroundColor(
                        bet.selectedTeam == .team2
                            ? Color.ui.scheme
                            : Color.ui.secondary
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 3)
            .padding(.horizontal, 24)

            HStack {
                Text("\(bet.odds.doubleValue.formattedWith2Digits())")
                    .bold()
                    .font(.subheadline)
                    .foregroundColor(Color.ui.secondary)
                    .frame(maxWidth: 100, alignment: .leading)


                Text(
                    "\(bet.amount.doubleValue.formattedWith2Digits()) \(currency.uppercased())"
                )
                .bold()
                .font(.body)
                .foregroundColor(Color.ui.secondary)
                .padding(.horizontal, 4)
                .padding(.vertical, 1)
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(
                            bet.isWon.fold(
                                ifTrue: { Color.green },
                                ifFalse: { Color.red },
                                ifNil: { Color.orange }
                            ).opacity(0.15)
                        )
                        .padding(.horizontal, -8)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.vertical, 1)
            .padding(.horizontal, 24)
        }
        .padding(.top, 12)
        .padding(.bottom, 12)
        .padding(.horizontal, 6)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(Color.ui.onPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        .standardShadow()
    }
}
