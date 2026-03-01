import SwiftUI

struct MoodCalendarView: View {
    @ObservedObject var moodStore: MoodStore
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedDateForEdit: Date? = nil
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdaySymbols = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        ZStack {
            Color.Cream
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Month title
                Text(monthYearString)
                    .font(Font.custom("Comfortaa", size: 24).weight(.bold))
                    .foregroundColor(.Clay)
                    .padding(.top, 20)
                
                // Weekday headers
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(weekdaySymbols, id: \.self) { day in
                        Text(day)
                            .font(Font.custom("Comfortaa", size: 15).weight(.medium))
                            .foregroundColor(.Clay.opacity(0.8))
                    }
                }
                .padding(.horizontal, 20)
                
                // Calendar grid
                LazyVGrid(columns: columns, spacing: 10) {
                    // Empty cells for offset
                    ForEach(-firstWeekdayOffset..<0, id: \.self) { _ in
                        Color.clear
                    }
                    
                    // Day cells
                    ForEach(1...daysInMonth, id: \.self) { day in
                        let date = dateFor(day: day)
                        let mood = moodStore.mood(for: date)
                        let isToday = Calendar.current.isDateInToday(date)
                        let isFuture = Calendar.current.startOfDay(for: date) > Calendar.current.startOfDay(for: Date())
                        
                        Button {
                            withAnimation(.spring()) {
                                selectedDateForEdit = date
                            }
                        } label: {
                            VStack(spacing: 2) {
                                Text("\(day)")
                                    .font(Font.custom("Comfortaa", size: 12).weight(isToday ? .bold : .regular))
                                    .foregroundColor(isToday ? .SalviaGreen : (isFuture ? .Clay.opacity(0.3) : .Clay.opacity(0.7)))
                                
                                if let mood = mood {
                                    Image("\(mood)")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 28, height: 28)
                                } else {
                                    Circle()
                                        .fill(Color.PalidSand.opacity(isFuture ? 0.2 : 0.5))
                                        .frame(width: 28, height: 28)
                                }
                            }
                        }
                        .disabled(isFuture)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isToday ? Color.GlaciarBlue.opacity(0.5) : Color.clear)
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                // Insight Card
                if let insight = moodStore.moodInsight {
                    HStack {
                        Text(insight)
                            .font(Font.custom("Comfortaa", size: 20))
                            .foregroundColor(.Clay)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .minimumScaleFactor(0.7)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.PalidSand.opacity(0.8))
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                }
                
                Spacer()
            }
            .padding(.top, 40)

            
            // Custom Horizontal Picker Overlay
            if let editDate = selectedDateForEdit {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedDateForEdit = nil
                        }
                    }
                    .zIndex(1)
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Text("How did you feel?")
                            .font(Font.custom("Comfortaa", size: 18).weight(.bold))
                            .foregroundColor(.Clay)
                        
                        HStack(spacing: 15) {
                            ForEach(1...5, id: \.self) { emotionId in
                                let isSelected = moodStore.mood(for: editDate) == emotionId
                                
                                Button {
                                    withAnimation(.spring()) {
                                        selectedDateForEdit = nil
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        moodStore.setMood(emotionId, for: editDate)
                                    }
                                } label: {
                                    Image("\(emotionId)")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .padding(8)
                                        .background(
                                            Circle()
                                                .fill(isSelected ? Color.GlaciarBlue.opacity(0.5) : Color.PalidSand.opacity(0.5))
                                        )
                                        .scaleEffect(isSelected ? 1.1 : 1.0)
                                }
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 25)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color.Cream)
                    .cornerRadius(30)
                    .shadow(color: Color.black.opacity(0.15), radius: 10, y: 5)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .frame(maxWidth: .infinity)
                .zIndex(2)
            }

        }
    }
    
    // MARK: - Calendar Helpers
    
    private var currentDate: Date { Date() }
    
    private var calendar: Calendar { Calendar.current }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }
    
    private var daysInMonth: Int {
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        return range.count
    }
    
    /// Offset for the first day of the month (Monday = 0)
    private var firstWeekdayOffset: Int {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        let firstOfMonth = calendar.date(from: components)!
        // weekday: 1=Sunday, 2=Monday, ..., 7=Saturday
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        // Convert to Monday-based: Mon=0, Tue=1, ..., Sun=6
        return (weekday + 5) % 7
    }
    
    private func dateFor(day: Int) -> Date {
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        components.day = day
        return calendar.date(from: components) ?? currentDate
    }
}

#Preview {
    NavigationStack {
        MoodCalendarView(moodStore: MoodStore())
    }
}
