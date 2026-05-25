import Foundation

enum IntervalMinder {
    static func randomDelay(in range: ClosedRange<TimeInterval>) -> TimeInterval {
        TimeInterval.random(in: range)
    }

    static func formattedSpan(_ seconds: TimeInterval) -> String {
        let m = Int(seconds) / 60
        let s = Int(seconds) % 60
        return String(format: "%d:%02d", m, s)
    }

    static func formattedFractional(_ seconds: TimeInterval) -> String {
        let m = Int(seconds) / 60
        let s = Int(seconds) % 60
        let ms = Int((seconds - Double(Int(seconds))) * 100)
        return String(format: "%d:%02d.%02d", m, s, ms)
    }
}
