import SwiftUI

struct CurvedText: View {
    let text: String
    let radius: CGFloat
    let fontSize: CGFloat = 20

    var body: some View {
        ZStack {
            ForEach(Array(text.enumerated()), id: \.offset) { index, character in
                let angle = angleForCharacter(at: index)

                Text(String(character))
                    .font(.system(size: fontSize))
                    .position(
                        x: radius + cos(angle) * radius,
                        y: radius + sin(angle) * radius
                    )
                    .rotationEffect(.radians(angle + .pi / 2))
            }
        }
        .frame(width: radius * 2, height: radius * 2)
    }

    private func angleForCharacter(at index: Int) -> Double {
        let totalCharacters = text.count
        let arc: Double = .pi // media circunferencia
        let startAngle = -arc / 2
        let step = arc / Double(max(totalCharacters - 1, 1))
        return startAngle + step * Double(index)
    }
}
