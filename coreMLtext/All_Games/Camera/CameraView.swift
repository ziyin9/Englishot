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
    
    // Add new bindings for different confidence level views
    @Binding var showHighConfidenceView: Bool
    @Binding var showMediumConfidenceView: Bool
    @Binding var showLowConfidenceView: Bool
    @Binding var confidenceLevel: Double
    
    var MLModel: String?
    var levelWords: [String]? // 當前關卡的單字列表

    func makeCoordinator() -> Coordinator {
        Coordinator(image: $image, 
                   recognizedObjects: $recognizedObjects, 
                   highestConfidenceWord: $highestConfidenceWord, 
                   showRecognitionErrorView: $showRecognitionErrorView,
                   showHighConfidenceView: $showHighConfidenceView,
                   showMediumConfidenceView: $showMediumConfidenceView,
                   showLowConfidenceView: $showLowConfidenceView,
                   confidenceLevel: $confidenceLevel,
                   currentLevelWords: levelWords,
                   Coordinator_MLModel: MLModel)
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
        
        // Add new bindings for different confidence level views
        @Binding var showHighConfidenceView: Bool
        @Binding var showMediumConfidenceView: Bool
        @Binding var showLowConfidenceView: Bool
        @Binding var confidenceLevel: Double
        
        var Coordinator_MLModel: String?
        var currentLevelWords: [String]? // 存儲當前關卡的單字列表
        
        var model: VNCoreMLModel?

        init(image: Binding<UIImage?>, recognizedObjects: Binding<[String]>, highestConfidenceWord: Binding<String>, showRecognitionErrorView: Binding<Bool>, showHighConfidenceView: Binding<Bool>, showMediumConfidenceView: Binding<Bool>, showLowConfidenceView: Binding<Bool>, confidenceLevel: Binding<Double>, currentLevelWords: [String]? = nil, Coordinator_MLModel: String?) {
            _image = image
            _recognizedObjects = recognizedObjects
            _highestConfidenceWord = highestConfidenceWord
            _showRecognitionErrorView = showRecognitionErrorView
            _showHighConfidenceView = showHighConfidenceView
            _showMediumConfidenceView = showMediumConfidenceView
            _showLowConfidenceView = showLowConfidenceView
            _confidenceLevel = confidenceLevel
            self.currentLevelWords = currentLevelWords

            // Handle model initialization based on the provided model name
            do {
                let configuration = MLModelConfiguration()
                var coreMLModel: MLModel
                
                // Check the model name and initialize the appropriate CoreML model
                if let modelName = Coordinator_MLModel {
                    switch modelName {
                    case "Home_School":
                        coreMLModel = try Microsoft_HomeSchool_1hour(configuration: configuration).model
                    // Add more models as needed
                    case "Mall_Market":
                        coreMLModel = try Microsoft_MallMarket_1hour(configuration: configuration).model
                    case "Zoo":
                        coreMLModel = try Zoo(configuration: configuration).model
                    // Default case if the model name doesn't match
                    default:
                        print("⚠️ Model name not recognized. Using default Moretry300 model.")
                        coreMLModel = try Microsoft_HomeSchool_1hour(configuration: configuration).model
                    }
                } else {
                    print("⚠️ No model name provided. Using default Moretry300 model.")
                    coreMLModel = try Microsoft_HomeSchool_1hour(configuration: configuration).model
                }
                
                // Initialize VNCoreMLModel with the chosen model
                model = try VNCoreMLModel(for: coreMLModel)
                print("Model initialized successfully")
                
            } catch {
                print("Error initializing model: \(error.localizedDescription)")
            }
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                // Reset previous results before processing new image
                self.recognizedObjects = []
                self.highestConfidenceWord = ""
                
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
                
                // 過濾結果，只保留當前關卡中包含的單字
                var filteredResults = results
                
                // 如果有提供當前關卡單字列表，則過濾結果
                if let levelWords = self.currentLevelWords, !levelWords.isEmpty {
                    filteredResults = results.filter { observation in
                        let wordIdentifier = observation.identifier.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                        return levelWords.contains { $0.lowercased() == wordIdentifier }
                    }
                    
                    if filteredResults.isEmpty && !results.isEmpty {
                        // 如果過濾後沒有任何匹配的單字，但原始結果不為空
                        // 顯示錯誤：單字不在當前關卡中
                        DispatchQueue.main.async {
                            self.showHighConfidenceView = false
                            self.showMediumConfidenceView = false
                            self.showLowConfidenceView = false
                            self.showRecognitionErrorView = true
                            
                            // 儲存最高辨識的詞以便記錄
                            if let highestObservation = results.first {
                                self.recognizedObjects = results.map { observation in
                                    "\(observation.identifier) - \(String(format: "%.2f", observation.confidence * 100))%"
                                }
                                self.highestConfidenceWord = "\(highestObservation.identifier) - \(String(format: "%.2f", highestObservation.confidence * 100))% (不在當前關卡中)"
                            }
                        }
                        return
                    }
                }
                
                let recognizedObjects = filteredResults.map { observation in
                    "\(observation.identifier) - \(String(format: "%.2f", observation.confidence * 100))%"
                }
                
                // 找出辨識率最高的單字
                if let highestConfidenceObservation = filteredResults.first {
                    let confidence = highestConfidenceObservation.confidence
                    
                    DispatchQueue.main.async {
                        self.recognizedObjects = recognizedObjects
                        self.confidenceLevel = Double(confidence)
                        
                        // Store the highest confidence word with its confidence level
                        self.highestConfidenceWord = "\(highestConfidenceObservation.identifier) - \(String(format: "%.2f", confidence * 100))%"
                        
                        // Handle different confidence levels
                        if confidence >= 0.8 {
                            // High confidence (80%-100%): 自動儲存，不需要用戶確認
                            self.showHighConfidenceView = true
                            self.showMediumConfidenceView = false
                            self.showLowConfidenceView = false
                            self.showRecognitionErrorView = false
                        } else if confidence >= 0.3 {
                            // Medium confidence (30%-80%): 顯示建議，不提供儲存選項
                            self.showHighConfidenceView = false
                            self.showMediumConfidenceView = true
                            self.showLowConfidenceView = false
                            self.showRecognitionErrorView = false
                        } else {
                            // Low confidence (<30%): 未識別到物品
                            self.showHighConfidenceView = false
                            self.showMediumConfidenceView = false
                            self.showLowConfidenceView = true
                            self.showRecognitionErrorView = false
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showRecognitionErrorView = true
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
