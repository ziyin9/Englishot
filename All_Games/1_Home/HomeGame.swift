import SwiftUI
import Vision
import CoreML
import UIKit
import AVFoundation  // Add if needed

// ... rest of your HomeGame.swift code ... 

struct HomeGame: View {
    @State private var image: UIImage?
    @State private var recognizedObjects: [String] = []
    @State private var highestConfidenceWord: String = ""
    @State private var showRecognitionErrorView: Bool = false
    @State private var showingCamera: Bool = false
    
    var body: some View {
        // Your view content
        Button("Open Camera") {
            showingCamera = true
        }
        .sheet(isPresented: $showingCamera) {
            CameraView(
                image: $image,
                recognizedObjects: $recognizedObjects,
                highestConfidenceWord: $highestConfidenceWord,
                showRecognitionErrorView: $showRecognitionErrorView,
                modelName: "Home_School"  // Or whatever model name you want to use
            )
        }
    }
} 