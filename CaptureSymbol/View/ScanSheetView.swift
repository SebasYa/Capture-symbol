//
//  ScanSheetView.swift
//  CaptureSymbol
//
//  Created by Sebastian Yanni on 05/07/2024.
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
            Text(scanProvider.text)
                .font(.system(.body, design: .rounded))
                .padding(.top, 20)
                .padding(.horizontal)
            
            Spacer()
            HStack(spacing: 20) {
                Button(action: {
                    UIPasteboard.general.string = scanProvider.text
                    showToast = true
                }) {
                    Text("Copy to Clipboard")
                        .font(.system(.body, design: .rounded))
                        .padding()
                        .background(Color.blue)
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
            .padding(.trailing, 30)

    
            HStack(spacing: 20) {
                Button(action: scanProvider.Speak, label: {
                    Label("Play", systemImage: scanProvider.isSpeaking ? "play.fill" : "play")
                        .font(.system(.body, design: .rounded))
                        .padding()
                        .background(scanProvider.isSpeaking ? Color("PersonalGrayColor") : Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(8)
                })
                .disabled(scanProvider.isSpeaking)
                Button(action: scanProvider.stopSpeaking, label: {
                    Label("Stop", systemImage: "stop.circle.fill")
                        .font(.system(.body, design: .rounded))
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(8)
                })
            }
            .padding(.trailing, 115)
            
            Spacer()
        
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
