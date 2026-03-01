import SwiftUI

// MARK: - Article Data Model
struct ArticleData: Identifiable {
    let id: Int
    let title: String
    let cardSubtitle: String
    let imageName: String
    let thumbnailName: String
    let paragraphs: [String]
    let sources: [(label: String, url: String)]
}

let articlesData: [ArticleData] = [
    ArticleData(
        id: 1,
        title: "What is a Panic Attack and Why Does It Feel So Intense?",
        cardSubtitle: "The sudden fright that activates your body to the max.",
        imageName: "article_1",
        thumbnailName: "article_1_thumb",
        paragraphs: [
            "A panic attack is a sudden episode of intense fear or discomfort that peaks within minutes, often without any real danger or obvious trigger. Common symptoms include rapid heartbeat, sweating, shortness of breath, chest pain, dizziness, trembling, and a sense of impending doom or loss of control.",
            "It feels so intense because it activates the body's fight-or-flight response, flooding the system with adrenaline and stress hormones like cortisol via the sympathetic nervous system and HPA axis. This causes exaggerated physical reactions—such as a pounding heart and hyperventilation—even without a threat, mimicking a heart attack and amplifying terror through amygdala hyperactivity. Attacks typically last 5-30 minutes but can leave lingering exhaustion."
        ],
        sources: [
            ("Merriam-Webster", "https://www.merriam-webster.com/dictionary/panic%20attack"),
            ("Timothy Center", "https://timothycenter.com/what-does-a-panic-attack-feel-like-12-symptoms/")
        ]
    ),
    ArticleData(
        id: 2,
        title: "Why does this happen to me \"out of nowhere\" if I'm not stressed?",
        cardSubtitle: "False alarms that ignore apparent calm.",
        imageName: "article_2",
        thumbnailName: "article_2_thumb",
        paragraphs: [
            "Panic attacks can strike without warning, even if you feel calm. They often seem to come \"out of nowhere\" because hidden triggers or body signals build up quietly.",
            "Your brain's fear center might misfire, spotting a false danger like a change in heartbeat or stomach flip. Past experiences, genes, or imbalances in brain chemicals can make this happen randomly, skipping obvious stress.",
            " ",
            "Breathing shifts or caffeine can spark it too, turning a tiny sensation into full panic fast. These episodes peak quick but fade, showing your body just overreacted."
        ],
        sources: [
            ("Mayo Clinic", "https://www.mayoclinic.org/diseases-conditions/panic-attacks/symptoms-causes/syc-20376021"),
            ("Merriam-Webster", "https://www.merriam-webster.com/dictionary/panic%20attack"),
            ("Better Health", "https://www.betterhealth.vic.gov.au/health/conditionsandtreatments/panic-attack")
        ]
    ),
    ArticleData(
        id: 3,
        title: "What happens in my brain during a panic attack?",
        cardSubtitle: "How fear takes control in seconds.",
        imageName: "article_3",
        thumbnailName: "article_3_thumb",
        paragraphs: [
            "During a panic attack, your brain's fear center called the amygdala goes into overdrive, sounding a false alarm as if danger is near. It signals the release of stress hormones like adrenaline, ramping up your heart rate and breathing to prepare for \"fight or flight.\"",
            "This creates a feedback loop: the amygdala senses normal body changes—like a faster heartbeat—as threats, triggering more panic. The prefrontal cortex, which calms fear, gets overwhelmed and can't stop the surge, making everything feel out of control.",
            " ",
            "Once the attack peaks in minutes, hormone levels drop, and calm returns as the brain resets."
        ],
        sources: [
            ("MindEase", "https://mindease.io/wellness-blog/panic-attack-neuroscience"),
            ("Timothy Center", "https://timothycenter.com/what-does-a-panic-attack-feel-like-12-symptoms/"),
            ("Merriam-Webster", "https://www.merriam-webster.com/dictionary/panic%20attack")
        ]
    )
]

// MARK: - Screen Leaf
struct ScreenLeaf: View {
    
    @Binding var selectedTab: TabItem
    @StateObject private var moodStore = MoodStore()
    @StateObject private var soundStore = SoundStore()
    
    // Mood animation state
    @State private var selectedMood: Int? = nil
    @State private var moodAnimPhase: Int = 0  // 0=idle, 1=fade others, 2=center, 3=pop, 4=navigate
    @State private var showCalendar = false
    
    var body: some View {
        ZStack {
            Color.Cream
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 14) {
                        // MARK: - Articles Section
                        ForEach(articlesData) { article in
                            NavigationLink(destination: ArticleDetailView(article: article)) {
                                ArticleCard(
                                    title: "\(article.title)",
                                    subtitle: article.cardSubtitle,
                                    thumbnailName: article.thumbnailName
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        // MARK: - Nervous System Care Section
                        VStack(spacing: 14) {
                            Text("Nervous System Care")
                                .font(Font.custom("Comfortaa", size: 24).weight(.medium))
                                .foregroundColor(.Clay)
                                .padding(.top, 20)
                                .minimumScaleFactor(0.7)
                            
                            // How are you feeling today?
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(alignment: .top) {
                                    Text("How are you feeling today?")
                                        .font(Font.custom("Comfortaa", size: 15).weight(.medium))
                                        .foregroundColor(.Clay)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.Clay.opacity(0.6))
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                
                                HStack(spacing: 12) {
                                    ForEach(1...5, id: \.self) { mood in
                                        Image("\(mood)")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 48, height: 48)
                                            // Phase 1: fade out non-selected
                                            .opacity(moodOpacity(for: mood))
                                            // Phase 2+3: scale effects
                                            .scaleEffect(moodScale(for: mood))
                                            .animation(.easeInOut(duration: 0.3), value: moodAnimPhase)
                                            .animation(.easeInOut(duration: 0.2), value: selectedMood)
                                            .onTapGesture {
                                                guard moodAnimPhase == 0 else { return }
                                                startMoodAnimation(mood: mood)
                                            }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .animation(.easeInOut(duration: 0.3), value: moodAnimPhase)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(18)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(20)
                            .onTapGesture {
                                guard moodAnimPhase == 0 else { return }
                                showCalendar = true
                            }
                            .padding(.horizontal, 14)
                            
                            // Calm Sounds & Guided Practices
                            HStack(spacing: 12) {
                                NavigationLink(destination: ScreenCalmSounds()) {
                                    SmallCard(title: "Calm Sounds", 
                                              isPlayable: true, 
                                              isPlaying: soundStore.isPlaying,
                                              currentSoundTitle: soundStore.currentSound?.title,
                                              onPlay: {
                                        soundStore.toggleRandom()
                                    })
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                NavigationLink(destination: ScreenCalmRoutines()) {
                                    SmallCard(title: "Calm Routines", iconName: "brain.head.profile")
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal, 14)
                            .padding(.bottom, 15)
                        }
                        .background(Color.GlaciarBlue.opacity(0.5))
                        .cornerRadius(30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationDestination(isPresented: $showCalendar) {
            MoodCalendarView(moodStore: moodStore)
        }
        .onDisappear {
            soundStore.stop()
        }
    }
    
    // MARK: - Mood Animation Helpers
    
    private func moodOpacity(for mood: Int) -> Double {
        switch moodAnimPhase {
        case 0:
            return selectedMood == nil || selectedMood == mood ? 1.0 : 0.4
        case 1:
            return selectedMood == mood ? 1.0 : 0.0
        default:
            return 1.0
        }
    }
    
    private func moodScale(for mood: Int) -> CGFloat {
        guard selectedMood == mood else { return 1.0 }
        switch moodAnimPhase {
        case 1: return 1.15
        default: return 1.0
        }
    }
    
    private func startMoodAnimation(mood: Int) {
        selectedMood = mood
        moodStore.setMood(mood)
        
        // Phase 1: fade out others and scale selected
        withAnimation(.easeInOut(duration: 0.3)) {
            moodAnimPhase = 1
        }
        
        // Navigate to calendar after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            showCalendar = true
            // Reset animation state for when user comes back
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                moodAnimPhase = 0
                selectedMood = nil
            }
        }
    }
}

// MARK: - Article Detail View
struct ArticleDetailView: View {
    let article: ArticleData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.Cream
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Title
                        Text(article.title)
                            
                            .font(Font.custom("Comfortaa", size: 22).weight(.bold))
                            .foregroundColor(.Clay)
                            .lineSpacing(4)
                        
                        // First paragraph
                        if article.paragraphs.count > 0 {
                            Text(article.paragraphs[0])
                                .font(Font.custom("Comfortaa", size: 14))
                                .foregroundColor(.Clay.opacity(0.85))
                                .lineSpacing(6)
                        }
                        
                        // Image
                        Image(article.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(20)
                        
                        // Remaining paragraphs
                        ForEach(Array(article.paragraphs.dropFirst().enumerated()), id: \.offset) { _, paragraph in
                            Text(paragraph)
                                .font(Font.custom("Comfortaa", size: 14))
                                .foregroundColor(.Clay.opacity(0.85))
                                .lineSpacing(6)
                        }
                        
                        // Sources
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sources")
                                .font(Font.custom("Comfortaa", size: 16).weight(.bold))
                                .foregroundColor(.Clay)
                            
                            ForEach(Array(article.sources.enumerated()), id: \.offset) { _, source in
                                Link(destination: URL(string: source.url)!) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "link")
                                            .font(.system(size: 12))
                                        Text(source.label)
                                            .font(Font.custom("Comfortaa", size: 13))
                                            .underline()
                                    }
                                    .foregroundColor(.SalviaGreen)
                                }
                            }
                        }
                        .padding(18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.PalidSand.opacity(0.5))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 24)
                    // Added top padding to avoid the dynamic island
                    .padding(.top, 80)
                    .padding(.bottom, 100) // Extra padding for floating button
                }
                .mask {
                    LinearGradient(
                        stops: [
                            .init(color: .black, location: 0.9),
                            .init(color: .clear, location: 1.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
            }
            
            // Floating Close Button
            VStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.red.opacity(0.5))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(edges: .top)
    }
}

// MARK: - Article Card
struct ArticleCard: View {
    let title: String
    let subtitle: String
    let thumbnailName: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(thumbnailName)
                .resizable()
                .scaledToFill()
                .frame(width: 75, height: 75)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(Font.custom("Comfortaa", size: 12).weight(.bold))
                    .foregroundColor(.Clay)
                
                Text(subtitle)
                    .font(Font.custom("Comfortaa", size: 12))
                    .foregroundColor(.Clay.opacity(0.8))
                    .lineLimit(2)
            }
            
            
            Image(systemName: "chevron.right")
                    .foregroundColor(.Clay.opacity(0.6))
                    .font(.system(size: 14, weight: .semibold))
        }
        .padding(16)
        .frame(height: 107)
        .background(Color.PalidSand.opacity(1))
        .cornerRadius(22)
    }
}

// MARK: - Audio Visualizer
struct AudioVisualizer: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            ForEach(0..<4, id: \.self) { i in
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.SalviaGreen.opacity(0.8))
                    .frame(width: 2, height: isAnimating ? CGFloat([14, 10, 16, 12][i]) : 4)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(Double(i) * 0.1), value: isAnimating)
            }
        }
        .onAppear { isAnimating = true }
    }
}

// MARK: - Small Card
struct SmallCard: View {
    let title: String
    var isPlayable: Bool = false
    var isPlaying: Bool = false
    var currentSoundTitle: String? = nil
    var iconName: String? = nil
    var onPlay: (() -> Void)? = nil
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background Icon (Centered)
            if let icon = iconName {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: icon)
                            .font(.system(size: 34))
                            .foregroundColor(.SalviaGreen.opacity(0.6))
                            .offset(x: -40, y: 18)
                        Spacer()
                    }
                    Spacer()
                }
            }
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    Text(title)
                        .font(Font.custom("Comfortaa", size: 14).weight(.medium))
                        .foregroundColor(.Clay)
                        .minimumScaleFactor(0.7)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.Clay.opacity(0.6))
                        .font(.system(size: 14, weight: .semibold))
                }
                
                Spacer()
                
                if isPlayable {
                    HStack(spacing: 12) {
                        Button(action: { 
                            onPlay?()
                        }) {
                            Image(systemName: isPlaying ? "stop.circle.fill" : "play.circle.fill")
                                .font(.system(size: 38))
                                .foregroundColor(.SalviaGreen.opacity(0.8))
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                        }
                        
                        if isPlaying, let soundTitle = currentSoundTitle {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(soundTitle)
                                    .font(Font.custom("Comfortaa", size: 12).weight(.bold))
                                    .foregroundColor(.Clay)
                                    .minimumScaleFactor(0.7)
                                
                                AudioVisualizer()
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 80)
        .padding(16)
        .background(Color.white.opacity(0.9))
        .cornerRadius(20)
    }
}

#Preview {
    ScreenLeaf(selectedTab: .constant(.breathe))
}
