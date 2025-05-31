//
//  CameraHintView.swift
//  Englishot
//
//  Created by 陳姿縈 on 5/10/25.
//


//struct CameraHintView: View {
//    @Binding var showCameraHint: Bool
//    @Binding var neverShowAgain: Bool
//    var onConfirm: () -> Void
//    
//    var body: some View {
//        ZStack {
//            Color.black.opacity(0.4)
//                .edgesIgnoringSafeArea(.all)
//            
//            VStack(spacing: 20) {
//                Text("相機使用提示")
//                    .font(.headline)
//                    .foregroundColor(.primary)
//                    .padding(.top)
//                
//                Text("一次只能拍攝一張物品，並保持背景乾淨，光線充足。")
//                    .font(.body)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)
//                
//                HStack {
//                    Toggle("不再顯示", isOn: $neverShowAgain)
//                        .toggleStyle(SwitchToggleStyle(tint: .blue))
//                }
//                .padding(.horizontal)
//                
//                Button(action: onConfirm) {
//                    Text("我明白了")
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
//                .padding(.horizontal)
//                .padding(.bottom)
//            }
//            .background(Color(UIColor.systemBackground))
//            .cornerRadius(15)
//            .shadow(radius: 10)
//            .padding(.horizontal, 40)
//        }
//    }
//}
