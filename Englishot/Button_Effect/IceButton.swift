//
//  IceButton.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 2/6/25.
//
import SwiftUI

enum ButtonShape {
    case circle, roundedRect, capsule

    @ViewBuilder
    var shape: some View {
        switch self {
        case .circle:
            Circle()
        case .roundedRect:
            RoundedRectangle(cornerRadius: 5)
        case .capsule:
            Capsule()
        }
    }
}

struct ThreeDButtonStyle: ButtonStyle {
    var backColor: Color
    var frontColor: Image
    var buttonShape: ButtonShape

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            let offset: CGFloat = 5
            
            buttonShape
                .shape
                .foregroundStyle(backColor.gradient)
                .offset(y: offset)
            
            buttonShape
                .shape
                .overlay(
                        Image("icecube")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                    )
//                .foregroundStyle(frontColor.gradient)
                .offset(y: configuration.isPressed ? offset : 0)
            
            configuration.label
                .bold()
                .offset(y: configuration.isPressed ? offset : 0)
        }
        .compositingGroup()
        .shadow(radius: 5, y: configuration.isPressed ? 0 : 5)
    }
}
