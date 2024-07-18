//
//  HomeView.swift
//  CaptureSymbol
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//

import SwiftUI
import AVFoundation

struct HomeView: View {
    @StateObject var scanProvider = ScanProvider()
    @State private var showToast = false
    @State private var showWebView = false
    @State private var webViewURL: URL?
    @State private var cameraAccessGranted = false

    var body: some View {
        ZStack {
            Color.black
            Group {
                if cameraAccessGranted {
                    ZStack {
                        if !scanProvider.showSheet && !showWebView {
                            ScanController(scanProvider: scanProvider)
                                .onAppear(perform: {
                                    scanProvider.stopSpeaking()
                                    scanProvider.startScanning()
                                })
                                .onDisappear {
                                    scanProvider.stopCamera()
                                }
                        } else {
                            CameraPausedView()
                                .onAppear(perform: {
                                    scanProvider.stopCamera()
                                })
                        }
                    }
                    .sheet(isPresented: $scanProvider.showSheet, onDismiss: {
                        //                    scanProvider.clearFrozenFrame()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            scanProvider.startScanning()
                        }
                    }) {
                        ScanSheetView(scanProvider: scanProvider, showToast: $showToast, showWebView: $showWebView, webViewURL: $webViewURL)
                    }
                    .sheet(isPresented: $showWebView, onDismiss: {
                        //                    scanProvider.clearFrozenFrame()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            scanProvider.startScanning()
                        }
                    }) {
                        if let url = webViewURL {
                            ZStack {
                                WebModel(url: url)
                                
                            }
                        }
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
            .ignoresSafeArea()
            .onAppear {
                checkCameraAccess()
            }
        }
        .ignoresSafeArea()
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
