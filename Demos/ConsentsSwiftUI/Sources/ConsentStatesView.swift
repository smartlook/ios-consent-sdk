//
//  ConsentStatesView.swift
//  ConsentsSwiftUI
//
//  Created by Václav Halík on 11.01.2021.
//

import SwiftUI
import SmartlookConsentSDK

struct ConsentStatesView: View {

    @State private var updateFlag: Bool = false

    // States colors
    private let consentColors: [SmartlookConsentSDK.ConsentState: Color] = [
        .unknown: Color(.systemGray2),
        .provided: Color(.systemGreen),
        .notProvided: Color(.systemRed)
    ]

    // Consent colors
    private var panelWasShownColor: Color {
        SmartlookConsentSDK.wasShown ? .green : .red
    }
    private var privacyConsentColor: Color? { consentColors[SmartlookConsentSDK.consentState(for: .privacy)]
    }
    private var analyticsConsentColor: Color? { consentColors[SmartlookConsentSDK.consentState(for: .analytics)]
    }

    var body: some View {
        VStack(spacing: 6) {
            ConsentStateRowView(text: "Consents panel has been shown", color: panelWasShownColor)

            ConsentStateRowView(text: "Privacy consent", color: privacyConsentColor)

            ConsentStateRowView(text: "Analytics consent", color: analyticsConsentColor)

            // Force to update view
            if updateFlag {
                EmptyView()
            }
        }
        // This is not necessary if all the logic is handled in the `SmartlookConsentSDK.check`
        // or `SmartlookConsentSDK.show` callbacks may be usefully eg.,
        // if some UI depends on the consents state like here.
        .onReceive(NotificationCenter.default.publisher(
            for: SmartlookConsentSDK.consentsTouchedNotification
        )) { _ in
            updateFlag.toggle()
        }
    }
}

struct ConsentStateRowView: View {
    var text: String
    var color: Color?

    var body: some View {
        HStack {
            Text(text)

            Spacer()

            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(color)
                .cornerRadius(4)
        }
    }
}

struct ConsentStatesView_Previews: PreviewProvider {
    static var previews: some View {
        ConsentStatesView()
    }
}
