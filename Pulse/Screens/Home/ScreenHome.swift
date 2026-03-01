import SwiftUI

struct ScreenHome: View {
    
    @State private var selectedTab: TabItem = .home
    @State private var isExpanding = false // Controla la expansión
    @State private var showRelaxationScreen = false

    
    @State private var dailyAffirmation: String = ""
    
    let affirmations = [
            "I am more than my circumstances dictate.",
            "I am valued and helpful.",
            "I am worthy of investing in myself.",
            "I belong here, and I deserve to take up space.",
            "I can hold two opposing feelings at once, it means I am processing."
        ]
    
    // Configuración para la imagen
    let imageWidth: CGFloat = 300
    let imageHeight: CGFloat = 300
    
    var body: some View {
        ZStack {
            // Fondo base
            Color.Cream
                .ignoresSafeArea()
            
            switch selectedTab {
            case .home:
                VStack {
                    // Affirmation Card
                    VStack(spacing: 20) {
                        Text("Today's Affirmation")
                            .font(Font.custom("Comfortaa", size: 18).weight(.bold))
                            .foregroundColor(.Clay)
                        
                        Text(dailyAffirmation)
                            .font(Font.custom("Comfortaa", size: 16))
                            .foregroundColor(.Clay)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .lineLimit(2)
                            .minimumScaleFactor(0.7)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .padding(.horizontal, 20)
                    .background(Color.PalidSand.opacity(0.8))
                    .cornerRadius(30)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .opacity(isExpanding ? 0 : 1)
                    
                    Spacer()
                    
                    // Panic Attack button Section
                    ZStack {
                        Image("Feeling_Overwhelmed")
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageWidth, height: imageHeight)
                            .offset(y: -115)
                            .opacity(isExpanding ? 0 : 1)
                        
                        ZStack {
                            Circle()
                                .fill(Color.GlaciarBlueOpacity)
                                .frame(width: 257, height: 257)
                                .scaleEffect(isExpanding ? 15 : 1)
                                .animation(.easeInOut(duration: 2), value: isExpanding)
                                .zIndex(isExpanding ? 10 : 0)
                            
                            Circle()
                                .fill(Color.GlaciarBlue)
                                .frame(width: 222, height: 222)
                                .opacity(isExpanding ? 0 : 1)
                                .zIndex(isExpanding ? 11 : 1)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 1.5)) {
                                        isExpanding = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        withAnimation(.none) {
                                            showRelaxationScreen = true
                                        }
                                    }
                                }
                        }
                        .offset(y: 0)
                    }
                    .zIndex(1)
                    
                    Group {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 40, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.Clay)
                        
                        Text("Press me!")
                            .padding(.top, 15)
                            .font(Font.custom("Comfortaa", size: 26).weight(.bold))
                            .foregroundColor(.Clay)
                    }
                    .opacity(isExpanding ? 0 : 1)
                    
                    Spacer().frame(height: 80)
                    
                    CustomTabBar(selectedTab: $selectedTab)
                        .padding(.bottom, 8)
                        .opacity(isExpanding ? 0 : 1)
                }
                
            case .breathe:
                ScreenLeaf(selectedTab: $selectedTab)
            }
            
            if showRelaxationScreen {
                ScreenRelaxation(onDismiss: {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showRelaxationScreen = false
                        isExpanding = false
                    }
                })
                .transition(.opacity)
                .zIndex(20)
                .ignoresSafeArea()
            }
        }
        .ignoresSafeArea(isExpanding ? .all : [])
        .onAppear {
            if dailyAffirmation.isEmpty{
                dailyAffirmation = affirmations.randomElement() ?? affirmations [0]
            }
        }
        
        
    }
    

}

#Preview {
    ScreenHome()
}
