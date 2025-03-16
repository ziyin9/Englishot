import SwiftUI
import AVFoundation

struct WordDetailView: View {
    var vocabularies: [Vocabulary]
    var currentIndex: Int
    @Binding var selectedIndex: Int
    var showimages: [Data?]
    @StateObject private var audioPlayer = AudioPlayer()
    @Environment(\.presentationMode) var presentationMode
    @State private var isBackButtonHovered = false
    @State private var isArrowGlowing = false
    @State private var arrowPhase = 0.0
    @Environment(\.dismiss) var dismiss
    
    // Add these state variables for smoother animation
    @GestureState private var dragOffset: CGFloat = 0
    @State private var offset: CGFloat = 0

    var body: some View {
        ZStack {
            // Background gradient with snow effect
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.white.opacity(0.3),
                    Color.blue.opacity(0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            // Snow effect
            SnowfallView()
                .opacity(0.6)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Word card container
                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            ForEach(Array(vocabularies.enumerated()), id: \.element.id) { index, vocabulary in
                                VStack {
                                    // Existing word content
                                    Text(vocabulary.E_word)
                                        .font(.system(size: 36, weight: .bold, design: .rounded))
                                        .foregroundColor(.primary.opacity(0.8))
                                    
                                    Text(vocabulary.C_word)
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                        .padding(.bottom, 5)
                                    
                                    if let imageData = showimages[index],
                                       let image = UIImage(data: imageData) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxHeight: 400)
                                            .cornerRadius(15)
                                            .shadow(color: .blue.opacity(0.2), radius: 10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(
                                                        LinearGradient(
                                                            colors: [.white.opacity(0.8), .blue.opacity(0.6)],
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        ),
                                                        lineWidth: 1
                                                    )
                                                )
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Example Sentence")
                                            .font(.headline)
                                            .foregroundColor(.blue.opacity(0.7))
                                        
                                        Text(vocabulary.exSentence)
                                            .font(.system(size: 18, weight: .bold, design: .rounded))
                                            .foregroundColor(.primary.opacity(0.8))
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(.white.opacity(0.5))
                                                    .shadow(color: .blue.opacity(0.1), radius: 5)
                                            )
                                    }
                                    .padding(.top, 10)
                                }
                                .frame(width: geometry.size.width)
                            }
                        }
                        .offset(x: -CGFloat(selectedIndex) * geometry.size.width + offset + dragOffset)
                        .animation(.interpolatingSpring(stiffness: 300, damping: 30), value: offset)
                        .animation(.interpolatingSpring(stiffness: 300, damping: 30), value: selectedIndex)
                        .gesture(
                            DragGesture()
                                .updating($dragOffset) { value, state, _ in
                                    state = value.translation.width
                                }
                                .onEnded { value in
                                    let cardWidth = geometry.size.width
                                    let threshold = cardWidth * 0.3
                                    var newIndex = selectedIndex
                                    
                                    // Calculate final offset with velocity consideration
                                    let velocity = value.predictedEndLocation.x - value.location.x
                                    let shouldSwipe = abs(value.translation.width + velocity) > threshold
                                    
                                    if shouldSwipe {
                                        if value.translation.width > 0 && selectedIndex > 0 {
                                            newIndex -= 1
                                        } else if value.translation.width < 0 && selectedIndex < vocabularies.count - 1 {
                                            newIndex += 1
                                        }
                                    }
                                    
                                    // Animate to new position
                                    withAnimation(.interpolatingSpring(stiffness: 300, damping: 30)) {
                                        selectedIndex = newIndex
                                        offset = 0
                                    }
                                }
                        )
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.7)
                }
                .padding()
            }
            
            // Page indicators
            HStack {
                ForEach(0..<vocabularies.count, id: \.self) { index in
                    Circle()
                        .fill(index == selectedIndex ? Color.blue : Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == selectedIndex ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedIndex)
                }
            }
            .padding(.bottom, 20)
            .offset(y: UIScreen.main.bounds.height * 0.35)
            
            // Navigation arrows
            HStack {
                if selectedIndex > 0 {
                    Button(action: {
                        withAnimation(.interpolatingSpring(stiffness: 300, damping: 30)) {
                            selectedIndex -= 1
                        }
                    }) {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue.opacity(0.7))
                    }
                    .padding()
                }
                
                Spacer()
                
                if selectedIndex < vocabularies.count - 1 {
                    Button(action: {
                        withAnimation(.interpolatingSpring(stiffness: 300, damping: 30)) {
                            selectedIndex += 1
                        }
                    }) {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue.opacity(0.7))
                    }
                    .padding()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    WordDetailView(
        vocabularies: [/* sample vocabularies */],
        currentIndex: 0,
        selectedIndex: .constant(0),
        showimages: [/* sample image data */]
    )
}



