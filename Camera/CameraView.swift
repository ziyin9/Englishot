//
//  CameraView.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 9/21/24.
//

import SwiftUI
import CoreML
import Vision
import AVFoundation
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var recognizedObjects: [String]
    @Binding var highestConfidenceWord: String // 傳遞最高辨識率單字的綁定變數
    
    @Binding var showRecognitionErrorView: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(image: $image, recognizedObjects: $recognizedObjects, highestConfidenceWord: $highestConfidenceWord, showRecognitionErrorView: $showRecognitionErrorView)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: UIImage?
        @Binding var recognizedObjects: [String]
        @Binding var highestConfidenceWord: String
        
        @Binding var showRecognitionErrorView: Bool
        
        var model: VNCoreMLModel?

        init(image: Binding<UIImage?>, recognizedObjects: Binding<[String]>, highestConfidenceWord: Binding<String>, showRecognitionErrorView: Binding<Bool>) {
            _image = image
            _recognizedObjects = recognizedObjects
            _highestConfidenceWord = highestConfidenceWord
            _showRecognitionErrorView = showRecognitionErrorView
            // Initialize model and handle possible errors
            do {
                let configuration = MLModelConfiguration()
                let coreMLModel = try Moretry300(configuration: configuration).model
                model = try VNCoreMLModel(for: coreMLModel)
                print("Model initialized successfully")
            } catch {
                print("Error initializing model: \(error.localizedDescription)")
            }
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                image = uiImage
                recognizeObjectsInImage(image: uiImage)
            }
            picker.dismiss(animated: true)
        }

        func recognizeObjectsInImage(image: UIImage) {
            guard let model = model else {
                print("Model is nil, cannot perform recognition")
                return
            }
            
            let request = VNCoreMLRequest(model: model) { request, error in
                if let error = error {
                    print("Error during object recognition: \(error.localizedDescription)")
                    return
                }
                
                guard let results = request.results as? [VNClassificationObservation] else {
                    print("Unexpected results type from VNCoreMLRequest")
                    return
                }
                
                let recognizedObjects = results.map { observation in
                    "\(observation.identifier) - \(String(format: "%.2f", observation.confidence * 100))%"
                }
                
                // 找出辨識率最高的單字
                if let highestConfidenceObservation = results.first {
                    DispatchQueue.main.async {
                        self.highestConfidenceWord = "\(highestConfidenceObservation.identifier) - \(String(format: "%.2f", highestConfidenceObservation.confidence * 100))%"
                    }
                }
                
                DispatchQueue.main.async {
                    self.recognizedObjects = recognizedObjects
                        if let highestConfidenceObservation = results.first, highestConfidenceObservation.confidence >= 0.5 {
                            self.highestConfidenceWord = highestConfidenceObservation.identifier
                        } else {
                        self.showRecognitionErrorView = true // 辨識失敗，顯示錯誤視圖
                        }
                }
            }
            
            guard let ciImage = CIImage(image: image) else {
                print("Failed to convert UIImage to CIImage")
                return
            }
            
            let handler = VNImageRequestHandler(ciImage: ciImage)
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    print("Error performing request: \(error.localizedDescription)")
                }
            }
        }
    }
}
