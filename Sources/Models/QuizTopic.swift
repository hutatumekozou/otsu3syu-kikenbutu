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
    case marubatsuLivingEnvironment
    case selectionLivingEnvironment
    case frequentQuestion1
    case frequentQuestion2
    case frequentQuestion3
    case frequentQuestion4
    case frequentQuestion5
    case basicQuestionsPart1
    case basicQuestionsPart2
    case basicQuestionsPart3
    case basicQuestionsPart4
    case basicQuestionsPart5



    case class1Genre1
    case class1Genre2
    case class1Genre3
    case class1Genre4
    case class1Genre5
    case class1Genre6
    case class1Genre7
    case class1Genre8
    case class1Genre9
    case class1Genre10
    
    // MARK: - Class 2 (乙2)
    case class2Genre1
    case class2Genre2
    case class2Genre3
    case class2Genre4
    case class2Genre5
    case class2Genre6
    case class2Genre7
    case class2Genre8
    case class2Genre9
    case class2Genre10
    
    // MARK: - Class 3 (乙3)
    case class3Genre1
    case class3Genre2
    case class3Genre3
    case class3Genre4
    case class3Genre5
    case class3Genre6
    case class3Genre7
    case class3Genre8
    case class3Genre9
    case class3Genre10
    case class3Genre11
    case class3Genre12
    case class3Genre13
    
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
        case .marubatsuLivingEnvironment: return "【◯✖️】住環境整備"
        case .selectionLivingEnvironment: return "【選択】住環境整備"
        case .frequentQuestion1: return "よく出る問題 1"
        case .frequentQuestion2: return "よく出る問題 2"
        case .frequentQuestion3: return "よく出る問題 3"
        case .frequentQuestion4: return "よく出る問題 4"
        case .frequentQuestion5: return "よく出る問題 5"
        case .basicQuestionsPart1: return "問題1-10"
        case .basicQuestionsPart2: return "問題11-20"
        case .basicQuestionsPart3: return "問題21-30"
        case .basicQuestionsPart4: return "問題31-40"
        case .basicQuestionsPart5: return "問題41-50"
        case .class1Genre1: return "1-10 共通性質と火災予防"
        case .class1Genre2: return "11-20 塩素酸塩類"
        case .class1Genre3: return "21-30 過塩素酸塩類"
        case .class1Genre4: return "31-40 無機過酸化物"
        case .class1Genre5: return "41-50 亜塩素酸塩類"
        case .class1Genre6: return "51-60 硝酸塩類"
        case .class1Genre7: return "61-70 過マンガン酸塩類"
        case .class1Genre8: return "71-80 重クロム酸塩類"
        case .class1Genre9: return "81-90 ハロゲン酸塩類"
        case .class1Genre10: return "91-100 法令・実務"
            
        // Class 2
        case .class2Genre1: return "1-10 危険物の性状"
        case .class2Genre2: return "11-20 火災予防と貯蔵"
        case .class2Genre3: return "21-30 消火方法"
        case .class2Genre4: return "31-40 硫化リン"
        case .class2Genre5: return "41-50 赤リン"
        case .class2Genre6: return "51-60 硫黄"
        case .class2Genre7: return "61-70 鉄粉"
        case .class2Genre8: return "71-80 金属粉・マグネシウム"
        case .class2Genre9: return "81-90 引火性固体"
        case .class2Genre10: return "91-100 法令・指定数量"
            
        // Class 3
        case .class3Genre1: return "1-10 乙3類総論・共通特性"
        case .class3Genre2: return "11-25 アルカリ金属"
        case .class3Genre3: return "26-35 アルカリ土類・有機金属"
        case .class3Genre4: return "36-55 黄リン（自然発火性）1"
        case .class3Genre5: return "56-60 黄リン（自然発火性）2"
        case .class3Genre6: return "61-80 金属炭化物・水素化物 1"
        case .class3Genre7: return "81-95 金属炭化物・水素化物 2"
        case .class3Genre8: return "96-115 リン化物・特殊物質 1"
        case .class3Genre9: return "116-120 リン化物・特殊物質 2"
        case .class3Genre10: return "121-140 消火理論・保管規則 1"
        case .class3Genre11: return "141-160 消火理論・保管規則 2"
        case .class3Genre12: return "161-180 消火理論・保管規則 3"
        case .class3Genre13: return "181-200 消火理論・保管規則 4"
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
        case .marubatsuLivingEnvironment: return "marubatsu_living_environment"
        case .selectionLivingEnvironment: return "selection_living_environment"
        case .frequentQuestion1: return "frequent_question_1"
        case .frequentQuestion2: return "frequent_question_2"
        case .frequentQuestion3: return "frequent_question_3"
        case .frequentQuestion4: return "frequent_question_4"
        case .frequentQuestion5: return "frequent_question_5"
        case .basicQuestionsPart1: return "basic_questions_part1"
        case .basicQuestionsPart2: return "basic_questions_part2"
        case .basicQuestionsPart3: return "basic_questions_part3"
        case .basicQuestionsPart4: return "basic_questions_part4"
        case .basicQuestionsPart5: return "basic_questions_part5"
        case .class1Genre1: return "class1_genre1"
        case .class1Genre2: return "class1_genre2"
        case .class1Genre3: return "class1_genre3"
        case .class1Genre4: return "class1_genre4"
        case .class1Genre5: return "class1_genre5"
        case .class1Genre6: return "class1_genre6"
        case .class1Genre7: return "class1_genre7"
        case .class1Genre8: return "class1_genre8"
        case .class1Genre9: return "class1_genre9"
        case .class1Genre10: return "class1_genre10"
            
        case .class2Genre1: return "class2_genre1"
        case .class2Genre2: return "class2_genre2"
        case .class2Genre3: return "class2_genre3"
        case .class2Genre4: return "class2_genre4"
        case .class2Genre5: return "class2_genre5"
        case .class2Genre6: return "class2_genre6"
        case .class2Genre7: return "class2_genre7"
        case .class2Genre8: return "class2_genre8"
        case .class2Genre9: return "class2_genre9"
        case .class2Genre10: return "class2_genre10"
            
        case .class3Genre1: return "class3_g1_general"
        case .class3Genre2: return "class3_g2_alkali_metals"
        case .class3Genre3: return "class3_g3_earth_metals"
        case .class3Genre4: return "class3_g4_phosphorus_1"
        case .class3Genre5: return "class3_g4_phosphorus_2"
        case .class3Genre6: return "class3_g5_carbides_1"
        case .class3Genre7: return "class3_g5_carbides_2"
        case .class3Genre8: return "class3_g6_phosphides_1"
        case .class3Genre9: return "class3_g6_phosphides_2"
        case .class3Genre10: return "class3_g7_fire_theory_1"
        case .class3Genre11: return "class3_g7_fire_theory_2"
        case .class3Genre12: return "class3_g7_fire_theory_3"
        case .class3Genre13: return "class3_g7_fire_theory_4"
        }
    }
    
    var isMaruBatsu: Bool {
        switch self {
        case .marubatsuElderlyDisabled, .marubatsuElderlyDisabled2, .marubatsuElderlyDisabled3, .marubatsuHealthDisabilities, .marubatsuHealthDisabilities2, .marubatsuHealthDisabilities3, .marubatsuLivingEnvironment, .frequentQuestion1, .frequentQuestion2, .frequentQuestion3, .frequentQuestion4, .frequentQuestion5, .basicQuestionsPart1, .basicQuestionsPart2, .basicQuestionsPart3, .basicQuestionsPart4, .basicQuestionsPart5:



            return true
        default:
            return false
        }
    }
    var startQuestionNumber: Int {
        switch self {
        case .class1Genre1: return 1
        case .class1Genre2: return 11
        case .class1Genre3: return 21
        case .class1Genre4: return 31
        case .class1Genre5: return 41
        case .class1Genre6: return 51
        case .class1Genre7: return 61
        case .class1Genre8: return 71
        case .class1Genre9: return 81
        case .class1Genre10: return 91
            
        case .class2Genre1: return 1
        case .class2Genre2: return 11
        case .class2Genre3: return 21
        case .class2Genre4: return 31
        case .class2Genre5: return 41
        case .class2Genre6: return 51
        case .class2Genre7: return 61
        case .class2Genre8: return 71
        case .class2Genre9: return 81
        case .class2Genre10: return 91
            
        case .class3Genre1: return 1
        case .class3Genre2: return 11
        case .class3Genre3: return 26
        case .class3Genre4: return 36
        case .class3Genre5: return 56
        case .class3Genre6: return 61
        case .class3Genre7: return 81
        case .class3Genre8: return 96
        case .class3Genre9: return 116
        case .class3Genre10: return 121
        case .class3Genre11: return 141
        case .class3Genre12: return 161
        case .class3Genre13: return 181
        default: return 1
        }
    }
}

enum QuizChapter: String, CaseIterable, Identifiable {
    // case class1 = "危険物乙1類" // Removed per user request
    case class2 = "危険物乙2類"
    case class3 = "危険物乙3類"

    
    var id: String { rawValue }
    
    var title: String { rawValue }
    
    var topics: [QuizTopic] {
        switch self {
            /*
        case .class1:
            return [
                .class1Genre1,
                .class1Genre2,
                .class1Genre3,
                .class1Genre4,
                .class1Genre5,
                .class1Genre6,
                .class1Genre7,
                .class1Genre8,
                .class1Genre9,
                .class1Genre10
            ]
             */
        case .class2:
            return [
                .class2Genre1,
                .class2Genre2,
                .class2Genre3,
                .class2Genre4,
                .class2Genre5,
                .class2Genre6,
                .class2Genre7,
                .class2Genre8,
                .class2Genre9,
                .class2Genre10
            ]
        case .class3:
            return [
                .class3Genre1,
                .class3Genre2,
                .class3Genre3,
                .class3Genre4,
                .class3Genre5,
                .class3Genre6,
                .class3Genre7,
                .class3Genre8,
                .class3Genre9,
                .class3Genre10,
                .class3Genre11,
                .class3Genre12,
                .class3Genre13
            ]
        }
    }
    
    var color: Color {
        switch self {
        // case .class1:
            // return Color(red: 0.9, green: 0.3, blue: 0.2)
        case .class2:
            return Color(red: 0.2, green: 0.4, blue: 0.8) // Blue for Class 2
        case .class3:
            return Color(red: 0.2, green: 0.6, blue: 0.3) // Green for Class 3
        }
    }
}
