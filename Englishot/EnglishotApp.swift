//
//  coreMLtextApp.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 8/27/24.
//

import SwiftUI
import UIKit

@main
struct EnglishotApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var audioManager = AudioManager()
    // init CoreDataManager
    init() {
        // 確保 CoreData 的上下文在應用啟動時已經初始化
        _ = CoreDataManager.shared
        
        initializeCoinIfNeeded()

    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, CoreDataManager.shared.context)  // 如果需要在 View 中使用 CoreData
                .environmentObject(audioManager)//設定音樂
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait // 只直向
    }
}
