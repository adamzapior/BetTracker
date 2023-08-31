import SwiftUI

struct EventDatePickerRow: View {

    @Binding
    var showDatePicker: Bool

    @Binding
    var selectedDate: Date

    let action: () -> Void

    @StateObject
    var vm: AddBetVM

    var body: some View {
        ZStack {
            Color.ui.background.opacity(0.3)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Image(systemName: "calendar")
                        .font(.title2)
                        .foregroundColor(Color.ui.scheme)
                        .padding(.trailing, 12)
                        .frame(width: 36, height: 36)

                    Text("Event date")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(Color.ui.secondary)
                        .padding(.vertical, 16)
                    Spacer()

                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.title)
                        .foregroundColor(Color.ui.secondary)
                        .onTapGesture {
                            showDatePicker = false
                            action()
                        }
                }
                .padding(.top, -16)
                .padding(.leading, 3)
                .padding(.bottom, -6)

                DatePicker(
                    "",
                    selection: $selectedDate
                )
                .font(.callout)
                .padding(.horizontal, 8)
                .frame(maxHeight: 150)
            }
            .tint(Color.ui.scheme)
            .padding()
            .background(
                Color.ui.onPrimary
                    .cornerRadius(15)
            )
        }
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.ui.onPrimary)
        }
        .standardShadow()
    }
}
