import SwiftUI

struct PredictedProfitRow: View {

    let labelText: String
    
    var profitText: String
    
    var currency: String

    var body: some View {
            ZStack {
                VStack(spacing: 0) {
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
                    HStack {
                        Text(profitText + " " + currency)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.top, -16)
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(
                            Color.ui.onPrimary
                        )
                }
            }
            .standardShadow()     
    }
}
