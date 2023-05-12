import SwiftUI

struct DatePickerWithButtons: View {

    @Binding
    var showDatePicker: Bool
//    @Binding
//    var savedDate: Date?
    @Binding
    var selectedDate: Date

    var savedSuccesfully: (() -> Void)?
    var helper: ()

    @StateObject
    var vm: AddBetVM

    var body: some View {
        ZStack {
            Color.ui.background.opacity(0.3)
                .edgesIgnoringSafeArea(.all)

            VStack {
                DatePicker(
                    "Your remind will be set to:",
                    selection: $selectedDate,
                    in: vm.dateClosedRange
                )
//                    .datePickerStyle(WheelDatePickerStyle())
                .font(.callout)
                .padding(.horizontal, 8)
                .frame(maxHeight: 150)
                Divider()
                HStack {
                    Button(action: {
                        showDatePicker = false
                        vm.deleteRemind()

                    }, label: {
                        Text("Cancel")
                            .foregroundColor(Color.red)
                    })

                    Spacer()

                    Button(action: {
                        showDatePicker = false
                        vm.saveIsClicked()

                    }, label: {
                        Text("Save".uppercased())
                            .bold()
                    })
                }
                .padding(.horizontal)
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
        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 3, y: 2)
    }
}

struct DatePickerWithButtons_Previews: PreviewProvider {
    static var previews: some View {
        AddBetScreen()
    }
}
