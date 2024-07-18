//
//  ScanSheetView.swift
//  CaptureSymbol
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import SwiftUI

struct ScanSheetView: View {
    @ObservedObject var scanProvider: ScanProvider
    @Binding var showToast: Bool
    @Binding var showWebView: Bool
    @Binding var webViewURL: URL?
    
    var isValidURL: Bool {
        if let url = URL(string: scanProvider.text), UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }
    
    
    var body: some View {
        ScrollView {
            Text(scanProvider.text)
                .font(.system(.title3, design: .rounded))
                .padding()
        }
        
        Spacer()
        HStack(spacing: 20) {
            Button(action: {
                UIPasteboard.general.string = scanProvider.text
                showToast = true
            }) {
                Text("Copy to Clipboard")
                    .font(.system(.body, design: .rounded))
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Button(action: {
                if isValidURL {
                    scanProvider.showSheet = false
                    DispatchQueue.main.async {
                        webViewURL = URL(string: scanProvider.text)
                        showWebView = true
                    }
                }
            }) {
                Text("Open URL")
                    .font(.system(.body, design: .rounded))
                    .padding()
                    .background(isValidURL ? Color("PersonalGreenColor") : Color("PersonalGrayColor"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!isValidURL)
        }
        .padding()
        
        
        HStack(spacing: 20) {
            Button(action: scanProvider.Speak, label: {
                Label("Play", systemImage: scanProvider.isSpeaking ? "play.fill" : "play")
                    .font(.system(.body, design: .rounded))
                    .padding()
                    .background(scanProvider.isSpeaking ? Color("PersonalGrayColor") : Color("PersonalGreenColor"))
                    .foregroundStyle(.white)
                    .cornerRadius(8)
            })
            .padding(.trailing)
            .disabled(scanProvider.isSpeaking)
            Button(action: scanProvider.stopSpeaking, label: {
                Label("Stop", systemImage: "stop.circle.fill")
                    .font(.system(.body, design: .rounded))
                    .padding()
                    .background(.tertiary)
                    .foregroundStyle(Color("ColorBW"))
                    .cornerRadius(8)
            })
            .padding(.trailing)
        }
        .padding(.trailing, 50)
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium, .large ])
    }
}

#Preview {
    ScanSheetView(scanProvider: ScanProvider(),
                  showToast: .constant(false),
                  showWebView: .constant(false),
                  webViewURL: .constant(nil)
    )
}
