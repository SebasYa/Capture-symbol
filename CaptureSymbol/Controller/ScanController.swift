//
//  ScanController.swift
//  CaptureSymbol
//
//  Created by Sebastian Yanni on 05/07/2024.
//



import SwiftUI
import VisionKit
import AVFoundation

// UIViewController from UIKit to SwiftUI
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

// Info Delegate
final class ScanProvider: NSObject, DataScannerViewControllerDelegate, ObservableObject, AVSpeechSynthesizerDelegate  {
    
    @Published var text: String = ""
    @Published var error: DataScannerViewController.ScanningUnavailable?
    @Published var showSheet = false
    @Published var isSpeaking = false
    let synthesizer = AVSpeechSynthesizer()
//    var captureSession: AVCaptureSession?
    
    override init() {
            super.init()
            synthesizer.delegate = self
        }
    
    // Will execute when tap on screen
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        
        switch item {
            // recognize Text
        case .text(let recognizedText):
            self.text = recognizedText.transcript
            self.showSheet.toggle()
            print("Recognized text: \(recognizedText.transcript)")
            
            // Recognize barcode or QR code
        case .barcode(let recognizedBarcode):
            self.text = recognizedBarcode.payloadStringValue ?? ""
            self.showSheet.toggle()
            print("Recognized barcode: \(recognizedBarcode.payloadStringValue ?? "")")
            
        @unknown default:
            break
        }
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController,
                     becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
        self.error = error
        print("Data scanner became unavailable: \(error.localizedDescription)")
    }
    
    func Speak() {
        let textCopy = text
        let utterance = AVSpeechUtterance(string: textCopy)
    //  For locall system language voice -> let preferredLanguage = Locale.preferredLanguages.first ?? "en-US"
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US" /*"es-MX"*/)
        
        synthesizer.speak(utterance)
        isSpeaking = true
    }
    
    func stopSpeaking () {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
    
//    func startCamera() {
//        captureSession?.startRunning()
//    }
//
//    func stopCamera() {
//        captureSession?.stopRunning()
//    }
}
