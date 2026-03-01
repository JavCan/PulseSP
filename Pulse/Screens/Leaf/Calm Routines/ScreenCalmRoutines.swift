import SwiftUI

struct ScreenCalmRoutines: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.PalidSand
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.Clay.opacity(0.5))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("Calm Routines")
                        .font(Font.custom("Comfortaa", size: 24).weight(.bold))
                        .foregroundColor(.Clay)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        Text("Choose a routine")
                            .font(Font.custom("Comfortaa", size: 14))
                            .foregroundColor(.Clay.opacity(0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 4)
                        
                        ForEach(RoutineData.all) { routine in
                            NavigationLink(destination: ScreenRoutinePlayer(routine: routine)) {
                                RoutineCard(routine: routine)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Routine Card

struct RoutineCard: View {
    let routine: RoutineData
    
    var themeGradient: [Color] {
        switch routine.theme {
        case .morning: return [Color.VibrantMorningBlue, Color.SunlightYellow.opacity(0.5)]
        case .evening: return [Color.DeepEveningOrange, Color.MidnightOrange.opacity(0.95)]
        case .sleep:   return [Color(red: 0.1, green: 0.13, blue: 0.2), Color(red: 0.16, green: 0.2, blue: 0.32)]
        }
    }
    
    var titleColor: Color {
        switch routine.theme {
        case .morning: return .DarkClay
        case .evening: return .SoftEveningOrange
        case .sleep: return .white
        }
    }
    
    var subtitleColor: Color {
        switch routine.theme {
        case .morning: return Color.DarkClay.opacity(0.9)
        case .evening: return Color.SoftEveningOrange.opacity(0.9)
        case .sleep: return Color.white.opacity(0.6)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background gradient
            LinearGradient(colors: themeGradient, startPoint: .topLeading, endPoint: .bottomTrailing)
            
            HStack(spacing: 16) {
                // Emoji + text
                Image(routine.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 55, height: 88)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(routine.title)
                        .font(Font.custom("Comfortaa", size: 17).weight(.bold))
                        .foregroundColor(titleColor)
                    
                    Text(routine.subtitle)
                        .font(Font.custom("Comfortaa", size: 12))
                        .foregroundColor(subtitleColor)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Duration badge + go button
                VStack(alignment: .trailing, spacing: 8) {
                    Text(routine.durationDisplay)
                        .font(Font.custom("Comfortaa", size: 12).weight(.bold))
                        .foregroundColor(titleColor.opacity(1))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                    
                    HStack(spacing: 4) {
                        Text("Go")
                            .font(Font.custom("Comfortaa", size: 13).weight(.bold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .foregroundColor(titleColor)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)
                }
            }
            .padding(22)
        }
        .frame(height: 130)
        .cornerRadius(28)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}

#Preview {
    NavigationStack {
        ScreenCalmRoutines()
    }
}
