import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "heart.circle.fill",
            iconGradient: [Color.RelaxLavanda, Color.GlaciarBlue],
            title: "Welcome to Pulse",
            description: "Your companion for calm.\nBreathe, ground, and care for your nervous system."
        ),
        OnboardingPage(
            icon: "wind",
            iconGradient: [Color.SalviaGreen, Color.GlaciarBlue],
            title: "When Panic Strikes",
            description: "Guided breathing and grounding exercises to help you through intense moments."
        ),
        OnboardingPage(
            icon: "sparkles",
            iconGradient: [Color.DeepEveningOrange, Color.VanillaCream],
            title: "Daily Nervous System Care",
            description: "Track your mood, listen to calming sounds, and build healthy routines."
        )
    ]
    
    var body: some View {
        ZStack {
            Color.Cream
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Skip button (top right)
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button(action: {
                            withAnimation { hasSeenOnboarding = true }
                        }) {
                            Text("Skip")
                                .font(Font.custom("Comfortaa", size: 15).weight(.medium))
                                .foregroundColor(.Clay.opacity(0.6))
                        }
                        .padding(.trailing, 28)
                        .padding(.top, 16)
                    } else {
                        Color.clear.frame(height: 31).padding(.top, 16)
                    }
                }
                
                Spacer()
                
                // Page content
                ZStack {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        if index == currentPage {
                            VStack(spacing: 36) {
                                // Icon with gradient circle background
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: page.iconGradient.map { $0.opacity(0.2) },
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 180, height: 180)
                                    
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: page.iconGradient.map { $0.opacity(0.35) },
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 140, height: 140)
                                    
                                    Image(systemName: page.icon)
                                        .font(.system(size: 56, weight: .light))
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: page.iconGradient,
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                }
                                
                                VStack(spacing: 16) {
                                    Text(page.title)
                                        .font(Font.custom("Comfortaa", size: 26).weight(.bold))
                                        .foregroundColor(.Clay)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(page.description)
                                        .font(Font.custom("Comfortaa", size: 15))
                                        .foregroundColor(.Clay.opacity(0.7))
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(6)
                                        .padding(.horizontal, 40)
                                }
                            }
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .scale(scale: 0.95)).animation(.easeInOut(duration: 0.6)),
                                removal: .opacity.animation(.easeInOut(duration: 0.4))
                            ))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                // Page indicator dots
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.Clay : Color.Clay.opacity(0.25))
                            .frame(width: index == currentPage ? 10 : 7, height: index == currentPage ? 10 : 7)
                            .animation(.easeInOut(duration: 0.2), value: currentPage)
                    }
                }
                .padding(.bottom, 30)
                
                // Bottom button
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            currentPage += 1
                        }
                    } else {
                        withAnimation { hasSeenOnboarding = true }
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                        .font(Font.custom("Comfortaa", size: 17).weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: [Color.SalviaGreen, Color.SalviaGreen.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(30)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

// MARK: - Data Model

private struct OnboardingPage {
    let icon: String
    let iconGradient: [Color]
    let title: String
    let description: String
}

#Preview {
    OnboardingView()
}
