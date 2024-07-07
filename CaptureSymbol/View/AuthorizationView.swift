//
//  AuthorizationView.swift
//  CaptureSymbol
//
//  Created by Sebastian Yanni on 05/07/2024.
//


import SwiftUI

struct AuthorizationView: View {
    var body: some View {
        VStack {
            Text("Please allow camera access to scan text or QR.")
                .font(.system(.body, design: .rounded))
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
}

#Preview {
    AuthorizationView()
}
