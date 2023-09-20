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
            VStack(spacing: 8) {
                Text(bet.team1)
                    .lineLimit(1)
                    .font(.body)
                    .bold()
                    .foregroundColor(
                        bet.selectedTeam == .team1
                            ? Color.ui.scheme
                            : Color.ui.secondary
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(bet.team2)
                    .lineLimit(1)
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

            HStack(alignment: .center) {
                Text("\(bet.odds.doubleValue.formattedWith2Digits())")
                    .bold()
                    .font(.footnote)
                    .lineLimit(1)
                    .foregroundColor(Color.ui.secondary)
                    .frame(maxWidth: 70, alignment: .leading)

                if bet.isWon == true || bet.isWon == false {
                    Text(
                        "\(bet.score!.doubleValue.formattedWith2Digits()) \(currency.uppercased())"
                    )
                    .bold()
                    .font(.callout)
                    .foregroundColor(Color.ui.secondary)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 1)
                    .background {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(
                                bet.isWon.fold(
                                    ifTrue: { Color.ui.wonBetColor },
                                    ifFalse: { Color.ui.lostBetColor },
                                    ifNil: { Color.ui.pendingBetColor }
                                )
                            )
                            .padding(.horizontal, -8)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                } else if bet.isWon == nil {
                    Text(
                        "\(bet.amount.doubleValue.formattedWith2Digits()) \(currency.uppercased())"
                    )
                    .bold()
                    .font(.callout)
                    .foregroundColor(Color.ui.secondary)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 1)
                    .background {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(
                                bet.isWon.fold(
                                    ifTrue: { Color.ui.wonBetColor },
                                    ifFalse: { Color.ui.lostBetColor },
                                    ifNil: { Color.ui.pendingBetColor }
                                )
                            )
                            .padding(.horizontal, -8)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding(.vertical, 1)
            .padding(.horizontal, 24)
        }
        .frame(minHeight: 80)
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
