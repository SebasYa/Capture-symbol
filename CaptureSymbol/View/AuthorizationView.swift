//
//  AuthorizationView.swift
//  CaptureSymbol
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//


import SwiftUI

struct AuthorizationView: View {
    var body: some View {
        ZStack {
            Color.black
            VStack {
                Text("Please allow camera access to scan text or QR.")
                    .font(.system(.body, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .padding(.top)
                Button(action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }) {
                    Text("Go to Settings")
                        .font(.system(.body, design: .rounded))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            .padding()
        }
        .ignoresSafeArea()
    }
}

#Preview("English") {
    AuthorizationView()
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Español") {
    AuthorizationView()
        .environment(\.locale, Locale(identifier: "ES"))
}

