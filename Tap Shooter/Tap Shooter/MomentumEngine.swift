import Foundation

final class MomentumEngine {
    private(set) var streak = 0
    private(set) var pinnacleStreak = 0

    var multiplier: Float {
        switch streak {
        case 0...5: 1.0
        case 6...10: 2.0
        default: 3.0
        }
    }

    var isFever: Bool { streak >= GlyphKit.feverMomentumThreshold }

    func increment() {
        streak += 1
        if streak > pinnacleStreak { pinnacleStreak = streak }
    }

    func reset() {
        streak = 0
    }

    func reconstitute() {
        streak = 0
        pinnacleStreak = 0
    }
}
