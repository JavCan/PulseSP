import SwiftUI

// MARK: - Enums

enum RoutineTheme {
    case morning, evening, sleep
    
    var backgroundColor: Color {
        switch self {
        case .morning: return Color.GlaciarBlue
        case .evening: return Color.DarkClay
        case .sleep:   return Color(red: 0.1, green: 0.13, blue: 0.2)
        }
    }
    
    var cardBackground: Color {
        switch self {
        case .morning: return Color.VibrantMorningBlue
        case .evening: return Color.DuskOrange
        case .sleep:   return Color(red: 0.14, green: 0.17, blue: 0.26)
        }
    }
    
    var textColor: Color {
        switch self {
        case .morning:           return Color.Clay
        case .evening:           return Color.SoftEveningOrange
        case .sleep:             return Color.white.opacity(0.9)
        }
    }
    
    var accentColor: Color {
        switch self {
        case .morning: return Color.SalviaGreen
        case .evening: return Color.DeepEveningOrange
        case .sleep:   return Color.RelaxLavanda
        }
    }
    
    var subtleTextColor: Color {
        switch self {
        case .morning:           return Color.Clay.opacity(0.6)
        case .evening:           return Color.SoftEveningOrange.opacity(0.7)
        case .sleep:             return Color.white.opacity(0.4)
        }
    }
}

// MARK: - Data Models

struct RoutinePhase: Identifiable {
    let id = UUID()
    let label: String          // e.g. "Breath Sync"
    let instruction: String    // Main text shown on screen
    let subInstruction: String // Smaller supporting text
    let duration: TimeInterval // seconds
    var isBreathing: Bool = false
    var inhaleCount: Int = 4
    var exhaleCount: Int = 6
}

struct RoutineData: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let durationDisplay: String // "5 min"
    let imageName: String
    let theme: RoutineTheme
    let phases: [RoutinePhase]
}

// MARK: - Catalog

extension RoutineData {
    static let all: [RoutineData] = [morning, evening, sleep]
    
    static let morning = RoutineData(
        id: "morning",
        title: "Morning Regulation",
        subtitle: "Start the day steady, not rushed",
        durationDisplay: "5 min",
        imageName: "Evening_Wind_Down",
        theme: .morning,
        phases: [
            RoutinePhase(label: "Breath Sync", instruction: "Inhale slowly.\nExhale longer.",
                         subInstruction: "4 counts in · 6 counts out", duration: 1,
                         isBreathing: true, inhaleCount: 4, exhaleCount: 6),
            RoutinePhase(label: "Body Wake-Up", instruction: "Roll your shoulders back.\nGently stretch your neck.\nUnclench your jaw.",
                         subInstruction: "Release overnight tension", duration: 1),
            RoutinePhase(label: "Intentional Grounding", instruction: "Feel your feet on the floor.\nNotice the temperature of the air.\nName one thing you're grateful for.",
                         subInstruction: "Stay present", duration: 1),
            RoutinePhase(label: "Nervous System Priming", instruction: "Today, move slowly.\nYou don't need to rush.",
                         subInstruction: "Set the tone gently", duration: 1),
            RoutinePhase(label: "Closing Anchor", instruction: "You are steady.\nStart gently.",
                         subInstruction: "", duration: 1)
        ]
    )
    
    static let evening = RoutineData(
        id: "evening",
        title: "Evening Wind Down",
        subtitle: "Release the weight of the day",
        durationDisplay: "7 min",
        imageName: "Morning_regulation",
        theme: .evening,
        phases: [
            RoutinePhase(label: "Slow Breathing", instruction: "Breathe in for 4.\nBreathe out for 6.",
                         subInstruction: "Let your body slow down", duration: 1,
                         isBreathing: true, inhaleCount: 4, exhaleCount: 6),
            RoutinePhase(label: "Tension Release", instruction: "Tighten your fists.\nRelease.\n\nLift your shoulders.\nDrop them.\n\nPress your toes.\nRelax.",
                         subInstruction: "Release residual tension", duration: 1),
            RoutinePhase(label: "Mental Unload", instruction: "What felt heavy today?\nYou can let it rest for now.",
                         subInstruction: "No analysis needed", duration: 1),
            RoutinePhase(label: "Sensory Soften", instruction: "Let your breathing slow naturally.",
                         subInstruction: "Settle into stillness", duration: 1),
            RoutinePhase(label: "Closure", instruction: "Today is complete.\nYou did enough.",
                         subInstruction: "", duration: 1)
        ]
    )
    
    static let sleep = RoutineData(
        id: "sleep",
        title: "Pre-Sleep Calm",
        subtitle: "Activate deep rest",
        durationDisplay: "5 min",
        imageName: "pre-sleep_calm",
        theme: .sleep,
        phases: [
            RoutinePhase(label: "Extended Exhale", instruction: "Breathe in for 4.\nBreathe out for 8.",
                         subInstruction: "Signal your vagus nerve", duration:1,
                         isBreathing: true, inhaleCount: 4, exhaleCount: 8),
            RoutinePhase(label: "Body Drop", instruction: "Feel the weight of your body.\nLet the bed hold you.\nRelease your tongue.",
                         subInstruction: "A relaxed tongue means safety", duration: 1),
            RoutinePhase(label: "Narrow Attention", instruction: "Focus only on your breath.\nIf thoughts come, let them pass.",
                         subInstruction: "No complexity needed", duration: 1),
            RoutinePhase(label: "Final Phrase", instruction: "Nothing else is needed tonight.\nRest.",
                         subInstruction: "", duration: 1)
        ]
    )
}
