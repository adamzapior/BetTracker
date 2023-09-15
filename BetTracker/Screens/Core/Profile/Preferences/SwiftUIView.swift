//
//  SwiftUIView.swift
//  BetTracker
//
//  Created by Adam Zapiór on 07/09/2023.
//

import SwiftUI

struct CustomFormCell: View {
    var title: String
    var value: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.gray)

                Spacer()

                Text(value)
                    .font(.body)
            }
            .padding()

            Divider()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct CustomFormCell_Previews: PreviewProvider {
    static var previews: some View {
        CustomFormCell(title: "Name", value: "John Doe")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

struct ContentView2: View {
    var body: some View {
        VStack {
            CustomFormCell(title: "Name", value: "John Doe")
            CustomFormCell(title: "Age", value: "30")
        }
    }
}


struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
