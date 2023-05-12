import SwiftUI

struct Ble: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Spacer()
                    NavigationLink(destination: Text("Hi")) {
                        Button {
                        } label: {
                            Text("Submit")
                                .frame(height: 42)
                        }
//                        .buttonStyle(FilledButton())
                        .frame(width: 248, height: 42, alignment: .center)
                    }
                    .padding(.top, 33)
                    .padding(.bottom, 12)
                }
                .frame(maxWidth: .infinity)
                .frame(height: geometry.size.height)
            }
        }
    }
}
