import Foundation
import SwiftUI

class MoodStore: ObservableObject {
    private let key = "moodEntries"
    private let defaults = UserDefaults.standard
    
    @Published private(set) var entries: [String: Int] = [:]
    
    init() {
        loadEntries()
    }
    
    // MARK: - Public API
    
    var todayMood: Int? {
        mood(for: Date())
    }
    
    func setMood(_ mood: Int, for date: Date = Date()) {
        let dateKey = Self.dateKey(for: date)
        entries[dateKey] = mood
        saveEntries()
    }
    
    func mood(for date: Date) -> Int? {
        entries[Self.dateKey(for: date)]
    }
    
    // MARK: - Insights
    
    var moodInsight: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var weekdayMoods: [Int: [Int]] = [:]
        
        for (dateString, mood) in entries {
            guard let date = formatter.date(from: dateString) else { continue }
            let weekday = Calendar.current.component(.weekday, from: date)
            weekdayMoods[weekday, default: []].append(mood)
        }
        
        // Priority order for insights (highest to lowest)
        // 5: Angry, 4: Sad, 3: Anxious, 1: Happy, 2: Relaxed
        let priorities = [5, 4, 3, 1, 2]
        
        for emotion in priorities {
            for (weekday, moods) in weekdayMoods {
                let count = moods.filter { $0 == emotion }.count
                if count >= 2 {
                    let dayName = calendarWeekdayName(for: weekday)
                    
                    switch emotion {
                    case 1: // Happy
                        return "You usually feel happy on \(dayName)s! Your positive energy is contagious."
                    case 2: // Relaxed
                        return "You tend to feel relaxed on \(dayName)s. It's a great time to recharge."
                    case 3: // Anxious
                        return "You often feel anxious on \(dayName)s. Remember to take deep breaths."
                    case 4: // Sad
                        return "You've been feeling a bit down on \(dayName)s. Be kind to yourself today."
                    case 5: // Angry
                        return "Frustration seems to peak on \(dayName)s. How about some tension release exercises?"
                    default:
                        continue
                    }
                }
            }
        }
        
        // Default message if no significant trend or enough data
        return "Keep logging your moods to see weekly insights here!"
    }
    
    // MARK: - Helpers
    
    private func calendarWeekdayName(for weekday: Int) -> String {
        // weekday: 1=Sunday, 2=Monday, ..., 7=Saturday
        let formatter = DateFormatter()
        return formatter.weekdaySymbols[weekday - 1]
    }
    
    private static func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func loadEntries() {
        guard let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([String: Int].self, from: data) else { return }
        entries = decoded
    }
    
    private func saveEntries() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        defaults.set(data, forKey: key)
    }
}
