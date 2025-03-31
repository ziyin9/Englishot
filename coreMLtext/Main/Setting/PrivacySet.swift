//  PrivacySet.swift
//  coreMLtext
//
//  Created by 李庭宇 on 2025/1/23.
//

import AVFoundation
import CoreLocation

class PrivacyManager: ObservableObject {
    @Published var cameraPermissionStatus: AVAuthorizationStatus = .notDetermined
//    @Published var microphonePermissionStatus: AVAudioSession.RecordPermission = .undetermined
    @Published var locationPermissionStatus: CLAuthorizationStatus = .notDetermined
    
    private let locationManager = CLLocationManager()

    // 更新許可權狀態
    func updatePermissionsStatus() {
        cameraPermissionStatus = AVCaptureDevice.authorizationStatus(for: .video)
//        microphonePermissionStatus = AVAudioSession.sharedInstance().recordPermission
        locationPermissionStatus = locationManager.authorizationStatus
    }

    // 相機許可權請求
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.cameraPermissionStatus = granted ? .authorized : .denied
            }
        }
    }
    //DispatchQueue.main.async 將 UI 更新的操作切換到主執行緒
    //  .authorized（表示已授權）
    //  .denied（表示被拒絕
    // 麥克風許可權請求
//    func requestMicrophonePermission() {
//        AVAudioSession.sharedInstance().requestRecordPermission { granted in
//            DispatchQueue.main.async {
//                self.microphonePermissionStatus = granted ? .granted : .denied
//            }
//        }
//    }

    // 位置許可權請求
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.locationPermissionStatus = self.locationManager.authorizationStatus
        }
    }

    // 許可權狀態文字
    func permissionStatusText(for status: Any) -> String {
        switch status {
        case is AVAuthorizationStatus:
            switch status as! AVAuthorizationStatus {
            case .authorized: return "已允許"
            case .denied: return "已拒絕"
            case .notDetermined: return "未知"
            case .restricted: return "受限"
            @unknown default: return "未知"
            }
        case is AVAudioSession.RecordPermission:
            switch status as! AVAudioSession.RecordPermission {
            case .granted: return "已允許"
            case .denied: return "已拒絕"
            case .undetermined: return "未知"
            @unknown default: return "未知"
            }
        case is CLAuthorizationStatus:
            switch status as! CLAuthorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse: return "已允許"
            case .denied: return "已拒絕"
            case .notDetermined: return "未知"
            case .restricted: return "受限"
            @unknown default: return "未知"
            }
        default:
            return "未知"
        }
    }
}
