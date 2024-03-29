import SwiftUI

struct CategoryRow: View {

    let icon: String

    @Binding
    var selectedCategory: Category

    @StateObject
    var vm: AddBetVM

    var body: some View {
        ZStack {
            HStack {
                Text("Select your sport category")
                    .font(.body)
                    .foregroundColor(Color.ui.onPrimaryContainer)
                Spacer()
            }
            .frame(minHeight: 24)
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(
                        Color.ui.onPrimary
                    )
            }
            Picker("Select sport", selection: $selectedCategory) {
                ForEach(Category.allCases.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { category in
                    Text(category.rawValue.capitalized)
                }
            }
            .tint(Color.ui.secondary)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .edgesIgnoringSafeArea(.all)
        }
        .standardShadow()
    }

}
