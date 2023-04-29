import PhotosUI
import SwiftUI

struct ProfileView: View {

    @Environment(\.colorScheme)
    var colorScheme

    @StateObject
    var vm = ProfileVM()

    @State
    private var isShowingPhotoPicker = false
    @State
    private var avatarImage = UIImage(named: "default-avatar")!

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 2) {
                    HStack {
                        Text("Profile")
                            .foregroundColor(Color.ui.scheme)
                            .bold()
                            .font(.largeTitle)
                        Spacer()
                        NavigationLink(destination: PreferencesView()) {
                            Image(systemName: "gear")
                                .foregroundColor(Color.ui.scheme)
                                .font(.title2)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 12)

                    VStack {
                        if let data = vm.data, let uiimage = UIImage(data: vm.data ?? ) {
                            Image(uiImage: uiimage)
                                .resizable()
                        }
                        PhotosPicker(
                            selection: vm.$selectedItems,
                            maxSelectionCount: 1,
                            matching: .images
                        ) {
                            Image(uiImage: UIImage(named: "default-avatar")!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .padding()
                        }
                        Spacer()
                    }

                    VStack {
                        HStack {
                            Spacer()
                            VStack(spacing: 4) {
                                Text("Hello, Adam!")
                                    .font(.title2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Click and check your betting stats")
                                    .font(.footnote)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color.ui.onPrimary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .padding(.horizontal, 20)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)

                    Form {
                        Section(
                            header: Text("PREFERENCES")
                                .foregroundColor(Color.ui.onPrimaryContainer)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                        ) {
                            Text("Waluta").listRowBackground(Color.ui.onPrimary)
                            Text("Podatek").listRowBackground(Color.ui.onPrimary)
                            Text("Kategorie").listRowBackground(Color.ui.onPrimary)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .frame(height: 235, alignment: .topLeading)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, -8)
                .padding(.bottom, 48)
            }
        }
        .onChange(of: vm.selectedItems) { _ in
            guard let item = vm.selectedItems.first else {
                return
            }
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case let .success(data):
                    if let data {
                        self.data = data
                    } else {
                        print("Data is nil")
                    }
                case let .failure(failure):
                    fatalError("dafuq")
                }
            }
        }
    }

}
