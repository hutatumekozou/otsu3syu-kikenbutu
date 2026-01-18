import SwiftUI

struct QuizView: View {
    let topic: QuizTopic
    var customQuestions: [Question]? = nil   // MARK: - Added for Wrong Question Mode
    var titleOverride: String? = nil         // MARK: - Added for Wrong Question Mode
    
    // EnvironmentObject removed in favor of Singleton to prevent redraws
    
    @State private var questions: [Question] = []
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showExplanation = false
    @State private var correctAnswers = 0
    @State private var navigateToResult = false
    @State private var isBookmarked = false // Local state to reflect store
    
    private func toggleBookmark() {
        let currentID = questions[currentQuestionIndex].id
        BookmarkQuestionStore.shared.toggleBookmark(questionID: currentID)
        isBookmarked = BookmarkQuestionStore.shared.isBookmarked(questionID: currentID)
    }
    
    private func updateBookmarkState() {
        if questions.indices.contains(currentQuestionIndex) {
            let currentID = questions[currentQuestionIndex].id
            isBookmarked = BookmarkQuestionStore.shared.isBookmarked(questionID: currentID)
        }
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                if !questions.isEmpty {
                    ScrollView {
                        VStack(spacing: 20) {
                            questionHeaderView
                            questionTextView
                            answerButtonsSection
                            explanationSection
                        }
                    }
                } else {
                    Spacer() // To push banner down if empty
                }
                
                // 広告バナー
                BannerView()
                    .frame(height: 50)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(titleOverride ?? topic.title)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadQuestions()
        }
        .background(
            NavigationLink(
                destination: ResultView(topic: topic, correctAnswers: correctAnswers, totalQuestions: questions.count),
                isActive: $navigateToResult,
                label: { EmptyView() }
            )
        )
    }

    private var questionHeaderView: some View {
        HStack {
            Text("第\(currentQuestionIndex + 1)問")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            // Bookmark Button
            Button(action: toggleBookmark) {
                Image(systemName: isBookmarked ? "star.fill" : "star")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(isBookmarked ? .yellow : .gray)
            }
            .padding(.leading, 8)
            
            Spacer()
            Text("\(currentQuestionIndex + 1) / \(questions.count)")
                .font(.headline)
                .foregroundColor(.black)
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
    
    private var questionTextView: some View {
        VStack(spacing: 12) {
            Text(questions[currentQuestionIndex].question)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
            
            if let imageName = questions[currentQuestionIndex].imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var answerButtonsSection: some View {
        Group {
            if questions[currentQuestionIndex].choices.contains("◯") {
                maruBatsuButtons
            } else {
                listAnswerButtons
            }
        }
    }
    
    private var maruBatsuButtons: some View {
        HStack(spacing: 0) {
            // ◯ Button (Index 0)
            Button(action: { handleAnswer(0) }) {
                ZStack {
                    Rectangle()
                        .fill(Color(red: 231/255, green: 98/255, blue: 95/255))
                    Circle()
                        .stroke(Color.white, lineWidth: 10)
                        .frame(width: 80, height: 80)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .overlay(
                    Rectangle()
                        .fill(Color.black.opacity(showExplanation && selectedAnswer != 0 ? 0.4 : 0.0))
                )
            }
            .disabled(selectedAnswer != nil)
            
            // ✕ Button (Index 1)
            Button(action: { handleAnswer(1) }) {
                ZStack {
                    Rectangle()
                        .fill(Color(red: 93/255, green: 101/255, blue: 208/255))
                    Image(systemName: "multiply")
                        .resizable()
                        .font(Font.system(size: 80, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .overlay(
                     Rectangle()
                         .fill(Color.black.opacity(showExplanation && selectedAnswer != 1 ? 0.4 : 0.0))
                 )
            }
            .disabled(selectedAnswer != nil)
        }
        .cornerRadius(20)
        .padding(.horizontal)
        .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(selectedAnswer != nil ? Color.white : Color.clear, lineWidth: 4)
                .padding(.horizontal)
        )
    }
    
    private var listAnswerButtons: some View {
        VStack(spacing: 12) {
            ForEach(0..<questions[currentQuestionIndex].choices.count, id: \.self) { index in
                Button(action: { handleAnswer(index) }) {
                    HStack(alignment: .top, spacing: 12) {
                        Text(questions[currentQuestionIndex].choices[index])
                            .font(.body)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(answerBackground(at: index))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
                .disabled(selectedAnswer != nil)
            }
        }
        .padding(.horizontal)
    }
    
    private func handleAnswer(_ index: Int) {
        if selectedAnswer == nil {
            selectedAnswer = index
            showExplanation = true
            
            if index == questions[currentQuestionIndex].answerIndex {
                WrongQuestionStore.shared.removeRecord(questionID: questions[currentQuestionIndex].id)
            } else {
                WrongQuestionStore.shared.recordWrong(questionID: questions[currentQuestionIndex].id)
            }
        }
    }
    
    private func answerBackground(at index: Int) -> Color {
        if showExplanation {
            if index == questions[currentQuestionIndex].answerIndex {
                return Color.green.opacity(0.3)
            } else if index == selectedAnswer {
                return Color.red.opacity(0.3)
            }
        }
        return Color.white
    }
    
    @ViewBuilder
    private var explanationSection: some View {
        if showExplanation {
            VStack(spacing: 12) {
                let isCorrect = selectedAnswer == questions[currentQuestionIndex].answerIndex
                Text(isCorrect ? "正解！" : "不正解")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(isCorrect ? .black : .red)
                    .padding(.horizontal)
                
                Text(questions[currentQuestionIndex].explanation)
                    .font(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            
            Button(action: nextQuestion) {
                Text(currentQuestionIndex == questions.count - 1 ? "結果を見る" : "次の問題")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color(red: 0.2, green: 0.4, blue: 0.8))
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }
    
    private func loadQuestions() {
        if let custom = customQuestions {
             questions = custom
        } else {
             questions = QuizRepository.shared.loadQuestions(for: topic)
        }
        updateBookmarkState()
    }
    
    private func nextQuestion() {
        if let selected = selectedAnswer, selected == questions[currentQuestionIndex].answerIndex {
            correctAnswers += 1
        }
        
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswer = nil
            showExplanation = false
            updateBookmarkState()
        } else {
            navigateToResult = true
        }
    }
}
