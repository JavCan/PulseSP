import Foundation
import AVFoundation

struct SoundData: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String // SF Symbol
    let color: String // Color name for gradient fallback
    let filename: String? // Actual filename in bundle
    var backgroundImageName: String? = nil // Asset catalog image name
}

class SoundStore: ObservableObject {
    @Published var isPlaying = false
    @Published var currentSound: SoundData?
    
    private var audioPlayer: AVAudioPlayer?
    private var lastPlayedSoundId: String? = nil
    
    let sounds: [SoundData] = [
        SoundData(id: "rain", title: "Rain", description: "Soft summer rain or rain on a roof", icon: "cloud.rain.fill", color: "GlaciarBlue", filename: "Rain on the Window Sound Effect", backgroundImageName: "rain"),
        SoundData(id: "ocean", title: "Ocean Waves", description: "Rhythmic waves on the shore", icon: "wave.3.right", color: "SkySerene", filename: "Ocean Waves Sound Effect", backgroundImageName: "ocean_waves"),
        SoundData(id: "stream", title: "Streams", description: "Constant murmur of running water", icon: "drop.fill", color: "RelaxGreen", filename: "Small River Sound Effect", backgroundImageName: "stream"),
        SoundData(id: "wind", title: "Wind", description: "Soft breeze through the trees", icon: "wind", color: "MintCalm", filename: "Wind Sounds 318856", backgroundImageName: "wind"),
        SoundData(id: "storm", title: "Distant Storm", description: "Soft, distant thunder and rain", icon: "cloud.bolt.rain.fill", color: "Clay", filename: "Distant Storm Sound Effects", backgroundImageName: "distant_storm"),
    ]
    
    func toggleSound(_ sound: SoundData) {
        if currentSound?.id == sound.id && isPlaying {
            stop()
        } else {
            play(sound)
        }
    }
    
    func play(_ sound: SoundData) {
        stop()
        
        guard let filename = sound.filename,
              let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else {
            currentSound = sound
            isPlaying = true
            print("Simulating playback of \(sound.title). File not found in bundle.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Loop infinitely
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            currentSound = sound
            isPlaying = true
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
    
    func stop() {
        audioPlayer?.stop()
        isPlaying = false
        currentSound = nil
    }
    
    func toggleRandom() {
        if isPlaying {
            stop()
        } else {
            playRandom()
        }
    }
    
    func playRandom() {
        // Filter out the last played sound to ensure variety if possible
        let availableSounds = sounds.filter { $0.id != lastPlayedSoundId }
        let soundToPlay = availableSounds.randomElement() ?? sounds.randomElement()
        
        if let sound = soundToPlay {
            lastPlayedSoundId = sound.id
            play(sound)
        }
    }
}
