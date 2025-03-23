//
//  SwiftUIView.swift
//  level_view
//
//  Created by 李庭宇 on 2024/9/21.
//
// 顯示照片的視圖

import SwiftUI

struct PhotoView: View {
    var body: some View {
        VStack {
            Text("This is the Photo View.")
                .font(.largeTitle)
                .padding()
            
            Spacer()
        }
        .navigationTitle("Photo View")
    }
}

#Preview {
    PhotoView()
}
