import SwiftUI

struct BetCountRow: View {

    let labelText: String

    let icon: String
    
    let icon2: String
    
    let icon3: String

    let text: String
    
    let text2: String
    
    let text3: String

    let betsPendingText: String
    
    let betsPendingText2: String
    
    let betsPendingText3: String

    var body: some View {
        VStack {
            Text(labelText)
                .font(.subheadline)
                .foregroundColor(Color.ui.onPrimaryContainer)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(alignment: .center) {
                HStack(spacing: 48) {
                    VStack {
                        HStack {
                            Image(systemName: "\(icon)")
                                .font(.title2)
                                .foregroundColor(Color.orange.opacity(0.7))
                                .padding(.bottom, 3)
                                .frame(width: 32, height: 32)
                        }
                        Text("\(text)")
                            .font(.caption2)
                            .foregroundColor(Color.ui.onPrimaryContainer)
                            .padding(.bottom, 3)
                            .frame(width: 64, height: 32)

                        Text("\(betsPendingText)")
                            .font(.headline)
                            .foregroundColor(Color.ui.secondary)
                            .padding(.bottom, 6)
                    }
                    .padding(.vertical, 3)
                    .padding(.horizontal, 12)

                    VStack {
                        HStack {
                            Image(systemName: "\(icon2)")
                                .font(.title2)
                                .foregroundColor(Color.ui.scheme)
                                .padding(.bottom, 3)
                                .frame(width: 32, height: 32)
                        }
                        Text("\(text2)")
                            .font(.caption2)
                            .foregroundColor(Color.ui.onPrimaryContainer)
                            .padding(.bottom, 3)
                            .frame(width: 64, height: 32)

                        Text("\(betsPendingText2)")
                            .font(.headline)
                            .foregroundColor(Color.ui.secondary)
                            .padding(.bottom, 6)
                    }
                    .padding(.vertical, 3)
                    .padding(.horizontal, 12)

                    VStack {
                        HStack {
                            Image(systemName: "\(icon3)")
                                .font(.title2)
                                .foregroundColor(Color.red)
                                .padding(.bottom, 3)
                                .frame(width: 32, height: 32)
                        }
                        Text("\(text3)")
                            .font(.caption2)
                            .foregroundColor(Color.ui.onPrimaryContainer)
                            .padding(.bottom, 3)
                            .frame(width: 64, height: 32)

                        Text("\(betsPendingText3)")
                            .font(.headline)
                            .foregroundColor(Color.ui.secondary)
                            .padding(.bottom, 6)
                    }
                    .padding(.vertical, 3)
                    .padding(.horizontal, 12)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.ui.onPrimary)
        }
        .standardShadow()
    }
}
