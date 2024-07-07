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
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(scanProvider.text)
                .font(.system(.body, design: .rounded))
//                .foregroundStyle(Color("TextColor"))
                .padding(.top, 20)
                .padding(.horizontal)
            
            Spacer()
            HStack {
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
                if let url = URL(string: scanProvider.text), UIApplication.shared.canOpenURL(url) {
                    Button(action: {
                        scanProvider.showSheet = false
                        DispatchQueue.main.async {
                            webViewURL = url
                            showWebView = true
                        }
                    }) {
                        Text("Open URL")
                            .font(.system(.body, design: .rounded))
                            .padding()
                            .background(Color("PersonalGreenColor"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            HStack {
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
            .padding()
            
            Spacer()
        }
        .padding()
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium, .large ])
        .background(Color("BackgroundColor"))
    }
}

#Preview {
    ScanSheetView(scanProvider: ScanProvider(), showToast: .constant(false), showWebView: .constant(false), webViewURL: .constant(nil))
}
