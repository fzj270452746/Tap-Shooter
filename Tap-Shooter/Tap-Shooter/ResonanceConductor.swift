import UIKit
import CoreHaptics

final class ResonanceConductor {
    private var hapticEngine: CHHapticEngine?
    private var engineNeedsStart = true

    init() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        hapticEngine = try? CHHapticEngine()
        hapticEngine?.stoppedHandler = { [weak self] _ in
            self?.engineNeedsStart = true
        }
        hapticEngine?.resetHandler = { [weak self] in
            self?.engineNeedsStart = true
        }
    }

    func trigger(_ kind: HapticKind) {
        guard VaultKeeper.hapticsEnabled, let engine = hapticEngine else { return }
        if engineNeedsStart {
            try? engine.start()
            engineNeedsStart = false
        }
        guard let pattern = try? kind.pattern() else { return }
        try? engine.makePlayer(with: pattern).start(atTime: 0)
    }

    func triggerImpact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}

enum HapticKind {
    case tap, crunch, flourish, rumble

    func pattern() throws -> CHHapticPattern {
        switch self {
        case .tap:
            let event = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6)],
                relativeTime: 0
            )
            return try CHHapticPattern(events: [event], parameters: [])

        case .crunch:
            let event = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
                ],
                relativeTime: 0
            )
            return try CHHapticPattern(events: [event], parameters: [])

        case .flourish:
            var events: [CHHapticEvent] = []
            for i in 0..<3 {
                events.append(CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5 + Float(i) * 0.15),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4 + Float(i) * 0.2)
                    ],
                    relativeTime: Double(i) * 0.08
                ))
            }
            return try CHHapticPattern(events: events, parameters: [])

        case .rumble:
            let event = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                ],
                relativeTime: 0,
                duration: 0.25
            )
            return try CHHapticPattern(events: [event], parameters: [])
        }
    }
}
