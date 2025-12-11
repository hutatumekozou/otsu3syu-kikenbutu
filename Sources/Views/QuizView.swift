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
    
    var body: some View {
        ZStack {
            // グラデーション背景
            // ★ 背景画像
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 20) {
                    if !questions.isEmpty {
                        // 問題番号表示
                        HStack {
                            Text("第\(currentQuestionIndex + 1)問")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Spacer()
                            Text("\(currentQuestionIndex + 1) / \(questions.count)")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20) // Add top padding inside ScrollView
                        
                        // 問題文
                        Text(questions[currentQuestionIndex].question)
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading) // Changed to leading for better readability of long text
                            .padding()
                            .frame(maxWidth: .infinity) // Ensure it takes full width
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        
                        // 選択肢
                        // MARK: - Fixed for Wrong Question Mode (Check actual content for MaruBatsu)
                        if questions[currentQuestionIndex].choices.contains("◯") {
                            HStack(spacing: 0) {
                                // ◯ Button (Index 0)
                                Button(action: {
                                    if selectedAnswer == nil {
                                        selectedAnswer = 0
                                        showExplanation = true
                                        
                                        if 0 == questions[currentQuestionIndex].answerIndex {
                                            // Correct Answer: Remove from wrong list
                                            WrongQuestionStore.shared.removeRecord(questionID: questions[currentQuestionIndex].id)
                                        } else {
                                            // Wrong Answer: Record it
                                            WrongQuestionStore.shared.recordWrong(questionID: questions[currentQuestionIndex].id)
                                        }
                                    }
                                }) {
                                    ZStack {
                                        Rectangle()
                                            .fill(Color(red: 0.9, green: 0.4, blue: 0.4)) // Red
                                        
                                        Circle()
                                            .stroke(Color.white, lineWidth: 8)
                                            .frame(width: 80, height: 80)
                                    }
                                    .frame(height: 200)
                                    .opacity(showExplanation && selectedAnswer != 0 ? 0.5 : 1.0)
                                }
                                .disabled(selectedAnswer != nil)
                                
                                // ✕ Button (Index 1)
                                Button(action: {
                                    if selectedAnswer == nil {
                                        selectedAnswer = 1
                                        showExplanation = true
                                        
                                        if 1 == questions[currentQuestionIndex].answerIndex {
                                            WrongQuestionStore.shared.removeRecord(questionID: questions[currentQuestionIndex].id)
                                        } else {
                                            WrongQuestionStore.shared.recordWrong(questionID: questions[currentQuestionIndex].id)
                                        }
                                    }
                                }) {
                                    ZStack {
                                        Rectangle()
                                            .fill(Color(red: 0.4, green: 0.4, blue: 0.9)) // Blue
                                        
                                        Image(systemName: "multiply")
                                            .resizable()
                                            .foregroundColor(.white)
                                            .frame(width: 80, height: 80)
                                    }
                                    .frame(height: 200)
                                    .opacity(showExplanation && selectedAnswer != 1 ? 0.5 : 1.0)
                                }
                                .disabled(selectedAnswer != nil)
                            }
                            .cornerRadius(20)
                            .padding(.horizontal)
                            .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(selectedAnswer != nil ? Color.black : Color.clear, lineWidth: 4)
                                    .padding(.horizontal)
                            )
                        } else {
                            VStack(spacing: 12) {
                                ForEach(0..<questions[currentQuestionIndex].choices.count, id: \.self) { index in
                                    Button(action: {
                                        if selectedAnswer == nil {
                                            selectedAnswer = index
                                            showExplanation = true
                                            
                                            // MARK: - Added for Wrong Question Mode
                                            if index == questions[currentQuestionIndex].answerIndex {
                                                WrongQuestionStore.shared.removeRecord(questionID: questions[currentQuestionIndex].id)
                                            } else {
                                                WrongQuestionStore.shared.recordWrong(questionID: questions[currentQuestionIndex].id)
                                            }
                                        }
                                    }) {
                                        HStack(alignment: .top, spacing: 12) {
                                            Text(questions[currentQuestionIndex].choices[index])
                                                .font(.body)
                                                .foregroundColor(.black)
                                                .multilineTextAlignment(.leading)
                                            Spacer()
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, minHeight: 50)
                                        .background(
                                            Group {
                                                if showExplanation {
                                                    if index == questions[currentQuestionIndex].answerIndex {
                                                        Color.green.opacity(0.3)
                                                    } else if index == selectedAnswer {
                                                        Color.red.opacity(0.3)
                                                    } else {
                                                        Color.white
                                                    }
                                                } else {
                                                    Color.white
                                                }
                                            }
                                        )
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
                        
                        // 正解・不正解表示と解説
                        if showExplanation {
                            VStack(spacing: 12) {
                                // 正解・不正解表示
                                let isCorrect = selectedAnswer == questions[currentQuestionIndex].answerIndex
                                Text(isCorrect ? "正解！" : "不正解")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(isCorrect ? .black : .red)
                                    .padding(.horizontal)
                                    
                                // MARK: - Added for Wrong Question Mode (Record Wrong Answer)
                                if !isCorrect {
                                    // Record wrong answer when explanation is shown (user made a choice)
                                    // Use a Task or simple sync call since it's just modifying a store
                                    // But we should ensure we only record it ONCE per question attempt.
                                    // showExplanation is toggle, but body is recomputed. 
                                    // Better to do this in the action that sets showExplanation = true.
                                }
                                
                                // 解説
                                Text(questions[currentQuestionIndex].explanation)
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading) // Changed to leading for better readability
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
                            .padding(.bottom, 40) // Add bottom padding for better scrolling experience
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(titleOverride ?? topic.title) // MARK: - Modified for Wrong Question Mode
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
    
    private func loadQuestions() {
        if let custom = customQuestions {
             questions = custom
        } else {
             questions = QuizRepository.shared.loadQuestions(for: topic)
        }
    }
    
    private func nextQuestion() {
        if let selected = selectedAnswer, selected == questions[currentQuestionIndex].answerIndex {
            correctAnswers += 1
        }
        
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswer = nil
            showExplanation = false
        } else {
            navigateToResult = true
        }
    }
}
