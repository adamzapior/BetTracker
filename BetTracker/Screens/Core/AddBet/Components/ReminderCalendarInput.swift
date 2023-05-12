import SwiftUI

struct ReminderCalendarInput: View {

    @State
    private var time = Date.now

    @StateObject
    var vm = AddBetVM()

    private var emptyString = ""

    var body: some View {
        VStack {
            HStack {
                Text("testuj to")
                    .font(.body).foregroundColor(.accentColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .background {
                                Color.ui.onPrimary
                            }

                            .frame(maxWidth: .infinity)
                    }
            }
            DatePicker(
                "",
                selection: $vm.selectedDate
            )
            .datePickerStyle(.compact)
            .accentColor(.red)

            HStack {
                Spacer()
                Button {
                    // action
                } label: {
                    Text("Hej to ja")
                }
                Spacer()
                Button {
                    // action
                } label: {
                    Text("Hej to ja")
                }
                Spacer()
            }
            .padding(.top, 12)
        }
    }

    struct ReminderCalendarInput_Previews: PreviewProvider {
        static var previews: some View {
            ReminderCalendarInput()
        }
    }

}
