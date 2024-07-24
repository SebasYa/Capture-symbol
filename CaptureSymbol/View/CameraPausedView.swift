//
//  CameraPausedView.swift
//  CaptureSymbol
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import SwiftUI

struct CameraPausedView: View {
    var body: some View {
        ZStack {
            Color(String("ColorNewGray"))
            VStack {
                Text("Camera is Now Paused")
                    .foregroundStyle(.blue)
                    .font(.title2)
                    .padding(.top, 200)
                Text("Swipe down the sheet to reactive the camera")
                    .foregroundStyle(.orange)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
                
            }
        }
        .ignoresSafeArea()
    }
}

#Preview("English"){
    CameraPausedView()
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Español"){
    CameraPausedView()
        .environment(\.locale, Locale(identifier: "ES"))
}
