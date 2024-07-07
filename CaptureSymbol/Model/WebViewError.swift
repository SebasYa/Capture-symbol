//
//  WebViewError.swift
//  CaptureSymbol
//
//  Created by Sebastian Yanni on 05/07/2024.
//

import SwiftUI
import WebKit

enum WebViewError: Identifiable {
    case invalidURL, loadFailed(String)
    
    var id: String {
        switch self {
        case .invalidURL:
            return UUID().uuidString
        case .loadFailed(let error):
            return error
        }
    }
    
    var message: String {
        
        switch self {
            
        case .invalidURL:
            return "The URL is invalid."
            
        case .loadFailed(let error):
            return error
        }
    }
}
