import SwiftUI

struct ScreenRelaxation: View {
    var onDismiss: () -> Void
    
    // Estados de animación y control
    @State private var circleScale: CGFloat = 1.0
    @State private var currentText: String = ""
    @State private var phraseIndex = 0
    @State private var viewOpacity: Double = 0.0
    
    // ESTADO PARA EL COLOR DE FONDO
    @State private var backgroundColor: Color = Color(red: 205/255, green: 205/255, blue: 230/255) // Lavanda inicial
    
    // Estados para los contadores
    @State private var countdown = 5
    @State private var isCountingDown = true
    @State private var secondsRemaining = 0
    @State private var timer: Timer? = nil
    
    @State private var showGrounding = false
    @State private var showBodyReconnection = false
    @State private var showTensionRelease = false
    @State private var showCognitiveReorientation = false

    let phrases = [
        "This is uncomfortable, not dangerous.",
        "You are safe right now.",
        "Nothing bad is happening.",
        "You’re not in danger.",
        "This will pass.",
        "It always peaks, then fades.",
        "This feeling won’t last.",
        "You’ve been here before. It ended."
    ]

    var body: some View {
        ZStack {
            // FONDO CON TRANSICIÓN SUTIL
            backgroundColor
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 2.0), value: backgroundColor)
            
            // Botón de Cerrar
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        timer?.invalidate()
                        onDismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 30)
                            .padding(.top, 60)
                    }
                }
                Spacer()
            }
            
            VStack(spacing: 40) {
                if isCountingDown {
                    VStack(spacing: 20) {
                        Text("Prepare to breathe")
                            .font(Font.custom("Comfortaa", size: 22).weight(.medium))
                        
                        Text("\(countdown)")
                            .font(Font.custom("Comfortaa", size: 80).weight(.bold))
                    }
                    .foregroundColor(.white)
                    .transition(.opacity)
                } else {
                    VStack(spacing: 40) {
                        Spacer().frame(height: 40)
                        
                        Text(phrases[phraseIndex])
                            .font(Font.custom("Comfortaa", size: 28).weight(.medium))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .frame(height: 80)
                            .id(phraseIndex)
                            .transition(.opacity.animation(.easeInOut(duration: 1.0)))
                            .minimumScaleFactor(0.7)
                        
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 2)
                                .frame(width: 280, height: 280)
                            
                            Circle()
                                .stroke(Color.white, lineWidth: 15)
                                .frame(width: 200, height: 200)
                                .scaleEffect(circleScale)
                            
                            Text("\(secondsRemaining)")
                                .font(Font.custom("Comfortaa", size: 50).weight(.bold))
                                .foregroundColor(.white.opacity(0.8))
                                .monospacedDigit()
                        }
                        
                        VStack(spacing: 20) {
                            Text(currentText)
                                .font(Font.custom("Comfortaa", size: 28).weight(.bold))
                                .foregroundColor(.white)
                                .id(currentText)
                                .transition(.opacity.animation(.easeInOut))

                            Button(action: {
                                withAnimation {
                                    showGrounding = true
                                }
                            }) {
                                HStack {
                                    Text("Continue Grounding yourself")
                                        .font(Font.custom("Comfortaa", size: 18).weight(.bold))
                                        .foregroundColor(.white)
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding(.vertical, 14)
                                .padding(.horizontal, 24)
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(30)
                            }
                            .padding(.top, 60)
                        }
                    }
                    .transition(.opacity)
                }
            }
        }
        .opacity(viewOpacity)
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                viewOpacity = 1.0
            }
            startInitialCountdown()
        }
        .onDisappear {
            timer?.invalidate()
        }
        
        if showGrounding {
            ScreenGrounding(
                onFinish: {
                    withAnimation { showBodyReconnection = true }
                },
                onClose: {
                    // Cerramos todo el flujo hasta el Home
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showGrounding = false
                        showBodyReconnection = false
                    }
                    onDismiss()
                },
                onBack: {
                    // Volver a ScreenRelaxation
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showGrounding = false
                    }
                }
            )
            .transition(.asymmetric(insertion: .opacity, removal: .opacity))
            .zIndex(30)
        }
        
        if showBodyReconnection {
            ScreenBodyReconnection(
                onFinish: {
                    withAnimation { showTensionRelease = true }
                },
                onClose: {
                    // Cerramos todo el flujo hasta el Home
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showGrounding = false
                        showBodyReconnection = false
                        showTensionRelease = false
                    }
                    onDismiss()
                },
                onBack: {
                    // Volver a ScreenGrounding
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showBodyReconnection = false
                    }
                }
            )
            .transition(.asymmetric(insertion: .opacity, removal: .opacity))
            .zIndex(40)
        }
        
        if showTensionRelease {
            ScreenTensionRelease(
                onFinish: {
                    // Siguiente paso: Reorientación Cognitiva
                    withAnimation { 
                        showCognitiveReorientation = true 
                    }
                },
                onClose: {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showGrounding = false
                        showBodyReconnection = false
                        showTensionRelease = false
                        showCognitiveReorientation = false
                    }
                    onDismiss()
                },
                onBack: {
                    // Volver a ScreenBodyReconnection
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showTensionRelease = false
                    }
                }
            )
            .transition(.asymmetric(insertion: .opacity, removal: .opacity))
            .zIndex(50)
        }
        
        if showCognitiveReorientation {
            ScreenCognitiveReorientation(
                onFinish: {
                    // Fin del flujo, cerrar todo
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showGrounding = false
                        showBodyReconnection = false
                        showTensionRelease = false
                        showCognitiveReorientation = false
                    }
                    onDismiss()
                },
                onClose: {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showGrounding = false
                        showBodyReconnection = false
                        showTensionRelease = false
                        showCognitiveReorientation = false
                    }
                    onDismiss()
                },
                onBack: {
                    // Volver a ScreenTensionRelease
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showCognitiveReorientation = false
                    }
                }
            )
            .transition(.asymmetric(insertion: .opacity, removal: .opacity))
            .zIndex(60)
        }
    }

    // MARK: - Lógica de Fases y Colores
    
    func runInhalePhase() {
        currentText = "Inhale"
        secondsRemaining = 4
        
        // Cambia a RelaxGreen
        backgroundColor = Color.RelaxGreen
        
        withAnimation(.easeInOut(duration: 4)) {
            circleScale = 1.4
        }
        startPhaseTimer(duration: 4) { runHoldPhase() }
    }

    func runHoldPhase() {
        currentText = "Hold"
        secondsRemaining = 4
        
        // Cambia a RelaxLavanda
        backgroundColor = Color.RelaxLavanda
        
        startPhaseTimer(duration: 4) { runExhalePhase() }
    }

    func runExhalePhase() {
        currentText = "Exhale"
        secondsRemaining = 6
        
        // Cambia a GlaciarBlue
        backgroundColor = Color.GlaciarBlue
        
        withAnimation(.easeInOut(duration: 6)) {
            circleScale = 1.0
        }
        startPhaseTimer(duration: 6) {
            runPostExhaleHoldPhase()
        }
    }

    func runPostExhaleHoldPhase() {
        currentText = "Hold"
        secondsRemaining = 4
        
        // Cambia a RelaxLavanda
        backgroundColor = Color.RelaxLavanda
        
        startPhaseTimer(duration: 4) {
            withAnimation(.easeInOut(duration: 1.0)) {
                phraseIndex = (phraseIndex + 1) % phrases.count
            }
            runInhalePhase()
        }
    }


    // (startInitialCountdown y startPhaseTimer se mantienen igual que en tu versión anterior)
    func startInitialCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            if countdown > 1 {
                countdown -= 1
            } else {
                t.invalidate()
                withAnimation { isCountingDown = false }
                runInhalePhase()
            }
        }
    }

    func startPhaseTimer(duration: Int, completion: @escaping () -> Void) {
        timer?.invalidate()
        var timeLeft = duration
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            if timeLeft > 1 {
                timeLeft -= 1
                secondsRemaining = timeLeft
            } else {
                t.invalidate()
                completion()
            }
        }
    }
}

#Preview{
    ScreenRelaxation(onDismiss: {})
}
