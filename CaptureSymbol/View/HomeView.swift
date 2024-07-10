//
//  HomeView.swift
//  CaptureSymbol
//
//  Created by Sebastian Yanni on 05/07/2024.
//

import SwiftUI
import AVFoundation

struct HomeView: View {
    @StateObject var scanProvider = ScanProvider()
    @State private var showToast = false
    @State private var showWebView = false
    @State private var webViewURL: URL?
    @State private var isURLValid = true
    @State private var cameraAccessGranted = false
    
    var body: some View {
        Group {
            if cameraAccessGranted {
                ZStack {
                    if !scanProvider.showSheet && !showWebView {
                        ScanController(scanProvider: scanProvider)
                    }
                }
                .sheet(isPresented: $scanProvider.showSheet) {
                    ScanSheetView(scanProvider: scanProvider, showToast: $showToast, showWebView: $showWebView, webViewURL: $webViewURL)
                    
                }
                .sheet(isPresented: $showWebView) {
                    if let url = webViewURL {
                        ZStack {
                            WebModel(url: url)
                        }
                    }
                }
                .alert(isPresented: .constant(!isURLValid)) {
                    Alert(
                        title: Text("Error"),
                        message: Text("The URL is invalid"),
                        dismissButton: .default(Text("OK"), action: {
                            isURLValid = true
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
            } else {
                AuthorizationView()
            }
        }
        .onAppear {
            checkCameraAccess()
        }
    }
    private func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraAccessGranted = true
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    cameraAccessGranted = granted
                }
            }
            
        default:
            cameraAccessGranted = false
        }
    }
}

#Preview {
    HomeView()
}
