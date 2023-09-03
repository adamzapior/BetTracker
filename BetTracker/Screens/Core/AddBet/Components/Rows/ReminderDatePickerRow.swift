import SwiftUI

struct ReminderDatePickerRow: View {

    @Binding
    var showDatePicker: Bool

    @Binding
    var selectedDate: Date

    @StateObject
    var vm: AddBetVM

    var body: some View {
        ZStack {
            VStack {
                DatePicker(
                    "Your remind will be set to:",
                    selection: $selectedDate,
                    in: vm.reminderDateClosedRange
                )
                .font(.callout)
                .padding(.horizontal, 8)
                .frame(maxHeight: 150)
                Divider()
                HStack {
                    Button(action: {
                        showDatePicker = false
                        vm.deleteReminder()

                    }, label: {
                        Text("Cancel")
                            .foregroundColor(Color.red)
                    })

                    Spacer()

                    Button(action: {
                        showDatePicker = false
                        vm.saveReminder()

                    }, label: {
                        Text("Save".uppercased())
                            .bold()
                    })
                }
                .padding(.horizontal)
            }
            .tint(Color.ui.scheme)
            .padding()
        }
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color.ui.onPrimary)
        }
        .standardShadow()
    }
}
