import Foundation
import SwiftUI

enum QuizTopic: CaseIterable, Identifiable {
    case coordinator1
    case coordinator2
    case health1
    case health2
    case counseling1
    case counseling2
    case environment1
    case environment2
    case welfare1
    case welfare2
    case marubatsuElderlyDisabled
    case marubatsuElderlyDisabled2
    case marubatsuElderlyDisabled3
    case selectionElderlyDisabled
    case marubatsuHealthDisabilities
    case marubatsuHealthDisabilities2
    case marubatsuHealthDisabilities3
    case selectionHealthDisabilities
    case selectionHealthDisabilities2
    
    var id: String { category }
    
    var title: String { category }
    
    var category: String {
        switch self {
        case .coordinator1: return "福祉住環境コーディネーターの役割 1"
        case .coordinator2: return "福祉住環境コーディネーターの役割 2"
        case .health1:      return "疾患・障害別住環境整備 1"
        case .health2:      return "疾患・障害別住環境整備 2"
        case .counseling1:  return "相談援助技術 1"
        case .counseling2:  return "相談援助技術 2"
        case .environment1: return "住環境整備の技術 1"
        case .environment2: return "住環境整備の技術 2"
        case .welfare1:     return "福祉用具の活用 1"
        case .welfare2:     return "福祉用具の活用 2"
        case .marubatsuElderlyDisabled: return "【◯✖️】高齢者障害者"
        case .marubatsuElderlyDisabled2: return "【◯✖️】高齢者障害者2"
        case .marubatsuElderlyDisabled3: return "【◯✖️】高齢者障害者3"
        case .selectionElderlyDisabled: return "選択 高齢者障害者"
        case .marubatsuHealthDisabilities: return "【◯✖️】健康・障害"
        case .marubatsuHealthDisabilities2: return "🩷【◯✖️】健康・障害2"
        case .marubatsuHealthDisabilities3: return "【◯✖️】健康・障害3"
        case .selectionHealthDisabilities: return "【選択】健康・障害"
        case .selectionHealthDisabilities2: return "【選択】健康・障害2"
        }
    }
    
    var fileName: String {
        switch self {
        case .coordinator1: return "coordinator_1"
        case .coordinator2: return "coordinator_2"
        case .health1:      return "health_1"
        case .health2:      return "health_2"
        case .counseling1:  return "counseling_1"
        case .counseling2:  return "counseling_2"
        case .environment1: return "environment_1"
        case .environment2: return "environment_2"
        case .welfare1:     return "welfare_1"
        case .welfare2:     return "welfare_2"
        case .marubatsuElderlyDisabled: return "marubatsu_elderly_disabled"
        case .marubatsuElderlyDisabled2: return "marubatsu_elderly_disabled_2"
        case .marubatsuElderlyDisabled3: return "marubatsu_elderly_disabled_3"
        case .selectionElderlyDisabled: return "selection_elderly_disabled"
        case .marubatsuHealthDisabilities: return "marubatsu_health_disabilities"
        case .marubatsuHealthDisabilities2: return "marubatsu_health_disabilities_2"
        case .marubatsuHealthDisabilities3: return "marubatsu_health_disabilities_3"
        case .selectionHealthDisabilities: return "selection_health_disability"
        case .selectionHealthDisabilities2: return "selection_health_disability_2"
        }
    }
    
    var isMaruBatsu: Bool {
        switch self {
        case .marubatsuElderlyDisabled, .marubatsuElderlyDisabled2, .marubatsuElderlyDisabled3, .marubatsuHealthDisabilities, .marubatsuHealthDisabilities2, .marubatsuHealthDisabilities3:
            return true
        default:
            return false
        }
    }
}

enum QuizChapter: String, CaseIterable, Identifiable {
    case general = "総合"
    case elderly = "①高齢者障害者"
    case health = "②健康・障害"
    
    var id: String { rawValue }
    
    var title: String { rawValue }
    
    var topics: [QuizTopic] {
        switch self {
        case .general:
            return [
                .coordinator1, .coordinator2,
                .health1, .health2,
                .counseling1, .counseling2,
                .environment1, .environment2,
                .welfare1, .welfare2
            ]
        case .elderly:
            return [
                .marubatsuElderlyDisabled,
                .marubatsuElderlyDisabled2,
                .marubatsuElderlyDisabled3,
                .selectionElderlyDisabled
            ]
        case .health:
            return [
                .marubatsuHealthDisabilities,
                .marubatsuHealthDisabilities2,
                .marubatsuHealthDisabilities3,
                .selectionHealthDisabilities,
                .selectionHealthDisabilities2
            ]
        }
    }
    
    var color: Color {
        switch self {
        case .general:
            return Color(red: 0.2, green: 0.4, blue: 0.8) // Blue-ish
        case .elderly:
            return Color(red: 0.8, green: 0.4, blue: 0.2) // Orange-ish (Just to differentiate if needed, or stick to theme)
        case .health:
            return Color(red: 0.2, green: 0.6, blue: 0.4) // Green-ish
        }
    }
}
