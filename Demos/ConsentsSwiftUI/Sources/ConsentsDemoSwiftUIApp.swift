//
//  ConsentsDemoSwiftUIApp.swift
//  Consents Demo SwiftUI
//
//  Created by Václav Halík on 08.01.2021.
//

import SwiftUI

@main
struct ConsentsSwiftUIApp: App {
    // swiftlint:disable weak_delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
