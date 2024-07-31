//
//  ScanController.swift
//  CaptureSymbol
//  Copyright © 2024 The SY Repository. All rights reserved.
//
//  Created by Sebastián Yanni.
//



import SwiftUI
import VisionKit
import AVFoundation
import NaturalLanguage


// MARK: - UIViewController from UIKit to SwiftUI
struct ScanController: UIViewControllerRepresentable {
    
    @ObservedObject var scanProvider: ScanProvider
    
    func makeUIViewController(context: Context) ->  DataScannerViewController {
        // Let camara capture Text
        let dataScannerViewController = DataScannerViewController(recognizedDataTypes: [.text(), .barcode()],
                                                                  qualityLevel: .accurate,
                                                                  isHighlightingEnabled: true)
        dataScannerViewController.delegate = scanProvider
        
        do {
            try dataScannerViewController.startScanning()
        } catch {
            print("Failed to start scanning: \(error.localizedDescription)")
        }
        return dataScannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType,
                                context: Context) {}
    
}

// MARK: - Info Delegate
final class ScanProvider: NSObject, DataScannerViewControllerDelegate, ObservableObject, AVSpeechSynthesizerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate  {
    
    @Published var text: String = ""
    @Published var error: DataScannerViewController.ScanningUnavailable?
    @Published var showSheet = false
    @Published var isSpeaking = false
    var dataScannerViewController: DataScannerViewController?
    let synthesizer = AVSpeechSynthesizer()

    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    // Will execute when tap on screen
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        
        switch item {
            // recognize Text
        case .text(let recognizedText):
            DispatchQueue.main.async {
                self.text = recognizedText.transcript
                self.showSheet.toggle()
            }
            print("Recognized text: \(recognizedText.transcript)")
            
            // Recognize barcode or QR code
        case .barcode(let recognizedBarcode):
            DispatchQueue.main.async {
                self.text = recognizedBarcode.payloadStringValue ?? ""
                self.showSheet.toggle()
            }
            print("Recognized barcode: \(recognizedBarcode.payloadStringValue ?? "")")
            
        @unknown default:
            break
        }
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController,
                     becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
        DispatchQueue.main.async {
            self.error = error
        }
        print("Data scanner became unavailable: \(error.localizedDescription)")
    }
    
    // MARK: - Voice Lecture
    
    func Speak() {
        let textCopy = text
        let utterance = AVSpeechUtterance(string: textCopy)
        var detectedLanguage = detectLanguage(for: textCopy)
        
        if detectedLanguage.starts(with: "es") {
            detectedLanguage = "es-MX"
        }
        utterance.voice = AVSpeechSynthesisVoice(language: detectedLanguage)
        
        synthesizer.speak(utterance)
        isSpeaking = true
    }
    
    func detectLanguage(for text: String) -> String {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        
        if let languageCode = recognizer.dominantLanguage?.rawValue {
            return languageCode
        } else {
            return Locale.preferredLanguages.first ?? "en-US" // Default language
        }
    }
    
    func stopSpeaking () {
        synthesizer.stopSpeaking(at: .word)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
    }

    // MARK: - Camera
    
    func stopCamera() {
        DispatchQueue.main.async {
            self.dataScannerViewController?.stopScanning()
        }
    }
    
    func startScanning() {
        do {
            try dataScannerViewController?.startScanning()
        } catch {
            print("Failed to start scanning: \(error.localizedDescription)")
        }
    }
}
