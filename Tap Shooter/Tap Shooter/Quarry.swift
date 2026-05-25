import SpriteKit

enum QuarryVariety { case benign, malignant, boon }

enum QuarryShape: CaseIterable {
    case circle
    case hexagon
    case pentagon
    case square
    case triangle
    case diamond
    case star

    static func randomPlayableShape() -> QuarryShape {
        [.hexagon, .pentagon, .square, .triangle, .diamond, .star].randomElement() ?? .hexagon
    }
}

enum QuarryPigment: CaseIterable {
    case verdant, cerulean, amber, violaceous

    var uiColor: UIColor {
        switch self {
        case .verdant: GlyphKit.verdant
        case .cerulean: GlyphKit.cerulean
        case .amber: GlyphKit.amber
        case .violaceous: GlyphKit.violaceous
        }
    }

    var label: String {
        switch self {
        case .verdant: "GREEN"
        case .cerulean: "BLUE"
        case .amber: "AMBER"
        case .violaceous: "VIOLET"
        }
    }
}

enum QuarryDynamics: Equatable {
    case stationary
    case drifting(dx: CGFloat, dy: CGFloat)
    case ricocheting(dx: CGFloat, dy: CGFloat)

    var velocity: CGVector {
        switch self {
        case .stationary: .zero
        case .drifting(let dx, let dy), .ricocheting(let dx, let dy): CGVector(dx: dx, dy: dy)
        }
    }

    static func randomDrift(speed: CGFloat) -> QuarryDynamics {
        let angle = CGFloat.random(in: 0...(2 * .pi))
        return .drifting(dx: cos(angle) * speed, dy: sin(angle) * speed)
    }

    static func randomRicochet(speed: CGFloat) -> QuarryDynamics {
        let angle = CGFloat.random(in: 0...(2 * .pi))
        return .ricocheting(dx: cos(angle) * speed, dy: sin(angle) * speed)
    }
}

final class Quarry: SKSpriteNode {
    let variety: QuarryVariety
    let pigment: QuarryPigment
    let shape: QuarryShape
    let baseTally: Int
    var dynamics: QuarryDynamics
    var lifespan: TimeInterval = 0

    private init(variety: QuarryVariety, pigment: QuarryPigment, diameter: CGFloat, dynamics: QuarryDynamics) {
        self.variety = variety
        self.pigment = pigment
        self.shape = variety == .boon ? .circle : QuarryShape.randomPlayableShape()
        self.baseTally = variety == .boon ? GlyphKit.boonBonus : GlyphKit.baseTally
        self.dynamics = dynamics
        let tex = Self.renderTexture(variety: variety, pigment: pigment, shape: shape, diameter: diameter)
        super.init(texture: tex, color: .clear, size: CGSize(width: diameter, height: diameter))
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Factory

    static func conjure(
        variety: QuarryVariety,
        pigment: QuarryPigment,
        at locus: CGPoint,
        diameter: CGFloat,
        dynamics: QuarryDynamics
    ) -> Quarry {
        let q = Quarry(variety: variety, pigment: pigment, diameter: diameter, dynamics: dynamics)
        q.position = locus
        q.name = "quarry"
        return q
    }

    // MARK: - Texture generation

    private static func renderTexture(variety: QuarryVariety, pigment: QuarryPigment, shape: QuarryShape, diameter: CGFloat) -> SKTexture {
        let size = CGSize(width: diameter, height: diameter)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            let rect = CGRect(origin: .zero, size: size).insetBy(dx: 3, dy: 3)
            let path = Self.path(for: shape, in: rect)
            let fillColor = variety == .boon ? GlyphKit.gilded : pigment.uiColor

            // Outer glow
            ctx.cgContext.setShadow(offset: .zero, blur: 12, color: fillColor.withAlphaComponent(0.5).cgColor)
            fillColor.setFill()
            path.fill()
            ctx.cgContext.setShadow(offset: .zero, blur: 0, color: nil)

            // Radial gradient fill
            let colors = [fillColor.brighter(by: 0.3).cgColor, fillColor.cgColor]
            guard let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors as CFArray,
                locations: [0, 1]
            ) else { return }

            ctx.cgContext.saveGState()
            path.addClip()
            let center = CGPoint(x: diameter / 2, y: diameter / 2)
            ctx.cgContext.drawRadialGradient(
                gradient,
                startCenter: center, startRadius: 0,
                endCenter: center, endRadius: diameter / 2,
                options: []
            )
            ctx.cgContext.restoreGState()

            // Stroke
            UIColor.white.withAlphaComponent(0.4).setStroke()
            path.lineWidth = GlyphKit.quarryStrokeWidth
            path.stroke()

            if variety == .boon {
                let assetSize = diameter * 0.46
                let assetRect = CGRect(
                    x: (diameter - assetSize) / 2,
                    y: (diameter - assetSize) / 2,
                    width: assetSize,
                    height: assetSize
                )
                UIImage(named: "shoot_target")?.draw(in: assetRect)
                return
            }

            // Bad target cross mark
            if variety == .malignant {
                let inset = rect.insetBy(dx: diameter * 0.25, dy: diameter * 0.25)
                let cross = UIBezierPath()
                cross.move(to: CGPoint(x: inset.minX, y: inset.minY))
                cross.addLine(to: CGPoint(x: inset.maxX, y: inset.maxY))
                cross.move(to: CGPoint(x: inset.maxX, y: inset.minY))
                cross.addLine(to: CGPoint(x: inset.minX, y: inset.maxY))
                UIColor.white.withAlphaComponent(0.7).setStroke()
                cross.lineWidth = 2.5
                cross.lineCapStyle = .round
                cross.stroke()
            }

        }
        return SKTexture(image: image)
    }

    func hitTestContains(_ point: CGPoint) -> Bool {
        guard let parent else { return false }
        let nodePoint = convert(point, from: parent)
        let localPoint = CGPoint(x: nodePoint.x + size.width / 2, y: nodePoint.y + size.height / 2)
        let path = Self.path(for: shape, in: CGRect(x: 0, y: 0, width: size.width, height: size.height).insetBy(dx: 3, dy: 3))
        return path.contains(localPoint)
    }

    private static func path(for shape: QuarryShape, in rect: CGRect) -> UIBezierPath {
        switch shape {
        case .circle:
            return UIBezierPath(ovalIn: rect)
        case .square:
            return UIBezierPath(rect: rect)
        case .triangle:
            return Self.polygonPath(sides: 3, in: rect, rotation: -.pi / 2)
        case .diamond:
            let path = UIBezierPath()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.close()
            return path
        case .pentagon:
            return Self.polygonPath(sides: 5, in: rect, rotation: -.pi / 2)
        case .hexagon:
            return Self.polygonPath(sides: 6, in: rect, rotation: -.pi / 6)
        case .star:
            return Self.starPath(in: rect)
        }
    }

    private static func polygonPath(sides: Int, in rect: CGRect, rotation: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        for index in 0..<sides {
            let angle = rotation + (CGFloat(index) * 2 * .pi / CGFloat(sides))
            let point = CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )
            if index == 0 { path.move(to: point) } else { path.addLine(to: point) }
        }
        path.close()
        return path
    }

    private static func starPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.48
        let spikes = 5
        for index in 0..<(spikes * 2) {
            let radius = index.isMultiple(of: 2) ? outerRadius : innerRadius
            let angle = -CGFloat.pi / 2 + CGFloat(index) * .pi / CGFloat(spikes)
            let point = CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )
            if index == 0 { path.move(to: point) } else { path.addLine(to: point) }
        }
        path.close()
        return path
    }

    // MARK: - Animation

    func enactBirthFlourish() {
        setScale(0.01)
        let pop = SKAction.sequence([
            SKAction.scale(to: 1.15, duration: GlyphKit.brisk),
            SKAction.scale(to: 0.95, duration: 0.06),
            SKAction.scale(to: 1.0, duration: 0.06)
        ])
        run(pop)
    }

    func enactDeathFlourish(completion: @escaping () -> Void) {
        let vanish = SKAction.sequence([
            SKAction.scale(to: 1.3, duration: 0.06),
            SKAction.fadeOut(withDuration: 0.1),
            SKAction.removeFromParent()
        ])
        run(vanish, completion: completion)
    }

    func enactPulse() {
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.08, duration: 0.4),
            SKAction.scale(to: 1.0, duration: 0.4)
        ])
        run(SKAction.repeatForever(pulse), withKey: "pulse")
    }

    func advance(by delta: TimeInterval, in bounds: CGRect) {
        lifespan += delta
        let vel = dynamics.velocity
        guard vel.dx != 0 || vel.dy != 0 else { return }

        var newX = position.x + vel.dx * CGFloat(delta)
        var newY = position.y + vel.dy * CGFloat(delta)
        var newDx = vel.dx
        var newDy = vel.dy

        let r = size.width / 2
        if case .ricocheting = dynamics {
            var bounced = false
            if newX - r < bounds.minX { newX = bounds.minX + r; newDx = abs(newDx); bounced = true }
            if newX + r > bounds.maxX { newX = bounds.maxX - r; newDx = -abs(newDx); bounced = true }
            if newY - r < bounds.minY { newY = bounds.minY + r; newDy = abs(newDy); bounced = true }
            if newY + r > bounds.maxY { newY = bounds.maxY - r; newDy = -abs(newDy); bounced = true }
            if bounced {
                dynamics = .ricocheting(dx: newDx, dy: newDy)
            }
        } else {
            // Drifting wraps around
            if newX - r > bounds.maxX { newX = bounds.minX - r }
            if newX + r < bounds.minX { newX = bounds.maxX + r }
            if newY - r > bounds.maxY { newY = bounds.minY - r }
            if newY + r < bounds.minY { newY = bounds.maxY + r }
        }

        position = CGPoint(x: newX, y: newY)
    }
}

private extension UIColor {
    func brighter(by amount: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: max(0, s - 0.15), brightness: min(1, b + amount), alpha: a)
    }
}
