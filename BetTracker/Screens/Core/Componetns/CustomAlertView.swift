import SwiftUI

struct CustomAlertView: View {
    var title: String
    var messages: [String?]

    var primaryButtonLabel: String
    var primaryButtonAction: () -> Void
    var secondaryButtonLabel: String?
    var secondaryButtonAction: (() -> Void)?
    var image: Image?

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.3)
            
            ZStack {
                VStack {
                    Text(title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    ForEach(messages.compactMap { $0 }, id: \.self) { message in
                        Text(message)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(1)
                    }
                    .padding(.bottom,4)
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            primaryButtonAction()
                        }, label: {
                            Text(primaryButtonLabel)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.ui.scheme)
                                .cornerRadius(12)
                        })
                        if let secondaryButtonLabel {
                            Button(action: {
                                secondaryButtonAction?()
                            }, label: {
                                Text(secondaryButtonLabel)
                                    .font(.headline)
                                    .foregroundColor(Color.ui.secondary)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.ui.background)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.ui.scheme, lineWidth: 2)
                                    )
                            })
                        }
                    }
                }
                .padding()
                .background(Color.ui.onPrimary)
                .cornerRadius(20)
                .shadow(radius: 20)
            }
            .padding(.horizontal, 12)
        }
        .zIndex(100)
        .edgesIgnoringSafeArea(.all)
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomAlertView(
                title: "Success!",
                messages: ["Błąd 1", "Błąd 2", "Błąd 3"],
                primaryButtonLabel: "OK",
                primaryButtonAction: { }
            )
            .previewLayout(.sizeThatFits)
            .padding()

            CustomAlertView(
                title: "Error!",
                messages: ["Błąd 1", "Błąd 2", "Błąd 3"],
                primaryButtonLabel: "Try Again",
                primaryButtonAction: { },
                secondaryButtonLabel: "Cancel",
                secondaryButtonAction: { }
            )
            .previewLayout(.sizeThatFits)
            .padding()

            CustomAlertView(
                title: "Confirmation",
                messages: ["Błąd 1", "Błąd 2", "Błąd 3"],
                primaryButtonLabel: "Yes",
                primaryButtonAction: { },
                secondaryButtonLabel: "No",
                secondaryButtonAction: { }
            )
            .previewLayout(.sizeThatFits)
            .padding()

            CustomAlertView(
                title: "Warning!",
                messages: ["Błąd 1", "Błąd 2", "Błąd 3"],
                primaryButtonLabel: "Proceed",
                primaryButtonAction: { },
                secondaryButtonLabel: "Cancel",
                secondaryButtonAction: { }
            )
            .previewLayout(.sizeThatFits)
            .padding()
        }
    }
}

//struct CustomAlertView_Preview: PreviewProvider {
//    static var previews: some View {
//        CustomAlertView(
//            title: "huj",
//            messages: ["XD", "XD"],
//            primaryButtonLabel: "ok",
//            primaryButtonAction: { }
//        )
//    }
//}
