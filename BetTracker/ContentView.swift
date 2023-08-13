//
//  ContentView.swift
//  BetTracker
//
//  Created by Adam Zapiór on 20/03/2023.
//

import SwiftUI

struct ContentView: View {
        
    @EnvironmentObject var session: SessionManager

    
    var body: some View {
        ZStack {
            switch session.currentState {
            case .loggedIn:
                TabBar()
                    .transition(.move(edge: .bottom))
            case .onboardingSetup:
                OnboardingSetupView(vm: PreferencesVM(), action: session.completeOnboardingSetup)
                    .animation(.easeInOut, value: 0.5)
            case .onboarding:
                OnboardingView(action: session.completeOnboarding)
                    .transition(
                        .move(edge: .bottom)
                    )
            default:
                ProgressView()
            }
        }
        .animation(.easeInOut, value: session.currentState)
        .onAppear(perform: session.configureCurrentState)
    }
}

struct ContentView_Previews: PreviewProvider {
    var bet: BetModel

    static var previews: some View {
        ContentView()
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

