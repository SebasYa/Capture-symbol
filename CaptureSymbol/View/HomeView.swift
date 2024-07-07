//
//  HomeView.swift
//  CaptureSymbol
//
//  Created by Sebastian Yanni on 05/07/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var scanProvider = ScanProvider()
    @State private var showToast = false
    @State private var showWebView = false
    @State private var webViewURL: URL?
    @State private var webViewError: WebViewError?
    @State private var isWebLoading = false
    
    var body: some View {
        ZStack {
            if !scanProvider.showSheet && !showWebView {
                ScanController(scanProvider: scanProvider)
            } else {
                ScanController(scanProvider: scanProvider)
                    .blur(radius: 10, opaque: true)
            }
        }
                .sheet(isPresented: $scanProvider.showSheet) {
                    ScanSheetView(scanProvider: scanProvider, showToast: $showToast, showWebView: $showWebView, webViewURL: $webViewURL)
                }
                .sheet(isPresented: $showWebView) {
                    if let url = webViewURL {
                        ZStack {
                            WebView(url: url, error: $webViewError, isLoading: $isWebLoading)
                            if isWebLoading {
                                ProgressView("Loading...")
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(2)
                            }
                        }
                    }
                }
                .background(Color("BackgroundColor"))
                .alert(item: $webViewError) { error in
                    Alert(
                        title: Text("Error"),
                        message: Text(error.message),
                        dismissButton: .default(Text("OK"), action: {
                            webViewError = nil
                        })
                    )
        }
        .ignoresSafeArea(.container)
        
        
        if showToast {
            ToastView(message: "Text copied to clipboard")
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showToast = false
                        }
                    }
                }
        }
    }
}



#Preview {
    HomeView()
}
