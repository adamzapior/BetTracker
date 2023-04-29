//
//  ContentView.swift
//  BetTracker
//
//  Created by Adam Zapiór on 20/03/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            TabBar()
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
