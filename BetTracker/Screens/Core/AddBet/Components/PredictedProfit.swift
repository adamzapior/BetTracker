import SwiftUI

struct PredictedProfit: View {

    let labelText: String
    var profitText: String
    var currency: String

    var body: some View {
        ZStack {
            HStack {
                Image(systemName: "arrow.up.forward")
                    .font(.title2)
                    .foregroundColor(Color.ui.scheme)
                    .padding(.trailing, 12)
                    .frame(width: 36, height: 36)

                Text(labelText)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color.ui.secondary)
                    .padding(.vertical, 16)
                Spacer()
                Spacer()
            }
            .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(
                        Color.ui.onPrimary
                    )
            }
            ZStack {
                Text(profitText + " " + currency)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 18)
            }

            .frame(maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct PredictedProfit_Previews: PreviewProvider {

    static var previews: some View {
        PredictedProfit(labelText: "Your predicted profit:", profitText: "214", currency: "PLN")
    }
}
