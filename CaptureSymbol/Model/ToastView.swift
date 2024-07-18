//
//  ToastView.swift
//  CaptureSymbol
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import SwiftUI

struct ToastView: View {
    var message: String
    
    var body: some View {
        Text(message)
            .font(.system(.body, design: .rounded))
            .padding(.vertical)
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.bottom, 40)
            .transition(.opacity)
    }
}
