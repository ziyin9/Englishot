import SwiftUI

struct CoinDisplayView: View {
    @EnvironmentObject var uiState: UIState
    let coins: Int64
    @State private var bounce = false
    @State private var showReward = false
    @State private var Developer_showSetCoin = false

    @State private var rewardAmount: Int64 = 0
    
    var body: some View {
        
            Group {
                ZStack {
                    HStack(spacing: 8) {
                        Button(action:{
                            Developer_showSetCoin = true
                        }){
                            Image("fishcoin")
                                .resizable()
                                .frame(width: 40, height: 40)
                            //                            .font(.system(size: 20))
                                .foregroundColor(.blue)
                                .shadow(color: .blue, radius: 2)
                                .scaleEffect(bounce ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: bounce)
                        }
                        Text("\(coins)")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.2))
                            .overlay(
                                Capsule()
                                    .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                            )
                    )
                    .transition(.scale.combined(with: .opacity))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.top, 50)
                    .padding(.trailing, 10)
                    
                    if showReward {
                        CoinRewardView(amount: rewardAmount, delay: 0)
                            .position(x: UIScreen.main.bounds.width - 60, y: 70)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .onChange(of: coins) { _ in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    bounce = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        bounce = false
                    }
                }
            }
            .sheet(isPresented: $Developer_showSetCoin){
                SetCoinView()
            }
            
            
        }
        
        
        
    
    
    // 顯示獎勵動畫
    func showRewardAnimation(amount: Int64) {
        rewardAmount = amount
        showReward = true
        
        // Hide reward after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showReward = false
        }
    }
}

struct SetCoinView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var coinAmount: String = ""
    @AppStorage("neverShowCameraHint") private var neverShowCameraHint: Bool = false
    @State private var showResetAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("開發者設定")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                // 金幣設置區域
                VStack(spacing: 15) {
                    Text("金幣數量設定")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    HStack {
                        Image("fishcoin")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("目前金幣數量：")
                            .font(.system(size: 16))
                        
                        if let coin = fetchCoin() {
                            Text("\(coin.amount)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                    }
                    
                    TextField("輸入新的金幣數量", text: $coinAmount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                VStack(spacing: 15) {
                    Text("金幣快速設置")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                        ForEach([100, 500, 1000, 5000, 10000, 50000], id: \.self) { amount in
                            Button(action: {
                                coinAmount = "\(amount)"
                            }) {
                                Text("\(amount)")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 10)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                // 相機提示重置區域
                VStack(spacing: 15) {
                    Text("相機提示設定")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    VStack(spacing: 10) {
                        HStack {
                            Text("相機提示狀態：")
                                .font(.system(size: 16))
                            
                            Text(neverShowCameraHint ? "已停用" : "啟用中")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(neverShowCameraHint ? .red : .green)
                        }
                        
                        Button("重置相機提示") {
                            showResetAlert = true
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color.orange)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button("取消") {
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button("確認設置") {
                        if let amount = Int64(coinAmount), amount >= 0 {
                            setCoin(to: amount)
                            dismiss()
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(coinAmount.isEmpty || Int64(coinAmount) == nil ? Color.gray : Color.green)
                    .cornerRadius(10)
                    .disabled(coinAmount.isEmpty || Int64(coinAmount) == nil)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("開發者模式")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("關閉") {
                        dismiss()
                    }
                }
            }
            .alert("重置相機提示", isPresented: $showResetAlert) {
                Button("取消", role: .cancel) { }
                Button("重置", role: .destructive) {
                    neverShowCameraHint = false
                }
            } message: {
                Text("確定要重置相機提示設定嗎？\n重置後將重新顯示相機使用提示。")
            }
        }
    }
}

#Preview {
    CoinDisplayView(coins: 520)
        .environmentObject(UIState())
}
