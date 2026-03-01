import SwiftUI

struct ScreenBodyReconnection: View {
    var onFinish: () -> Void
    var onClose: () -> Void
    var onBack: () -> Void
    
    @State private var currentStep = 0
    @State private var viewOpacity: Double = 0.0
    
    // Intro state
    @State private var showIntro = true
    
    // Instrucciones de la Fase 3
    let steps = [
        "Press your feet gently into the floor.",
        "Relax your jaw. Let your tongue rest.",
        "Drop your shoulders."
    ]
    
    var body: some View {
        ZStack {
            // Usamos el nuevo color verde menta para esta fase
            Color.RelaxGreen
                .ignoresSafeArea()
            
            if showIntro {
                // INTRO SCREEN
                VStack(spacing: 30) {
                    Spacer()
                    
                    Text("Body Reconnection")
                        .font(Font.custom("Comfortaa", size: 36).weight(.bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Now let's reconnect to your body.")
                        .font(Font.custom("Comfortaa", size: 24))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    Button(action: startFlow) {
                        Text("Begin")
                            .font(Font.custom("Comfortaa", size: 22).weight(.bold))
                            .foregroundColor(Color.RelaxGreen)
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
                    VStack {
                        HStack {
                            // Back Button
                            Button(action: {
                                if currentStep > 0 {
                                    withAnimation {
                                        currentStep -= 1
                                    }
                                } else {
                                    onBack()
                                }
                            }) {
                                Image(systemName: "arrow.left.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(Color.white.opacity(0.6))
                                    .padding(.horizontal, 30)
                                    .padding(.top, 60)
                            }
                            
                            Spacer()
                            
                            Button(action: onClose) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(Color.white.opacity(0.6)) // Color white para contraste
                                    .padding(.horizontal, 30)
                                    .padding(.top, 60)
                            }
                        }
                        Spacer()
                    }
                    
                    VStack(spacing: 40) {
                        Spacer()
                        
                        // Icono decorativo de calma
                        Image(systemName: "figure.mindful.relaxing")
                            .font(.system(size: 60))
                            .foregroundColor(Color.white.opacity(0.6))
                            .padding(.bottom, 20)
                        
                        // Instrucción actual
                        Text(steps[currentStep])
                            .font(Font.custom("Comfortaa", size: 28).weight(.medium))
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .frame(height: 180)
                            .id(currentStep)
                            .transition(.opacity.animation(.easeInOut(duration: 0.8)))
                        
                        Spacer()
                        
                        // Botón para avanzar
                        Button(action: nextStep) {
                            Text(currentStep < steps.count - 1 ? "Next" : "Continue")
                                .font(Font.custom("Comfortaa", size: 20).weight(.bold))
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 60)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(30)
                        }
                        .padding(.bottom, 50)
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
    
    func nextStep() {
        if currentStep < steps.count - 1 {
            withAnimation {
                currentStep += 1
            }
            // Feedback háptico suave
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } else {
            onFinish()
        }
    }
}
