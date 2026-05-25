import Foundation

final class EscalationConductor {
    private(set) var tier = 0
    private var elapsed: TimeInterval = 0
    private var modeIdentifier = "classic"

    var quarryCount: Int {
        let base = modeIdentifier == "precision" ? 2 : 3
        return min(base + tier, 7)
    }

    var malignantRatio: Float {
        let base: Float = modeIdentifier == "precision" ? 0.15 : 0.2
        return min(base + Float(tier) * 0.08, 0.45)
    }

    var movementCelerity: CGFloat {
        let base: CGFloat = 50
        return base + CGFloat(tier) * 22
    }

    var spawnCadence: TimeInterval {
        let base: TimeInterval = modeIdentifier == "timed" ? 0.7 : 1.1
        return max(0.5, base - TimeInterval(tier) * 0.08)
    }

    func configure(mode: String) {
        modeIdentifier = mode
        reconstitute()
    }

    func advance(by delta: TimeInterval) {
        elapsed += delta
        let newTier = min(Int(elapsed / 14), 9)
        if newTier != tier {
            tier = newTier
        }
    }

    func reconstitute() {
        tier = 0
        elapsed = 0
    }
}
