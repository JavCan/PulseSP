import SwiftUI

// MARK: - Breathing Circle View

struct BreathingCircleView: View {
    let theme: RoutineTheme
    let inhaleCount: Int
    let exhaleCount: Int
    
    @State private var circleScale: CGFloat = 1.0
    @State private var breathLabel: String = "Inhale"
    @State private var secondsRemaining: Int = 0
    @State private var timerRef: Timer? = nil
    
    var circleColor: Color {
        switch theme {
        case .morning: return Color.SalviaGreen.opacity(0.7)
        case .evening: return Color.SoftEveningOrange.opacity(0.7)
        case .sleep:   return Color.RelaxLavanda.opacity(0.8)
        }
    }
    
    var outerRingColor: Color {
        circleColor.opacity(0.25)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                // Outer decorative ring
                Circle()
                    .stroke(outerRingColor, lineWidth: 2)
                    .frame(width: 220, height: 220)
                
                // Main breathing circle
                Circle()
                    .stroke(circleColor, lineWidth: 12)
                    .frame(width: 160, height: 160)
                    .scaleEffect(circleScale)
                    .animation(.easeInOut(duration: Double(breathLabel == "Inhale" ? inhaleCount : exhaleCount)), value: circleScale)
                
                // Countdown number
                Text("\(secondsRemaining)")
                    .font(Font.custom("Comfortaa", size: 44).weight(.bold))
                    .foregroundColor(circleColor.opacity(0.9))
                    .monospacedDigit()
            }
            
            // Inhale / Exhale label
            Text(breathLabel)
                .font(Font.custom("Comfortaa", size: 18).weight(.medium))
                .foregroundColor(circleColor)
                .id(breathLabel)
                .transition(.opacity.animation(.easeInOut(duration: 0.4)))
        }
        .onAppear { runInhale() }
        .onDisappear { timerRef?.invalidate() }
    }
    
    private func runInhale() {
        breathLabel = "Inhale"
        secondsRemaining = inhaleCount
        withAnimation(.easeInOut(duration: Double(inhaleCount))) {
            circleScale = 1.35
        }
        tick(duration: inhaleCount) { runExhale() }
    }
    
    private func runExhale() {
        breathLabel = "Exhale"
        secondsRemaining = exhaleCount
        withAnimation(.easeInOut(duration: Double(exhaleCount))) {
            circleScale = 1.0
        }
        tick(duration: exhaleCount) { runInhale() }
    }
    
    private func tick(duration: Int, completion: @escaping () -> Void) {
        timerRef?.invalidate()
        var left = duration
        timerRef = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if left > 1 {
                left -= 1
                secondsRemaining = left
            } else {
                t.invalidate()
                completion()
            }
        }
    }
}

// MARK: - Routine Player

struct ScreenRoutinePlayer: View {
    let routine: RoutineData
    @Environment(\.dismiss) var dismiss
    
    @State private var currentPhaseIndex = 0
    @State private var elapsed: TimeInterval = 0
    @State private var canAdvance = false
    @State private var isTransitioning = false
    @State private var contentOpacity: Double = 1.0
    @State private var timer: Timer? = nil
    @State private var isFinished = false
    
    // For the sleep routine: auto-dim on last phase
    @State private var sleepDimOpacity: Double = 0.0
    
    // Force BreathingCircleView to reset when phase changes
    @State private var breathingCircleID = UUID()
    
    private var currentPhase: RoutinePhase { routine.phases[currentPhaseIndex] }
    private var totalPhases: Int { routine.phases.count }
    private var progress: Double { Double(currentPhaseIndex) / Double(totalPhases) }
    private var theme: RoutineTheme { routine.theme }
    
    var body: some View {
        ZStack {
            // Background
            theme.backgroundColor
                .ignoresSafeArea()
            
            // Sleep dim overlay on last phase
            if routine.theme == .sleep && currentPhaseIndex == totalPhases - 1 {
                Color.black.opacity(sleepDimOpacity * 0.4)
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 3), value: sleepDimOpacity)
            }
            
            VStack(spacing: 0) {
                // MARK: - Top Progress Bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(theme.subtleTextColor.opacity(0.3))
                            .frame(height: 3)
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(theme.accentColor.opacity(0.8))
                            .frame(width: geo.size.width * progress, height: 3)
                            .animation(.easeInOut(duration: 0.6), value: currentPhaseIndex)
                    }
                }
                .frame(height: 3)
                .padding(.horizontal, 28)
                .padding(.top, 20)
                
                Spacer()
                
                // MARK: - Phase Content
                VStack(spacing: 20) {
                    // Phase label
                    Text(currentPhase.label.uppercased())
                        .font(Font.custom("Comfortaa", size: 12).weight(.bold))
                        .tracking(2)
                        .foregroundColor(theme.subtleTextColor)
                    
                    if currentPhase.isBreathing {
                        // Breathing phases: show circle instead of full instruction text
                        BreathingCircleView(
                            theme: theme,
                            inhaleCount: currentPhase.inhaleCount,
                            exhaleCount: currentPhase.exhaleCount
                        )
                        .id(breathingCircleID)
                        .padding(.vertical, 10)
                        
                        // Sub instruction below circle
                        if !currentPhase.subInstruction.isEmpty {
                            Text(currentPhase.subInstruction)
                                .font(Font.custom("Comfortaa", size: 14))
                                .foregroundColor(theme.subtleTextColor)
                                .multilineTextAlignment(.center)
                        }
                    } else {
                        // Non-breathing phases: show instruction text normally
                        Text(currentPhase.instruction)
                            .font(Font.custom("Comfortaa", size: 26).weight(.medium))
                            .foregroundColor(theme.textColor)
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                            .padding(.horizontal, 36)
                        
                        if !currentPhase.subInstruction.isEmpty {
                            Text(currentPhase.subInstruction)
                                .font(Font.custom("Comfortaa", size: 14))
                                .foregroundColor(theme.subtleTextColor)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                        }
                    }
                    
                    // Ready indicator
                    if canAdvance && !isFinished && currentPhaseIndex < totalPhases - 1 {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(theme.accentColor)
                                .frame(width: 6, height: 6)
                            Text("Ready when you are")
                                .font(Font.custom("Comfortaa", size: 12))
                                .foregroundColor(theme.accentColor)
                        }
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    }
                }
                .opacity(contentOpacity)
                .animation(.easeInOut(duration: 0.5), value: contentOpacity)
                
                Spacer()
                
                // MARK: - Floating Bottom Buttons
                if isFinished {
                    VStack(spacing: 12) {
                        Text("Well done")
                            .font(Font.custom("Comfortaa", size: 20).weight(.medium))
                            .foregroundColor(theme.textColor)
                        
                        Button(action: { dismiss() }) {
                            Text("Close")
                                .font(Font.custom("Comfortaa", size: 16).weight(.bold))
                                .foregroundColor(theme.backgroundColor)
                                .padding(.horizontal, 48)
                                .padding(.vertical, 14)
                                .background(theme.accentColor)
                                .cornerRadius(30)
                        }
                    }
                    .padding(.bottom, 50)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    HStack(spacing: 20) {
                        // Back button
                        Button(action: goBack) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Back")
                                    .font(Font.custom("Comfortaa", size: 15))
                            }
                            .foregroundColor(theme.subtleTextColor)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 14)
                            .background(theme.textColor.opacity(0.07))
                            .cornerRadius(30)
                        }
                        .disabled(currentPhaseIndex == 0)
                        .opacity(currentPhaseIndex == 0 ? 0 : 1)
                        
                        Spacer()
                        
                        // Next button
                        Button(action: goNext) {
                            HStack(spacing: 6) {
                                Text(currentPhaseIndex == totalPhases - 1 ? "Finish" : "Next")
                                    .font(Font.custom("Comfortaa", size: 15))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(canAdvance ? theme.backgroundColor : theme.subtleTextColor)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(canAdvance ? theme.accentColor : theme.textColor.opacity(0.07))
                            .cornerRadius(30)
                            .animation(.easeInOut(duration: 0.4), value: canAdvance)
                        }
                        .disabled(!canAdvance)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                }
            }
            
            // Top left: Close button
            VStack {
                HStack {
                    Button(action: {
                        stopTimer()
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(theme.subtleTextColor)
                            .padding(10)
                            .background(theme.textColor.opacity(0.08))
                            .clipShape(Circle())
                    }
                    .padding(.leading, 24)
                    .padding(.top, 60)
                    Spacer()
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear { 
            startTimer() 
        }
        .onDisappear { 
            stopTimer() 
        }
    }
    
    // MARK: - Timer logic
    
    private func startTimer() {
        elapsed = 0
        canAdvance = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsed += 1
            if elapsed >= currentPhase.duration {
                withAnimation(.spring()) { canAdvance = true }
                if routine.theme == .sleep && currentPhaseIndex == totalPhases - 1 {
                    withAnimation { sleepDimOpacity = 1.0 }
                }
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func transitionTo(index: Int) {
        stopTimer()
        withAnimation(.easeInOut(duration: 0.3)) { contentOpacity = 0 }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            currentPhaseIndex = index
            breathingCircleID = UUID() // Reset breathing animation
            withAnimation(.easeInOut(duration: 0.4)) { contentOpacity = 1 }
            startTimer()
        }
    }
    
    private func goNext() {
        guard canAdvance else { return }
        let nextIndex = currentPhaseIndex + 1
        if nextIndex >= totalPhases {
            stopTimer()
            withAnimation(.easeInOut(duration: 0.5)) { isFinished = true }
        } else {
            transitionTo(index: nextIndex)
        }
    }
    
    private func goBack() {
        guard currentPhaseIndex > 0 else { return }
        transitionTo(index: currentPhaseIndex - 1)
        canAdvance = true
    }
}
