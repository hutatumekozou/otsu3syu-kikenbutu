import Foundation
import SwiftUI

struct Question: Codable, Identifiable {
    let id: String
    let category: String
    let question: String
    let choices: [String]
    let answerLabel: String
    let answerIndex: Int
    let explanation: String
    let imageName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case category
        case question
        case text
        case choices
        case answerLabel = "answer_label"
        case answerIndex = "answer_index"
        case correct
        case explanation
        case imageName = "image_name"
    }
    
    init(
        id: String = UUID().uuidString,
        category: String = "未分類",
        question: String,
        choices: [String],
        answerLabel: String? = nil,
        answerIndex: Int,
        explanation: String,
        imageName: String? = nil
    ) {
        self.id = id
        self.category = category
        self.question = question
        self.choices = choices
        self.answerIndex = answerIndex
        self.answerLabel = answerLabel ?? Question.label(for: answerIndex)
        self.explanation = explanation
        self.imageName = imageName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let questionText = try container.decodeIfPresent(String.self, forKey: .question)
            ?? container.decodeIfPresent(String.self, forKey: .text)
        guard let questionTextUnwrapped = questionText else {
            throw DecodingError.dataCorruptedError(forKey: .question, in: container, debugDescription: "Missing question text.")
        }
        
        let choices = try container.decode([String].self, forKey: .choices)
        guard choices.count == 2 || choices.count == 4 else {
            throw DecodingError.dataCorruptedError(forKey: .choices, in: container, debugDescription: "choices must contain exactly 2 or 4 entries.")
        }
        
        let answerIndex = try container.decodeIfPresent(Int.self, forKey: .answerIndex)
            ?? container.decodeIfPresent(Int.self, forKey: .correct)
        guard let answerIndexUnwrapped = answerIndex else {
            throw DecodingError.dataCorruptedError(forKey: .answerIndex, in: container, debugDescription: "Missing answer index.")
        }
        guard (0..<choices.count).contains(answerIndexUnwrapped) else {
            throw DecodingError.dataCorruptedError(forKey: .answerIndex, in: container, debugDescription: "answer_index must be between 0 and \(choices.count - 1).")
        }
        
        let decodedLabel = try container.decodeIfPresent(String.self, forKey: .answerLabel)
        let derivedLabel = Question.label(for: answerIndexUnwrapped)
        if let decodedLabel, decodedLabel != derivedLabel {
            throw DecodingError.dataCorruptedError(forKey: .answerLabel, in: container, debugDescription: "answer_label \(decodedLabel) does not match answer_index \(answerIndexUnwrapped).")
        }
        
        if let id = try container.decodeIfPresent(String.self, forKey: .id) {
            self.id = id
        } else {
             self.id = questionTextUnwrapped // Fallback to question text as ID
        }
        self.category = try container.decodeIfPresent(String.self, forKey: .category) ?? "未分類"
        self.question = questionTextUnwrapped
        self.choices = choices
        self.answerIndex = answerIndexUnwrapped
        self.answerLabel = decodedLabel ?? derivedLabel
        self.explanation = try container.decode(String.self, forKey: .explanation)
        self.imageName = try container.decodeIfPresent(String.self, forKey: .imageName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(category, forKey: .category)
        try container.encode(question, forKey: .question)
        try container.encode(choices, forKey: .choices)
        try container.encode(answerLabel, forKey: .answerLabel)
        try container.encode(answerIndex, forKey: .answerIndex)
        try container.encode(explanation, forKey: .explanation)
        try container.encode(imageName, forKey: .imageName)
    }
    
    private static func label(for index: Int) -> String {
        let labels = ["A", "B", "C", "D"]
        return labels.indices.contains(index) ? labels[index] : ""
    }
}

// MARK: - WrongQuestionStore
// Added here to ensure availability in the target scope without editing project.pbxproj directly.

struct WrongQuestionRecord: Codable, Identifiable {
    let id: String              // Question.id と対応 (Existing Question uses String id)
    var lastWrongDate: Date     // 最後に間違えた日時
    var timesWrong: Int         // 間違えた回数
}

final class WrongQuestionStore: ObservableObject {
    static let shared = WrongQuestionStore()
    @Published private(set) var records: [WrongQuestionRecord] = []
    
    private let storageKey = "WrongQuestionRecords"
    
    init() {
        load()
    }
    
    func recordWrong(questionID: String) {
        if let index = records.firstIndex(where: { $0.id == questionID }) {
            records[index].timesWrong += 1
            records[index].lastWrongDate = Date()
        } else {
            let new = WrongQuestionRecord(id: questionID,
                                          lastWrongDate: Date(),
                                          timesWrong: 1)
            records.append(new)
        }
        save()
    }
    
    func removeRecord(questionID: String) {
        if let index = records.firstIndex(where: { $0.id == questionID }) {
            records.remove(at: index)
            save()
        }
    }
    
    func clearAll() {
        records.removeAll()
        save()
    }
    
    func sortedWrongQuestionIDs() -> [String] {
        records
            .sorted { $0.lastWrongDate < $1.lastWrongDate } // 古い順 (Oldest first)
            .map { $0.id }
    }
    
    private func load() {
        let defaults = UserDefaults.standard
        guard let data = defaults.data(forKey: storageKey) else { return }
        if let decoded = try? JSONDecoder().decode([WrongQuestionRecord].self, from: data) {
            records = decoded
        }
    }
    
    private func save() {
        let defaults = UserDefaults.standard
        if let data = try? JSONEncoder().encode(records) {
            defaults.set(data, forKey: storageKey)
        }
    }
}

// MARK: - BookmarkQuestionStore
// To manage bookmarked questions

final class BookmarkQuestionStore: ObservableObject {
    static let shared = BookmarkQuestionStore()
    @Published private(set) var bookmarkedIDs: Set<String> = []
    
    private let storageKey = "BookmarkedQuestionIDs"
    
    init() {
        load()
    }
    
    func isBookmarked(questionID: String) -> Bool {
        bookmarkedIDs.contains(questionID)
    }
    
    func toggleBookmark(questionID: String) {
        if bookmarkedIDs.contains(questionID) {
            bookmarkedIDs.remove(questionID)
        } else {
            bookmarkedIDs.insert(questionID)
        }
        save()
    }
    
    func sortedBookmarkedQuestionIDs() -> [String] {
        // Return IDs sorted alphabetically to keep order consistent, or maybe better by insertion order if we tracked it?
        // Set doesn't keep order. For simplicity, just sort by ID for stable output.
        // User probably wants them in some order, but "Sorted by ID" is a reasonable default 
        // given we don't have "date added" here (unless we change struct).
        // Since the prompt just says "bookmarked questions", ID sort is fine.
        return Array(bookmarkedIDs).sorted()
    }
    
    private func load() {
        let defaults = UserDefaults.standard
        if let array = defaults.array(forKey: storageKey) as? [String] {
            bookmarkedIDs = Set(array)
        }
    }
    
    private func save() {
        let defaults = UserDefaults.standard
        defaults.set(Array(bookmarkedIDs), forKey: storageKey)
    }
}
