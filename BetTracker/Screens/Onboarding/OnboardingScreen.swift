import SwiftUI

struct OnboardingScreen: View {
    let action: () -> Void

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    VStack(spacing: 0) {
                        headerView()
                            .frame(height: geometry.size.height * 0.75)
                            
                        Spacer(minLength: 20)
                            
                        buttonView()
                            .frame(height: geometry.size.height * 0.25)
                    }
                }
            }
        }
    }
    
    private func headerView() -> some View {
        VStack(spacing: 48) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Keep your stats in one place")
                        .foregroundColor(Color.ui.scheme)
                        .font(.largeTitle)
                        .bold()
        
                    Text("with BetTracker.")
                        .foregroundColor(Color.ui.secondary)
                        .font(.largeTitle)
                        .bold()
                }
                .frame(maxHeight: .infinity, alignment: .center)
            }
        }
    }
    
    private func buttonView() -> some View {
        GeometryReader { geometry in
            VStack {
                Button(action: {
                    action()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.ui.background)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.ui.secondary, lineWidth: 1)
                            )
                        
                        Text("Get started")
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color.ui.secondary)
                    }
                    .frame(width: max(min(geometry.size.width - 24, 300), 100), height: 56)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 72)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
            .padding(.bottom, 48)
        }
    }
}
