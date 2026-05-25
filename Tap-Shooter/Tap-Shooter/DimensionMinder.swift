import UIKit

enum DimensionMinder {
    static let referenceSize = CGSize(width: 375, height: 812)

    static var canvas: CGRect { UIScreen.main.bounds }
    static var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }

    static var scaleFactor: CGFloat {
        let w = canvas.width / referenceSize.width
        let h = canvas.height / referenceSize.height
        return min(w, h)
    }

    static func scaled(_ value: CGFloat) -> CGFloat { value * scaleFactor }

    static var safeTop: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first?.safeAreaInsets.top }.first ?? 44
    }

    static var safeBottom: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first?.safeAreaInsets.bottom }.first ?? 34
    }

    static var playableRegion: CGRect {
        let hudBand: CGFloat = scaled(100)
        return CGRect(
            x: scaled(16), y: safeTop + hudBand,
            width: canvas.width - scaled(32),
            height: canvas.height - safeTop - safeBottom - hudBand - scaled(16)
        )
    }

    static var hudY: CGFloat { safeTop + scaled(44) }

    static var quarryDiameter: CGFloat { scaled(GlyphKit.quarryReferenceDiameter) }

    static func clampedQuarryLocus(center: CGPoint, diameter: CGFloat) -> CGPoint {
        let r = diameter / 2
        let zone = playableRegion
        return CGPoint(
            x: min(max(center.x, zone.minX + r), zone.maxX - r),
            y: min(max(center.y, zone.minY + r), zone.maxY - r)
        )
    }

    static func randomLocus(diameter: CGFloat) -> CGPoint {
        let zone = playableRegion
        let r = diameter / 2
        let x = CGFloat.random(in: (zone.minX + r)...(zone.maxX - r))
        let y = CGFloat.random(in: (zone.minY + r)...(zone.maxY - r))
        return CGPoint(x: x, y: y)
    }
}
