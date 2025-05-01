import SwiftUI

struct TutorialOverlayView: View {
    @Binding var isShowing: Bool
    @State private var currentStep = 0
    
    let steps: [TeachingStep] = [
        TeachingStep(
            imageName: "QQ",
            title: "Welcome to Englishot",
            description: "This is a fun way to learn English through interactive maps and games."
        ),
        TeachingStep(
            imageName: "QQ",
            title: "Explore Locations",
            description: "Visit different locations on the map to discover new learning opportunities."
        ),
        TeachingStep(
            imageName: "QQ",
            title: "Complete Challenges",
            description: "Complete challenges at each location to improve your English skills."
        )
    ]
    
    var body: some View {
        ZStack {
            // Dimming background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            // Content container
            VStack(spacing: 0) {
                // Header with more prominent close button
                HStack{
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.red.opacity(0.8))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "xmark")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .accessibilityLabel("Close tutorial")
                    Spacer()
                }
                
                
                // Tutorial content
                TabView(selection: $currentStep) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        VStack(spacing: 20) {
                            // Image placeholder
                            Image(steps[index].imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .cornerRadius(12)
                                .padding(.horizontal)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.black.opacity(0.2))
                                        .shadow(radius: 5)
                                )
                            
                            Text(steps[index].title)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(steps[index].description)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.horizontal, 40)
                                .padding(.bottom, 20)
                        }
                        .padding()
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                // CUSTOM PAGE INDICATORS - LARGE VISIBLE DOTS
//                HStack(spacing: 12) {
//                    ForEach(0..<steps.count, id: \.self) { index in
//                        Circle()
//                            .fill(currentStep == index ? Color.white : Color.white.opacity(0.3))
//                            .frame(width: 15, height: 15)
//                            .overlay(
//                                Circle()
//                                    .stroke(Color.white, lineWidth: 2)
//                                    .opacity(currentStep == index ? 1 : 0.3)
//                            )
//                            .onTapGesture {
//                                withAnimation {
//                                    currentStep = index
//                                }
//                            }
//                    }
//                }
//                .padding(.vertical, 15)
//                .background(Color.black.opacity(0.3))
                
                // Navigation buttons
                HStack(spacing: 30) {
                    if currentStep > 0 {
                        Button(action: {
                            withAnimation {
                                currentStep -= 1
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Previous")
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.2))
                            )
                            .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    if currentStep < steps.count - 1 {
                        Button(action: {
                            withAnimation {
                                currentStep += 1
                            }
                        }) {
                            HStack {
                                Text("Next")
                                Image(systemName: "chevron.right")
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.2))
                            )
                            .foregroundColor(.white)
                        }
                    } else {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Get Started")
                                .padding(.vertical, 12)
                                .padding(.horizontal, 20)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.2))
                                )
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
                .background(Color.black.opacity(0.3))
            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    
    
    
    private func dismiss() {
        withAnimation(.easeOut(duration: 0.3)) {
            isShowing = false
        }
    }
}

struct TeachingStep {
    let imageName: String
    let title: String
    let description: String
}

struct TutorialOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialOverlayView(isShowing: .constant(true))
    }
} 
