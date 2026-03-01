import SwiftUI

struct ScreenCognitiveReorientation: View {
    var onFinish: () -> Void
    var onClose: () -> Void
    var onBack: () -> Void
    
    @State private var viewOpacity: Double = 0.0
    @State private var showButton = false
    
    // Control de flujo: 0 = Fase 5, 1 = Fase 6 Acción, 2 = Fase 6 Final
    @State private var currentStage = 0
    
    // Fase 5: Reorientación Cognitiva
    let copingPhrases = [
        "Your body is settling now.",
        "You handled this.",
        "You’re back in control."
    ]
    
    // Fase 6: Cierre Seguro (Acciones)
    let closureActions = [
        "Sit here for a moment.",
        "Drink some water.",
        "Stay with the calm for 10 seconds."
    ]
    
    @State private var selectedCopingPhrase: String = ""
    @State private var selectedClosureAction: String = ""
    
    var body: some View {
        ZStack {
            // Fondo calmante
            Color.white.opacity(0.95)
                .ignoresSafeArea()
            
            // MAIN FLOW
            ZStack {
                // Botón de Cerrar (siempre disponible)
                VStack {
                    HStack {
                        // Back Button
                        Button(action: onBack) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(Color.Clay.opacity(0.6))
                                .padding(.horizontal, 30)
                                .padding(.top, 60)
                        }
                        
                        Spacer()
                        
                        Button(action: onClose) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(Color.Clay.opacity(0.6))
                                .padding(.horizontal, 30)
                                .padding(.top, 60)
                        }
                    }
                    Spacer()
                }
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Contenido dinámico según el estado
                    Group {
                        if currentStage == 0 {
                            Text(selectedCopingPhrase)
                                .font(Font.custom("Comfortaa", size: 32).weight(.medium))
                                .transition(.opacity)
                        } else if currentStage == 1 {
                            Text(selectedClosureAction)
                                .font(Font.custom("Comfortaa", size: 30).weight(.medium))
                                .transition(.opacity)
                        } else {
                            VStack(spacing: 20) {
                                Text("You’re safe.")
                                    .font(Font.custom("Comfortaa", size: 36).weight(.bold))
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(Color.RelaxGreen)
                                    .opacity(0.8)
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .foregroundColor(Color.Clay)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .id(currentStage) // Fuerza la animación al cambiar de stage
                    
                    Spacer()
                    
                    // Botón "Home" solo al final
                    if showButton {
                        Button(action: onFinish) {
                            Text("Back to Home")
                                .font(Font.custom("Comfortaa", size: 20).weight(.bold))
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 60)
                                .background(Color.Clay)
                                .cornerRadius(30)
                        }
                        .transition(.opacity.animation(.easeIn(duration: 1.0)))
                        .padding(.bottom, 60)
                    }
                }
            }
            .transition(.opacity)
        }
        .opacity(viewOpacity)
        .onAppear {
            setupFlow()
            // Initial fade in of the whole screen
            withAnimation(.easeIn(duration: 1.0)) {
                viewOpacity = 1.0
            }
        }
    }
    
    func setupFlow() {
        // 1. Selección inicial
        if selectedCopingPhrase.isEmpty {
            selectedCopingPhrase = copingPhrases.randomElement() ?? copingPhrases[0]
            selectedClosureAction = closureActions.randomElement() ?? closureActions[0]
        }
        
        // 2. Secuencia de tiempos
        // Stage 0 -> Stage 1 (después de 4s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            withAnimation(.easeInOut(duration: 1.0)) {
                currentStage = 1
            }
        }
        
        // Stage 1 -> Stage 2 (después de 4s + 6s = 10s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            withAnimation(.easeInOut(duration: 1.0)) {
                currentStage = 2
                showButton = true
            }
        }
    }
}

#Preview {
    ScreenCognitiveReorientation(onFinish: {}, onClose: {}, onBack: {})
}
