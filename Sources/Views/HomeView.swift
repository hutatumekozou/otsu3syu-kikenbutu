import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // グラデーション背景
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.6, green: 0.8, blue: 1.0),
                        Color(red: 0.4, green: 0.6, blue: 0.9)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // タイトルセクション
                    titleSection
                    
                    // 章選択ボタン
                    ScrollView {
                        VStack(spacing: 24) {
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
}

struct ChapterView: View {
    let chapter: QuizChapter
    
    var body: some View {
        ZStack {
            // グラデーション背景 (HomeViewと同じ)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.6, green: 0.8, blue: 1.0),
                    Color(red: 0.4, green: 0.6, blue: 0.9)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
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
                            NavigationLink(destination: QuizView(topic: topic)) {
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
