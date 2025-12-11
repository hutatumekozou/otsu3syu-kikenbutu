import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            // 背景色（余白用）
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            // 背景画像（全体が見えるようにFitさせる）
            GeometryReader { geo in
                Image("LaunchBackground")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            }
            .ignoresSafeArea()
        }
    }
}


struct HomeView: View {
    // Removed direct EnvironmentObject dependency to prevent full redraws
    
    var body: some View {
        NavigationView {
            ZStack {
                // ★ 背景画像
                BackgroundView()
                
                VStack(spacing: 20) {
                    // タイトルセクション
                    titleSection
                    
                    // 章選択ボタン
                    ScrollView {
                        VStack(spacing: 24) {
                            
                            // MARK: - Added Wrong Questions Button (Isolated)
                            WrongQuestionsSection()

                            ForEach(QuizChapter.allCases) { chapter in
                                NavigationLink(destination: ChapterView(chapter: chapter)) {
                                    chapterButton(for: chapter)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                AdsManager.shared.preload()
            }
        }
    }
    
    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("福祉住環境")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text("コーディネーター2級")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text("問題集")
                .font(.system(size: 48, weight: .bold))
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
        .padding(.top, 40)
    }
    
    private func chapterButton(for chapter: QuizChapter) -> some View {
        Text(chapter.title)
            .font(.system(size: 28, weight: .bold)) // Larger font for main menu
            .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
            .frame(maxWidth: .infinity, minHeight: 120) // Large buttons
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: 4)
    }
    
    // Logic moved to WrongQuestionsSection
}

struct WrongQuestionsSection: View {
    @State private var showWrongQuiz = false
    @State private var showNoQuestions = false
    @State private var wrongQuestionsForQuiz: [Question] = []
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: startWrongQuiz) {
                Text("間違えた問題")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .background(Color(red: 0.9, green: 0.4, blue: 0.4)) // Reddish
                    .cornerRadius(20)
                    .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
            .background(
                Group {
                    NavigationLink(
                        destination: QuizView(topic: .coordinator1, customQuestions: wrongQuestionsForQuiz, titleOverride: "間違えた問題"),
                        isActive: $showWrongQuiz,
                        label: { EmptyView() }
                    )
                    NavigationLink(
                        destination: NoWrongQuestionsView(),
                        isActive: $showNoQuestions,
                        label: { EmptyView() }
                    )
                }
            )
            
            // Debug/Reset Button
            Button(action: {
                WrongQuestionStore.shared.clearAll()
            }) {
                Image(systemName: "trash.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white.opacity(0.8))
                    .background(Circle().fill(Color.black.opacity(0.2)))
            }
            .padding(12)
        }
    }
    
    private func startWrongQuiz() {
        let wrongIDs = WrongQuestionStore.shared.sortedWrongQuestionIDs()
        
        if wrongIDs.isEmpty {
            // No wrong questions found
            showNoQuestions = true
            return
        }
        
        var allQuestions: [Question] = []
        for topic in QuizTopic.allCases {
            allQuestions.append(contentsOf: QuizRepository.shared.loadAllQuestions(for: topic))
        }
        
        let questionMap = Dictionary(grouping: allQuestions, by: { $0.id }).compactMapValues { $0.first }
        
        var ordered: [Question] = []
        for id in wrongIDs {
            if let q = questionMap[id] {
                ordered.append(q)
            }
        }
        
        if ordered.isEmpty {
            // IDs exist but questions not found (rare edge case)
            showNoQuestions = true
        } else {
            wrongQuestionsForQuiz = Array(ordered.prefix(20))
            showWrongQuiz = true
        }
    }
}

// MARK: - No Wrong Questions View
struct NoWrongQuestionsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 40) {
                Text("素晴らしい！")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("現在、間違えた問題はありません。\n引き続き学習を頑張りましょう！")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("トップに戻る")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(Color(red: 0.2, green: 0.4, blue: 0.8))
                        .cornerRadius(15)
                }
                .padding(.horizontal, 40)
            }
        }
        .navigationBarHidden(true)
    }
}

struct ChapterView: View {
    let chapter: QuizChapter
    // Removed EnvironmentObject to prevent redraw on store update
    
    var body: some View {
        ZStack {
            // グラデーション背景 (HomeViewと同じ)
            // ★ 背景画像 (HomeViewと同じ)
            BackgroundView()
            
            VStack(spacing: 20) {
                // タイトル
                Text("\(chapter.title)メニュー")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                // クイズボタングリッド
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(chapter.topics) { topic in
                            NavigationLink(destination: 
                                QuizView(topic: topic)
                                    // Removed explicit environmentObject passing as it causes implicit dependency issues and is redundant
                            ) {
                                Text(topic.title)
                                    .font(.headline)
                                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                                    .frame(maxWidth: .infinity, minHeight: 72)
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
