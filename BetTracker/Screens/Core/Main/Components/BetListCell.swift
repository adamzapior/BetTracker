import SwiftUI

struct BetListCell: View {
    let bet: BetModel
    let currency: String

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text(bet.team1)
                    .font(.body)
                    .bold()
                    .foregroundColor(Color.ui.secondary)

                Spacer()
                Text("\(bet.amount) \(currency.uppercased())")
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
            }
            .padding(.vertical, 3)
            .padding(.horizontal, 24)

            HStack {
                Text(bet.team2)
                    .font(.body)
                    .bold()
                    .foregroundColor(Color.ui.secondary)

                Spacer()
                Text("\((bet.odds).stringValue)")
                    .bold()
                    .font(.subheadline)
                    .foregroundColor(Color.ui.secondary)
                    .padding(.vertical, -8)
//                    .background {
//                        RoundedRectangle(cornerRadius: 25)
//                            .padding(.horizontal, 24)
//                            .padding(.vertical, -10)
//                    }
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
