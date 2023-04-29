import SwiftUI

struct BetDetailsScreen: View {
    @Environment(\.dismiss)
    var dismiss

    let bet: BetModel

    @StateObject
    var vm = BetDetailsVM()

    var body: some View {
        VStack {
            BetDetailHeader {
                vm.isShowingAlert = true
            }
            .alert("Are ju szur", isPresented: $vm.isShowingAlert) {
                Button("Yes") {
                    vm.deleteBet(bet: bet)
                    dismiss()
                }
                Button("No", role: .cancel) { }
            }

            VStack(spacing: 5) {
                Text(bet.team1)
                    .foregroundColor(Color.ui.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title3)
                    .bold()
                    .padding(.vertical, 16)
                Text("vs.")
                    .font(.body)
                Text(bet.team2)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title3)
                    .bold()
                    .padding(.vertical, 16)
            }
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(
                        Color.ui.onPrimary
                    )
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 12)

            VStack(spacing: 5) {
                Group {
                    if bet.league != "" {
                        BetDetail(
                            category: "Category",
                            text: bet
                                .league!
                        ) // TODO: W AddBetVM league przyjmuje pustego stringa jeslnie nie ma zadnej wartosci
                    }

                    if bet.league != "" {
                        BetDetail(
                            category: "League:",
                            text: bet
                                .league!
                        ) // TODO: W AddBetVM league przyjmuje pustego stringa jeslnie nie ma zadnej wartosci
                    }

                    BetDetail(
                        category: "Date:",
                        text: (bet.date).ISO8601Format(.iso8601Date(timeZone: .current))
                    )
                    BetDetail(category: "Amount:", text: "\(bet.amount) \(vm.currency)")
                    BetDetail(category: "Odds:", text: "\(bet.odds.databaseValue)")
                    BetDetail(category: "Tax:", text: "\(bet.tax.databaseValue)%")
                    BetDetail(category: "Przewidywana wygrana:", text: "\(vm.betProfit(bet: bet)) \(vm.currency)")
                }
                Divider()
                    .padding(.horizontal, 16)
            }

            .background(
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(
                        Color.ui.onPrimary
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 12)
        }
        .navigationBarBackButtonHidden()
        Spacer()

        HStack {
            if bet.isWon != true {
                BetButton(text: "Win")
                    .onTapGesture {
                        BetDao.markFinished(bet: bet, isWon: true)
                        dismiss()
                    }
            }
            if bet.isWon != false {
                BetButton(text: "Przegrany")
                    .onTapGesture {
                        BetDao.markFinished(bet: bet, isWon: false)
                        dismiss()
                    }
            }
        }
        Spacer()
    }
}

struct BetInfoHistory_Previews: PreviewProvider {
    static var previews: some View {
        BetButton(text: "testowy")
    }
}
