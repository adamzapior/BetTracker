import SwiftUI

struct NoteRow: View {

    @Binding
    var text: String
    
    let action: () -> Void

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "note")
                    .font(.title2)
                    .foregroundColor(Color.ui.scheme)
                    .padding(.trailing, 12)
                    .frame(width: 36, height: 36)

                Text("Your note:")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color.ui.secondary)
                    .padding(.vertical, 16)
                Spacer()
                Image(systemName: "minus")
                    .font(.title)
                    .foregroundColor(Color.ui.onPrimaryContainer)
//                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        action()
                    }
            }
            .padding(.horizontal)
            ZStack {
                if text.isEmpty {
                    VStack {
                        Text("Write something...")
                            .padding(.top, 10)
                            .padding(.leading, 6)
                            .opacity(0.6)
                        Spacer()
                    }
                }
                HStack {
                    TextEditor(text: $text)
                        .padding(.horizontal)
                        .frame(minHeight: 50)
                        .scrollContentBackground(.hidden)
                }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(
                    Color.ui.onPrimary
                )
        }
        .standardShadow()
    }
}
