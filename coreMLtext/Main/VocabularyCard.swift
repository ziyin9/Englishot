import SwiftUI

struct VocabularyCard: View {
    var vocabulary: Vocabulary
    var showimage: Data?
    
    @State private var isFavorite: Bool = false
    @State private var isHovered: Bool = false
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            Image("8")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 250)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
            
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .bottom) {
                    if let imageData = showimage, let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 160)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 0.5))
                            .offset(x: -8)
                            .rotation3DEffect(
                                .degrees(rotationAngle),
                                axis: (x: 0, y: 1, z: 0)
                            )
                            .scaleEffect(isHovered ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHovered)
                    }
                   
                    ZStack {
                        Image("icecube")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 130, height: 25)
                            .clipped()
                            .clipShape(Capsule())
                            .shadow(radius: 2)
                        
                        HStack {
                            Text(vocabulary.E_word.capitalized)
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding(.leading, 5)
                                .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                            
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    isFavorite.toggle()
                                    if isFavorite {
                                        rotationAngle += 360
                                    }
                                }
                            }) {
                                Image(systemName: isFavorite ? "star.fill" : "star")
                                    .foregroundColor(isFavorite ? .yellow : .white)
                                    .padding(2)
                                    .background(Color.clear)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .offset(y: 30)
                }
                .offset(y: 25)
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isHovered.toggle()
            }
        }
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    VocabularyCard(
        vocabulary: Vocabulary(
            category: "Kitchen",
            E_word: "apple",
            C_word: "蘋果",
            exSentence: "I eat an apple every day.",
            audioURL: "https://example.com/apple.mp3",
            assetName: "apple_image"
        )
    )
}
