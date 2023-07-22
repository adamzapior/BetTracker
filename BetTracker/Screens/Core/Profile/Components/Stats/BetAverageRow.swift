import SwiftUI

struct BetAverageRow: View {

    let labelText: String

    let icon: String
    let icon2: String
    let icon3: String

    let text1: String
    let text2: String
    let text3: String

    let betsPendingText: String
    let betsPendingText2: String
    let betsPendingText3: String

    let currency: String

    var body: some View {
        VStack {
            Text(labelText)
                .font(.subheadline)
                .foregroundColor(Color.ui.onPrimaryContainer)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Image(systemName: "\(icon)")
                            .font(.title2)
                            .foregroundColor(Color.ui.scheme)
                            .padding(.bottom, 3)
                            .frame(width: 32, height: 32)
                        Text("\(text1)")
                            .font(.caption2)
                            .foregroundColor(Color.ui.onPrimaryContainer)
                            .padding(.bottom, 3)
                            .frame(minWidth: 100, alignment: .leading)

                        Text("\(betsPendingText) \(currency)")
                            .font(.headline)
                            .foregroundColor(Color.ui.secondary)
                            .padding(.bottom, 6)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 12)
                    }
                }
                .padding(.vertical, 3)

                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Image(systemName: "\(icon2)")
                            .font(.title2)
                            .foregroundColor(Color.red)
                            .padding(.bottom, 3)
                            .frame(width: 32, height: 32)
                        Text("\(text2)")
                            .font(.caption2)
                            .foregroundColor(Color.ui.onPrimaryContainer)
                            .padding(.bottom, 3)
                            .frame(minWidth: 100, alignment: .leading)

                        Text("\(betsPendingText2) \(currency)")
                            .font(.headline)
                            .foregroundColor(Color.ui.secondary)
                            .padding(.bottom, 6)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 12)
                    }
                }
                .padding(.vertical, 3)

                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Image(systemName: "\(icon3)")
                            .font(.title2)
                            .foregroundColor(Color.orange.opacity(0.7))
                            .padding(.bottom, 3)
                            .frame(width: 32, height: 32)
                        Text("\(text3)")
                            .font(.caption2)
                            .foregroundColor(Color.ui.onPrimaryContainer)
                            .padding(.bottom, 3)
                            .frame(minWidth: 100, alignment: .leading)

                        Text("\(betsPendingText3) \(currency)")
                            .font(.headline)
                            .foregroundColor(Color.ui.secondary)
                            .padding(.bottom, 6)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 12)
                    }
                }
                .padding(.vertical, 3)
            }

            .padding(.leading, 12)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.ui.onPrimary)
        }
        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 3, y: 2)
    }
}
