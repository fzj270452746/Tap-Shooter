import SpriteKit

enum SplinterKind { case bloom, rupture, spangle, feverBurst }

enum Splinter {
    static func conjure(_ kind: SplinterKind, at point: CGPoint) -> SKEmitterNode {
        return generateEmitter(kind, at: point)
    }

    private static func generateEmitter(_ kind: SplinterKind, at point: CGPoint) -> SKEmitterNode {
        let e = SKEmitterNode()
        e.position = point
        e.particleBirthRate = kind.birthRate
        e.numParticlesToEmit = kind.particleCount
        e.particleLifetime = kind.lifetime
        e.particleLifetimeRange = kind.lifetime * 0.3
        e.particleSpeed = kind.speed
        e.particleSpeedRange = kind.speed * 0.4
        e.emissionAngle = kind.emissionAngle
        e.emissionAngleRange = kind.angleRange
        e.particleAlpha = kind.alpha
        e.particleAlphaRange = 0.2
        e.particleAlphaSpeed = -kind.alpha / kind.lifetime
        e.particleScale = kind.scale
        e.particleScaleRange = 0.1
        e.particleScaleSpeed = -kind.scale / kind.lifetime
        e.particleColor = kind.color
        e.particleColorBlendFactor = 1
        e.particleBlendMode = .add
        e.particleTexture = generateSparkTexture()
        return e
    }

    private static func generateSparkTexture() -> SKTexture {
        let size = CGSize(width: 12, height: 12)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            let colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
            guard let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors as CFArray,
                locations: [0, 1]
            ) else { return }
            let center = CGPoint(x: 6, y: 6)
            ctx.cgContext.drawRadialGradient(
                gradient,
                startCenter: center, startRadius: 0,
                endCenter: center, endRadius: 6,
                options: []
            )
        }
        return SKTexture(image: image)
    }
}

private extension SplinterKind {
    var birthRate: CGFloat {
        switch self {
        case .bloom: 400
        case .rupture: 300
        case .spangle: 150
        case .feverBurst: 600
        }
    }

    var particleCount: Int {
        switch self {
        case .bloom: 25
        case .rupture: 20
        case .spangle: 15
        case .feverBurst: 40
        }
    }

    var lifetime: CGFloat {
        switch self {
        case .bloom: 0.35
        case .rupture: 0.25
        case .spangle: 0.55
        case .feverBurst: 0.45
        }
    }

    var speed: CGFloat {
        switch self {
        case .bloom: 180
        case .rupture: 220
        case .spangle: 100
        case .feverBurst: 250
        }
    }

    var emissionAngle: CGFloat {
        switch self {
        case .bloom, .spangle, .feverBurst: 0
        case .rupture: .pi
        }
    }

    var angleRange: CGFloat {
        switch self {
        case .bloom: .pi * 2
        case .rupture: .pi * 0.4
        case .spangle: .pi * 2
        case .feverBurst: .pi * 2
        }
    }

    var alpha: CGFloat { 0.9 }
    var scale: CGFloat {
        switch self {
        case .bloom: 0.6
        case .rupture: 0.8
        case .spangle: 0.4
        case .feverBurst: 0.7
        }
    }

    var color: UIColor {
        switch self {
        case .bloom: GlyphKit.phosphor
        case .rupture: GlyphKit.ember
        case .spangle: GlyphKit.gilded
        case .feverBurst: GlyphKit.roseate
        }
    }
}
