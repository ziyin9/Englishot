//
//  UIState.swift
//  coreMLtext
//
//  Created by 李庭宇 on 2025/1/23.
//


//
//  UIState.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 1/23/25.
//

import SwiftUI

class UIState: ObservableObject {
    @Published var isNavBarVisible: Bool = false  // 改为默认隐藏
    @Published var showGameCardView: Bool = false
    @Published var showDataView: Bool = false
    @Published var isCoinVisible: Bool = false     // 改为默认隐藏
    @Published var showCoinReward: Bool = false
    @Published var coinRewardAmount: Int = 0
    @Published var coinDisplayView: CoinDisplayView?
    @Published var isInitialized: Bool = false     // 添加初始化标志



}
