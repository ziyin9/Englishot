//
//  GameTestView.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 9/21/24.
//

import SwiftUI

struct GameTestView: View {
    @Binding var showingCamera : Bool

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button(action: {
            showingCamera = true
        }) {
            HStack {
                Image(systemName: "camera")
                    .font(.title)
                Text("Take Photo")
                    .fontWeight(.semibold)
                    .font(.title)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(40)
        }
        .padding()
    }
}
#Preview {
    
}
