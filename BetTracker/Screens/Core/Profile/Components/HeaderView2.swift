//
//  HeaderView2.swift
//  BetTracker
//
//  Created by Adam Zapiór on 06/05/2023.
//

import SwiftUI

let size: CGSize = .init()
let safeArea: EdgeInsets = .init()
	



struct HeaderView2: View {
    
 
    @StateObject
    var vm = ProfileVM()

    var body: some View {
//        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HStack {
                    Spacer()
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
                    
                    ZStack {
                    HStack { }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(maxHeight: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 12)
                    
                    headerView().frame(alignment: .top).padding(.top, -375)
                }
            }
        }
    
    @ViewBuilder
    func headerView() -> some View {
        let headerHeight = (size.height * 0.3) + safeArea.top
        
        ZStack {
            Rectangle()
                .fill((Color.ui.scheme).gradient).opacity(0.5)
                .frame(minHeight: 300)
            
            
            VStack(spacing: 15) {
                //Profile Image
//                GeometryReader {
//                    let rect = $0.frame(in: .global)
//
                    CircularProfileImage(imageState: vm.imageState)
                        .aspectRatio(contentMode: .fit)
//                        .frame(width: rect.width, height: rect.height)
//                }
                
                Text("Adam")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
            }
            .padding(.top, 150)
            .padding(.bottom, 15)

        }
        .frame(height: 0)
//        .frame(height: headerHeight)
        

    }
}

struct HeaderView2_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView2()
    }
}
