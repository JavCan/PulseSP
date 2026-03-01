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
        NavigationStack {
            ZStack {
                // Background
                Color.Cream
                    .ignoresSafeArea()
                
                // Content Layer
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
                    
                    // Center spacing for the button area
                    Color.clear.frame(height: imageHeight + 100)
                    
                    Spacer()
                    
                    // Local Tab Bar
                    CustomTabBar(selectedTab: $selectedTab)
                        .padding(.bottom, 8)
                        .opacity(isExpanding ? 0 : 1)
                }
                
                // Panic Attack button Section (Overlays content to allow expansion over everything)
                VStack {
                    Spacer()
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
                                .ignoresSafeArea()
                            
                            Circle()
                                .fill(Color.GlaciarBlue)
                                .frame(width: 222, height: 222)
                                .opacity(isExpanding ? 0 : 1)
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
                    }
                    .zIndex(2) // Higher priority to cover neighbors
                    
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
                    .zIndex(1) // Lower priority
                    
                    Spacer().frame(height: 140)
                }
                .zIndex(1)
                
                if showRelaxationScreen {
                    ScreenRelaxation(onDismiss: {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            showRelaxationScreen = false
                        }
                        withAnimation(.easeInOut(duration: 1.5)) {
                            isExpanding = false
                        }
                    })
                    .transition(.opacity)
                    .zIndex(20)
                    .ignoresSafeArea()
                }
            }
            .navigationDestination(isPresented: Binding(
                get: { selectedTab == .breathe },
                set: { if !$0 { selectedTab = .home } }
            )) {
                ScreenLeaf(selectedTab: $selectedTab)
                    .navigationBarBackButtonHidden(true)
            }
            .onAppear {
                if dailyAffirmation.isEmpty{
                    dailyAffirmation = affirmations.randomElement() ?? affirmations [0]
                }
            }
        }
    }
    

}

#Preview {
    ScreenHome()
}
