//
//  ContentView.swift
//  Consents Demo SwiftUI
//
//  Created by Václav Halík on 08.01.2021.
//

import SwiftUI
import SmartlookConsentSDK

struct ContentView: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            HStack {
                Spacer()

                Text("Smartlook Consent Demo")
                    .font(.title)

                Spacer()
            }

            ConsentStatesView()
                .frame(maxWidth: 350)

            Button("Review consents...") {
                reviewConsents()
            }

            Button("Show app settings...") {
                showAppSettingsAction()
            }

            Spacer()
        }
        .padding()
    }

    // MARK: - UI Actions

    func reviewConsents() {
        // let user review or check the consents
        SmartlookConsentSDK.show {
            if SmartlookConsentSDK.consentState(for: .analytics) != .provided {
                // stop analytics tools
            }
        }
    }

    func showAppSettingsAction() {
        if
            let settingsUrl = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settingsUrl)
        {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
