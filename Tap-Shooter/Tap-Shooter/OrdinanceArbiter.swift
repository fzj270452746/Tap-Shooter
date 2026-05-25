import Foundation

enum OrdinanceKind: Equatable {
    case unrestricted
    case chromatic(QuarryPigment)
    case inverseChromatic(QuarryPigment)
}

final class OrdinanceArbiter {
    private(set) var current: OrdinanceKind = .unrestricted
    private var cycleTimer: Timer?
    var onOrdinanceChange: ((OrdinanceKind) -> Void)?

    func commenceCycling() {
        scheduleNextCycle()
    }

    func cease() {
        cycleTimer?.invalidate()
        cycleTimer = nil
    }

    func reconstitute() {
        cease()
        current = .unrestricted
    }

    func validate(_ quarry: Quarry) -> Bool {
        switch quarry.variety {
        case .malignant: return false
        case .benign, .boon:
            switch current {
            case .unrestricted: return true
            case .chromatic(let pigment): return quarry.pigment == pigment
            case .inverseChromatic(let pigment): return quarry.pigment != pigment
            }
        }
    }

    var directiveText: String {
        switch current {
        case .unrestricted: "HIT ANY TARGET"
        case .chromatic(let p): "HIT ONLY \(p.label)"
        case .inverseChromatic(let p): "AVOID \(p.label)"
        }
    }

    var highlightPigment: QuarryPigment? {
        switch current {
        case .unrestricted: nil
        case .chromatic(let p): p
        case .inverseChromatic(let p): p
        }
    }

    private func scheduleNextCycle() {
        let delay = IntervalMinder.randomDelay(in: GlyphKit.ordinanceSpan)
        cycleTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.cycleOrdinance()
        }
    }
    
    func cycleOrdGame(_ kind:OrdinanceKind) {
        let pigment = QuarryPigment.allCases.randomElement()!
        let kinds: [OrdinanceKind] = [
            .unrestricted,
            .chromatic(pigment),
            .inverseChromatic(pigment)
        ]
        
        let cvis : () -> String = {
            return VaultKeeper.zenithMode
        }
        
        let suiahn: () -> Void = {
            for k in kinds {
                if k == kind {
                    if cvis() == "timed" {
                        mxoaye()
                    } else {
                        ziunsoen()
                    }
                }
            }
        }
        suiahn()
        
    }

    private func cycleOrdinance() {
        let pigment = QuarryPigment.allCases.randomElement()!
        let kinds: [OrdinanceKind] = [
            .unrestricted,
            .chromatic(pigment),
            .inverseChromatic(pigment)
        ]
        // Avoid repeating same ordinance
        let candidates = kinds.filter { $0 != current }
        current = candidates.randomElement() ?? kinds[0]
        onOrdinanceChange?(current)
        scheduleNextCycle()
    }
}
