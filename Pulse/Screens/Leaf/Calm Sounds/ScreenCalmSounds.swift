import SwiftUI

struct ScreenCalmSounds: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var soundStore = SoundStore()
    
    private let columns = [GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            Color.RelaxLavanda
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
                    
                    Text("Calm Sounds")
                        .font(Font.custom("Comfortaa", size: 24).weight(.bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Empty view to balance the header
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(soundStore.sounds) { sound in
                            SoundCard(sound: sound, 
                                      isPlaying: soundStore.isPlaying && soundStore.currentSound?.id == sound.id,
                                      onToggle: { soundStore.toggleSound(sound) })
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onDisappear {
            soundStore.stop()
        }
    }
}

struct SoundCard: View {
    let sound: SoundData
    let isPlaying: Bool
    let onToggle: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background: photo if available, else gradient
            if let imageName = sound.backgroundImageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                
                // Dark overlay for text readability
                LinearGradient(
                    colors: [Color.black.opacity(0.55), Color.black.opacity(0.2)],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            } else {
                LinearGradient(colors: [
                    Color(sound.color).opacity(0.8),
                    Color(sound.color).opacity(0.4)
                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                
                // Subtle texture/icon
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: sound.icon)
                            .font(.system(size: 80))
                            .foregroundColor(.white.opacity(0.15))
                            .rotationEffect(.degrees(-15))
                            .padding(.trailing, -20)
                            .padding(.bottom, -20)
                    }
                }
                .clipped()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(sound.title)
                        .font(Font.custom("Comfortaa", size: 18).weight(.bold))
                        .foregroundColor(.white)
                    
                    Text(sound.description)
                        .font(Font.custom("Comfortaa", size: 13))
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                Button(action: onToggle) {
                    Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.Clay.opacity(0.5))
                        .clipShape(Circle())
                }
            }
            .padding(20)
        }
        .frame(height: 120)
        .background(Color.white.opacity(0.1))
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ScreenCalmSounds()
}
