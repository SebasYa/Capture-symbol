//
//  WebView.swift
//  CaptureSymbol
//
//  Created by Sebastian Yanni on 05/07/2024.
//


import SwiftUI
import SafariServices

struct WebModel: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
    
    
}
