//
//  ToastView.swift
//  CaptureSymbol
//
//  Created by Sebastian Yanni on 05/07/2024.
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
