import SwiftUI

struct DropViewDelegate: DropDelegate {
    
    let destinationItem: CategoryModel
    @Binding var category: [CategoryModel]
    @Binding var draggedItem: CategoryModel?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        if let draggedItem = draggedItem {
            let fromIndex = category.firstIndex { $0.name == draggedItem.name }
            if let fromIndex {
                let toIndex = category.firstIndex { $0.name == destinationItem.name }
                if let toIndex, fromIndex != toIndex {
                    withAnimation {
                        self.category.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
                    }
                }
            }
        }
    }
}
struct CategoryModel: Identifiable {
    var id: Int64?
    let name: String
    var order: Int
}


struct CategoryEditView: View {
    
//    struct CategoryT: Identifiable {
//        let id = UUID()
//        let name: String
//    }
    
    @State private var draggedItem: CategoryModel?
    @State private var category: [CategoryModel] = [CategoryModel(name: "F1", order: 1), CategoryModel(name: "F2", order: 2), CategoryModel(name: "Shitoooo", order: 3), CategoryModel(name: "Testi", order: 4)]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                Spacer()
                    .frame(height: 40)
                
                ForEach(category, id: \.id) { item in
                    CategoryItemView(category: item)
                        .onDrag {
                            self.draggedItem = item
                            return NSItemProvider()
                        }
                        .onDrop(of: [.text],
                                delegate: DropViewDelegate(destinationItem: item, category: $category, draggedItem: $draggedItem)
                        )
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .ignoresSafeArea()
        .background(Color.brown)
    }
}

struct CategoryItemView: View {
    
    let category: CategoryModel
    
    var body: some View {
        HStack {
            Spacer()
            Text(category.name)
            Spacer()
        }
        .padding(.vertical, 40)
        .background(Color.gray)
        .cornerRadius(20)
    }
}

struct CategoryEditView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryEditView()
    }
}
