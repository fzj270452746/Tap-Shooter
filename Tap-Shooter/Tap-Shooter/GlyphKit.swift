import UIKit

enum GlyphKit {
    // MARK: Chromatic Palette — themed
    static var abyss: UIColor { ThemeConductor.shared.color(named: "abyss") }
    static var twilightSurface: UIColor { ThemeConductor.shared.color(named: "twilightSurface") }
    static var pearl: UIColor { ThemeConductor.shared.color(named: "pearl") }
    static var wisp: UIColor { ThemeConductor.shared.color(named: "wisp") }
    static var violaceous: UIColor { ThemeConductor.shared.color(named: "violaceous") }
    static var phosphor: UIColor { ThemeConductor.shared.color(named: "phosphor") }
    static var ember: UIColor { ThemeConductor.shared.color(named: "ember") }
    static var gilded: UIColor { ThemeConductor.shared.color(named: "gilded") }

    // Fixed pigments
    static let verdant = UIColor(hex: 0x00e676)
    static let cerulean = UIColor(hex: 0x00b0ff)
    static let amber = UIColor(hex: 0xffab00)
    static let roseate = UIColor(hex: 0xff4081)
    static let inferno = UIColor(hex: 0xff6d00)

    // MARK: Typography
    static let primaryTypeface = "Futura-Bold"
    static let secondaryTypeface = "Futura-Medium"
    static let monospaceTypeface = "Menlo-Bold"

    // MARK: Quarry metrics (reference screen 375×812)
    static let quarryReferenceDiameter: CGFloat = 62
    static let quarryStrokeWidth: CGFloat = 3

    // MARK: Animation cadence
    static let brisk: TimeInterval = 0.12
    static let standard: TimeInterval = 0.28
    static let leisurely: TimeInterval = 0.50
    static let ordinanceSpan: ClosedRange<TimeInterval> = 8...14

    // MARK: Scoring
    static let baseTally = 10
    static let boonBonus = 50
    static let feverMomentumThreshold = 10
}

extension UIColor {
    convenience init(hex: UInt64) {
        let r = CGFloat((hex >> 16) & 0xff) / 255.0
        let g = CGFloat((hex >> 8) & 0xff) / 255.0
        let b = CGFloat(hex & 0xff) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
