import SwiftUI

struct PredictedProfit: View {

    let text: String
    let currency: String

    var body: some View {
        ZStack {
            HStack {
                HStack {
                    Text("Predicted profit")
                        .foregroundColor(Color.ui.secondary)
                        .font(.body)
                        .padding(.leading, 12)
                    Image(
                        systemName: "arrowtriangle.forward.fill"
                    )
                    .foregroundColor(Color.ui.scheme)
                    Spacer()
                    Text("\(text) \(currency)")
                        .bold()
                        .foregroundColor(Color.ui.scheme)
                        .padding(.horizontal, 12)
                }
                .padding(.vertical, 12)
            }
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(
                        Color.ui.background
                    )
            }
            .frame(maxWidth: .infinity)
        }
        .background {
            RoundedRectangle(cornerRadius: 15)
                .stroke(style: StrokeStyle(lineWidth: 1))
                .foregroundColor(
                    Color.ui.scheme
                )
        }
        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 3, y: 2)
    }
}
