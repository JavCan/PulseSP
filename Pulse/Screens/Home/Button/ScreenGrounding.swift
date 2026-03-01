import SwiftUI

struct ScreenGrounding: View {
    var onFinish: () -> Void
    var onClose: () -> Void
    var onBack: () -> Void
    
    @State private var currentStep = 0
    @State private var viewOpacity: Double = 0.0
    
    // Intro state
    @State private var showIntro = true
    @State private var introOpacity = 1.0
    
    
    struct GroundingStep {
        let title: String
        let instruction: String
        let icon: String
    }
    
    let steps = [
        GroundingStep(title: "Sight", instruction: "Look around.\nName 3 things you can see.", icon: "eye.fill"),
        GroundingStep(title: "Sound", instruction: "Notice 2 sounds around you.", icon: "ear.fill"),
        GroundingStep(title: "Touch", instruction: "Touch 1 solid object near you.", icon: "hand.tap.fill")
    ]
    
    var body: some View {
        ZStack {
            // Mantenemos el color lavanda/azul suave para estabilidad
            Color.GlaciarBlue
            
            if showIntro {
                // INTRO SCREEN
                VStack(spacing: 30) {
                    Spacer()
                    
                    Text("Grounding")
                        .font(Font.custom("Comfortaa", size: 36).weight(.bold))
                        .foregroundColor(.white)
                    
                    Text("Now let's ground yourself in the present.")
                        .font(Font.custom("Comfortaa", size: 24))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    Button(action: startFlow) {
                        Text("Begin")
                            .font(Font.custom("Comfortaa", size: 22).weight(.bold))
                            .foregroundColor(Color.GlaciarBlue)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 60)
                            .background(Color.white)
                            .cornerRadius(30)
                    }
                    .padding(.bottom, 60)
                }
                .transition(.opacity)
                .zIndex(1) // Ensure it stays on top during transition
            } else {
                // MAIN FLOW
                ZStack {
                    // Header con Botón de Atrás y Cerrar
                    VStack {
                        HStack {
                            // Back Button
                            Button(action: {
                                if currentStep > 0 {
                                    withAnimation(.easeInOut(duration: 0.8)) {
                                        currentStep -= 1
                                    }
                                } else {
                                    onBack()
                                }
                            }) {
                                Image(systemName: "arrow.left.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.horizontal, 30) // Alineado con el botón de cerrar
                                    .padding(.top, 60)
                            }
                            
                            Spacer()
                            
                            // Close Button
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

                    VStack(spacing: 40) {
                        Spacer()
                        
                        // Icono y Título del Paso
                        VStack(spacing: 20) {
                            Image(systemName: steps[currentStep].icon)
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                            
                            Text(steps[currentStep].title)
                                .font(Font.custom("Comfortaa", size: 24).weight(.bold))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .id("icon_\(currentStep)")
                        .transition(.opacity)
                        
                        // Instrucción Principal
                        Text(steps[currentStep].instruction)
                            .font(Font.custom("Comfortaa", size: 28).weight(.medium))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .frame(height: 150)
                            .id("text_\(currentStep)")
                            .transition(.opacity)
                        
                        Spacer()
                        
                        // Botón para avanzar
                        Button(action: nextStep) {
                            Text(currentStep < steps.count - 1 ? "Next" : "Finish")
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
            withAnimation(.easeInOut(duration: 0.8)) {
                currentStep += 1
            }
        } else {
            onFinish()
        }
    }
}
