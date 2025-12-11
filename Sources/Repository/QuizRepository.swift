import Foundation

class QuizRepository: ObservableObject {
    static let shared = QuizRepository()
    
    private init() {}
    
    func loadQuestions(for topic: QuizTopic) -> [Question] {
        guard let url = Bundle.main.url(forResource: topic.fileName, withExtension: "json", subdirectory: "questions"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load questions for \(topic.fileName)")
            return []
        }
        
        do {
            let allQuestions = try JSONDecoder().decode([Question].self, from: data)
            let filtered = allQuestions.filter { $0.category == topic.category }
            let source = filtered.isEmpty ? allQuestions : filtered
            if filtered.isEmpty {
                print("Warning: No category match for \(topic.category). Falling back to full question set.")
            }
            
            let shuffled = source.shuffled()
            let limit = topic.isMaruBatsu ? 12 : 10
            return Array(shuffled.prefix(min(limit, shuffled.count)))
        } catch {
            print("Decoding error for \(topic.fileName): \(error)")
            return []
        }
    }
    func loadAllQuestions(for topic: QuizTopic) -> [Question] {
        guard let url = Bundle.main.url(forResource: topic.fileName, withExtension: "json", subdirectory: "questions"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load questions for \(topic.fileName)")
            return []
        }
        
        do {
            let allQuestions = try JSONDecoder().decode([Question].self, from: data)
            let filtered = allQuestions.filter { $0.category == topic.category }
            if filtered.isEmpty {
                // Return all if category filtering yields nothing (some JSONs might not use category field properly yet)
                // But generally we expect filtered.
                // If filtered is empty but we have questions, check if we should return all
                 if !allQuestions.isEmpty {
                     // print("Warning: No category match for \(topic.category). Returning all questions.")
                     return allQuestions
                 }
            }
            return filtered
        } catch {
            print("Decoding error for \(topic.fileName): \(error)")
            return []
        }
    }
}
