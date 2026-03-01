import SwiftUI

struct ScreenTensionRelease: View {
    var onFinish: () -> Void
    var onClose: () -> Void
    var onBack: () -> Void
    
    // States
    @State private var currentStep = 0 // 0: Selection, 1: Instruction
    @State private var selectedOption: ReleaseOption? = nil
    @State private var viewOpacity: Double = 0.0
    
    // Intro state
    @State private var showIntro = true
    
    enum ReleaseOption {
        case pressure
        case hug
        
        var title: String {
            switch self {
            case .pressure: return "Pressure"
            case .hug: return "Self-hug"
            }
        }
        
        var instruction: String {
            switch self {
            case .pressure: return "Press your palms together for 5 seconds.\n\nRelease."
            case .hug: return "Wrap your arms around yourself.\n\nHold. Breathe."
            }
        }
        
        var icon: String {
            switch self {
            case .pressure: return "hands.clap.fill"
            case .hug: return "figure.arms.open"
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Calm blue/mint background
            Color.RelaxLavanda
                .ignoresSafeArea()
            
            if showIntro {
                // INTRO SCREEN
                VStack(spacing: 30) {
                    Spacer()
                    
                    Text("Tension Release")
                        .font(Font.custom("Comfortaa", size: 36).weight(.bold))
                        .foregroundColor(.white)
                    
                    Text("Now let's release any remaining tension.")
                        .font(Font.custom("Comfortaa", size: 24))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    Button(action: startFlow) {
                        Text("Begin")
                            .font(Font.custom("Comfortaa", size: 22).weight(.bold))
                            .foregroundColor(Color.RelaxLavanda)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 60)
                            .background(Color.white)
                            .cornerRadius(30)
                    }
                    .padding(.bottom, 60)
                }
                .transition(.opacity)
                .zIndex(1)
            } else {
                // MAIN FLOW
                ZStack {
                    // Close Button
                    VStack {
                        HStack {
                            // Back Button
                            Button(action: {
                                if currentStep == 1 {
                                    withAnimation {
                                        currentStep = 0
                                        selectedOption = nil
                                    }
                                } else {
                                    onBack()
                                }
                            }) {
                                Image(systemName: "arrow.left.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.horizontal, 30)
                                    .padding(.top, 60)
                            }
                            
                            Spacer()
                            
                            Button(action: onClose) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.horizontal, 30)
                                    .padding(.top, 60)
                            }
                        }
                        Spacer()
                    }
                    
                    VStack(spacing: 30) {
                        Spacer()
                        
                        if currentStep == 0 {
                            // SELECTION SCREEN
                            VStack(spacing: 20) {
                                Image(systemName: "bolt.heart.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white.opacity(0.9))
                                
                                Text("Tension Release")
                                    .font(Font.custom("Comfortaa", size: 32).weight(.bold))
                                    .foregroundColor(.white)
                                
                                Text("Choose a way to release residual adrenaline.")
                                    .font(Font.custom("Comfortaa", size: 18))
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                    .padding(.bottom, 20)
                                
                                // Option A
                                Button(action: { selectOption(.pressure) }) {
                                    OptionCard(title: "Pressure", icon: "hands.clap.fill")
                                }
                                
                                // Option B
                                Button(action: { selectOption(.hug) }) {
                                    OptionCard(title: "Self Hug", icon: "figure.arms.open")
                                }
                            }
                            .transition(.opacity)
                        } else {
                            // INSTRUCTION SCREEN
                            if let option = selectedOption {
                                VStack(spacing: 30) {
                                   
                                    Spacer()
                                    
                                    Image(systemName: option.icon)
                                        .font(.system(size: 80))
                                        .foregroundColor(.white.opacity(0.9))
                                    
                                    Text(option.title)
                                        .font(Font.custom("Comfortaa", size: 28).weight(.bold))
                                        .foregroundColor(.white.opacity(0.8))
                                    
                                    Text(option.instruction)
                                        .font(Font.custom("Comfortaa", size: 24).weight(.medium))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 40)
                                        .frame(height: 180)
                                        .id(option.title) // Force refresh animation
                                        .transition(.opacity)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        // Finish flow
                                        onFinish()
                                    }) {
                                        Text("Done")
                                            .font(Font.custom("Comfortaa", size: 20).weight(.bold))
                                            .foregroundColor(Color.RelaxLavanda)
                                            .padding(.vertical, 15)
                                            .padding(.horizontal, 80)
                                            .background(Color.white)
                                            .cornerRadius(30)
                                    }
                                    
                                    Button("Back") {
                                        withAnimation {
                                            currentStep = 0
                                            selectedOption = nil
                                        }
                                    }
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(Font.custom("Comfortaa", size: 18))
                                    .padding(.bottom, 20)
                                }
                                .transition(.opacity)
                            }
                        }
                        
                        Spacer()
                    }
                }
                .transition(.opacity)
            }
        }
        .opacity(viewOpacity)
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                viewOpacity = 1.0
            }
        }
    }
    
    func startFlow() {
        withAnimation(.easeInOut(duration: 0.5)) {
            showIntro = false
        }
    }
    
    func selectOption(_ option: ReleaseOption) {
        withAnimation(.easeInOut) {
            selectedOption = option
            currentStep = 1
        }
    }
}

struct OptionCard: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color.RelaxLavanda)
                .frame(width: 40)
            
            Text(title)
                .font(Font.custom("Comfortaa", size: 20).weight(.bold))
                .foregroundColor(Color.RelaxLavanda)
            
            Spacer()
            
            Image(systemName: "arrow.right.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(Color.RelaxLavanda.opacity(0.6))
        }
        .padding()
        .background(Color.white.opacity(0.95))
        .cornerRadius(20)
        .padding(.horizontal, 40)
        .padding(.vertical, 5)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ScreenTensionRelease(onFinish: {}, onClose: {}, onBack: {})
}
