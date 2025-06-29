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
    @State private var isLoading = true
    
    // init CoreDataManager
    init() {
        // 確保 CoreData 的上下文在應用啟動時已經初始化
        _ = CoreDataManager.shared
        
        initializeCoinIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoading {
                    LoadingView {
                        // 載入完成後的回調
                        withAnimation(.easeInOut(duration: 1.2)) {
                            isLoading = false
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .identity,
                        removal: .opacity.combined(with: .scale(scale: 0.8).combined(with: .move(edge: .top)))
                    ))
                    .zIndex(1)
                } else {
                    MainView()
                        .environment(\.managedObjectContext, CoreDataManager.shared.context)
                        .environmentObject(audioManager)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.95).combined(with: .move(edge: .bottom))),
                            removal: .identity
                        ))
                        .zIndex(0)
                }
            }
            .animation(.spring(response: 1.0, dampingFraction: 0.8, blendDuration: 0.5), value: isLoading)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait // 只直向
    }
}
