import Foundation

final class TallyLedger {
    private(set) var current = 0
    private(set) var coins = 0
    private var modeIdentifier = "classic"

    func configure(mode: String) {
        modeIdentifier = mode
        current = 0
        coins = 0
    }

    func append(base: Int, multiplier: Float, isFever: Bool) {
        let raw = Float(base) * multiplier
        let bonus = isFever ? raw * 0.5 : 0
        current += Int(raw + bonus)
    }

    func registerCoins(variety: QuarryVariety, isFever: Bool) -> Int {
        guard variety == .boon else { return 0 }
        let base = 5
        let earned = isFever ? base * 2 : base
        coins += earned
        return earned
    }

    func persistCoins() {
        guard coins > 0 else { return }
        VaultKeeper.coins += coins
        coins = 0
    }

    func persistZenith() {
        VaultKeeper.enshrine(current, for: modeIdentifier)
    }

    func reconstitute() {
        current = 0
        coins = 0
    }

    func zenith() -> Int {
        VaultKeeper.zenith(for: modeIdentifier)
    }

    func globalZenith() -> Int {
        VaultKeeper.zenith
    }
}
