import SwiftUI

struct GridView: View {
    @Binding var guessedLetters: [[String]]
    let answers: [[String?]]
    let numberHints: [((Int, Int), Int)]
    let wordEntities: [Word] // 從 Core Data 加載的單詞實體

    @Binding var showAnswer: [[Bool]] // 控制答案顯示

    var body: some View {
        VStack {
            ForEach(0..<answers.count, id: \.self) { row in
                HStack {
                    ForEach(0..<answers[row].count, id: \.self) { col in
                        if answers[row][col] != nil { // 只顯示有答案的格子
                            
                            ZStack(alignment: .topTrailing) { // 將對齊設為右上角
                                if showAnswer[row][col] {
                                    if let answer = answers[row][col] {
                                        Text(answer)
                                            .font(.headline)
                                            .frame(width: 30, height: 30) // 設定框的大小
                                            .border(Color.black, width: 1) // 添加邊框
                                            .background(Color.white)
                                            .opacity(showAnswer[row][col] ? 1 : 0) // 使用透明度控制顯示
                                    }
                                }else {
                                    Text(guessedLetters[row][col])
                                        .font(.headline)
                                        .frame(width: 30, height: 30)
                                        .border(Color.black, width: 1)
                                        .background(Color.white)
                                }
                                
                                
                                // 在特定的格子中顯示數字
                               if let numberHint = numberHints.first(where: { $0.0 == (row, col) })?.1 {
                                   Text("\(numberHint)")
                                       .font(.system(size: 10))
                                        .foregroundColor(.red)
                                        .padding(2)
                                        .background(Color.white) 
                                        .border(Color.black, width: 1)
                                }
                                
                                
                                
                            }
                        } else {
                            Rectangle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.clear)
                        }
                    }
                }
            }
        }
    }
}
