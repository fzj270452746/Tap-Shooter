import SpriteKit

enum ArenaPhase { case prelude, engagement, intermission, epilogue }

final class ArenaScene: SKScene {
    var modeIdentifier = "classic"
    var onQuit: (() -> Void)?

    private var phase = ArenaPhase.prelude
    private var quarries: [Quarry] = []
    private var lastSpawnTime: TimeInterval = 0
    private var lastUpdateTime: TimeInterval = 0
    private var gameSpan: TimeInterval = 0
    private var remainingSpan: TimeInterval = 60
    private var targetsStruck = 0
    private let starfield = SKNode()

    // Systems
    private let momentum = MomentumEngine()
    private let ordinance = OrdinanceArbiter()
    private let tally = TallyLedger()
    private let escalation = EscalationConductor()
    private let resonance = ResonanceConductor()

    // HUD
    private var tallyNode = SKLabelNode()
    private var comboNode = SKLabelNode()
    private var directiveNode = SKLabelNode()
    private var chronoNode = SKLabelNode()
    private var pauseKey = SKNode()
    private var pauseOverlay: SKNode?
    private var feverGlow: SKShapeNode?
    private var coinIcon = SKShapeNode()
    private var coinLabelNode = SKLabelNode()

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        backgroundColor = GlyphKit.abyss
        anchorPoint = CGPoint(x: 0, y: 0)
        setupCamera()
        renderBackdrop()
        conjureStarfield()
        setupHUD()
        tally.configure(mode: modeIdentifier)
        escalation.configure(mode: modeIdentifier)
        ordinance.onOrdinanceChange = { [weak self] _ in self?.refreshDirectiveDisplay() }
        commencePrelude()
    }

    private func setupCamera() {
        let cam = SKCameraNode()
        camera = cam
        cam.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(cam)
    }

    private func renderBackdrop() {
        let tex = SKTexture(image: UIGraphicsImageRenderer(size: size).image { ctx in
            let colors = [GlyphKit.abyss.cgColor, GlyphKit.twilightSurface.cgColor]
            guard let grad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: [0, 1]) else { return }
            ctx.cgContext.drawLinearGradient(grad, start: .zero, end: CGPoint(x: size.width, y: size.height), options: [])
        })
        let bg = SKSpriteNode(texture: tex, size: size)
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.zPosition = -10
        addChild(bg)
    }

    private func conjureStarfield() {
        starfield.zPosition = -9
        addChild(starfield)
        let count = DimensionMinder.isPad ? 80 : 40
        for _ in 0..<count {
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.6...2.2))
            star.fillColor = GlyphKit.pearl.withAlphaComponent(CGFloat.random(in: 0.15...0.55))
            star.strokeColor = .clear
            star.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: 0...size.height))
            star.zPosition = -9
            starfield.addChild(star)

            let drift = SKAction.sequence([
                SKAction.moveBy(x: CGFloat.random(in: -30...30), y: CGFloat.random(in: -30...30), duration: TimeInterval.random(in: 4...10)),
                SKAction.moveBy(x: CGFloat.random(in: -30...30), y: CGFloat.random(in: -30...30), duration: TimeInterval.random(in: 4...10))
            ])
            star.run(SKAction.repeatForever(drift))
        }
    }

    // MARK: - HUD

    private func setupHUD() {
        let sf = DimensionMinder.scaleFactor
        let y = DimensionMinder.hudY

        tallyNode = SKLabelNode(fontNamed: GlyphKit.monospaceTypeface)
        tallyNode.text = "0"
        tallyNode.fontSize = 28 * sf
        tallyNode.fontColor = GlyphKit.pearl
        tallyNode.position = CGPoint(x: size.width * 0.08, y: y)
        tallyNode.horizontalAlignmentMode = .left
        tallyNode.verticalAlignmentMode = .center
        addChild(tallyNode)

        coinIcon = SKShapeNode(circleOfRadius: 5 * sf)
        coinIcon.fillColor = GlyphKit.gilded
        coinIcon.strokeColor = .clear
        coinIcon.position = CGPoint(x: size.width * 0.08, y: y - 22 * sf)
        addChild(coinIcon)

        coinLabelNode = SKLabelNode(fontNamed: GlyphKit.monospaceTypeface)
        coinLabelNode.text = "\(VaultKeeper.coins)"
        coinLabelNode.fontSize = 15 * sf
        coinLabelNode.fontColor = GlyphKit.gilded
        coinLabelNode.position = CGPoint(x: size.width * 0.08 + 14 * sf, y: y - 22 * sf)
        coinLabelNode.horizontalAlignmentMode = .left
        coinLabelNode.verticalAlignmentMode = .center
        addChild(coinLabelNode)

        comboNode = SKLabelNode(fontNamed: GlyphKit.primaryTypeface)
        comboNode.text = ""
        comboNode.fontSize = 18 * sf
        comboNode.fontColor = GlyphKit.gilded
        comboNode.position = CGPoint(x: size.width / 2, y: y)
        comboNode.horizontalAlignmentMode = .center
        comboNode.verticalAlignmentMode = .center
        comboNode.alpha = 0
        addChild(comboNode)

        directiveNode = SKLabelNode(fontNamed: GlyphKit.secondaryTypeface)
        directiveNode.text = "HIT ANY TARGET"
        directiveNode.fontSize = 13 * sf
        directiveNode.fontColor = GlyphKit.phosphor
        directiveNode.position = CGPoint(x: size.width * 0.92, y: y)
        directiveNode.horizontalAlignmentMode = .right
        directiveNode.verticalAlignmentMode = .center
        addChild(directiveNode)

        chronoNode = SKLabelNode(fontNamed: GlyphKit.monospaceTypeface)
        chronoNode.fontSize = 14 * sf
        chronoNode.fontColor = GlyphKit.wisp
        chronoNode.position = CGPoint(x: size.width * 0.92, y: y - 22 * sf)
        chronoNode.horizontalAlignmentMode = .right
        chronoNode.verticalAlignmentMode = .center
        chronoNode.alpha = modeIdentifier == "timed" ? 1 : 0
        addChild(chronoNode)

        pauseKey = conjurePauseKey()
        pauseKey.position = CGPoint(x: size.width - DimensionMinder.scaled(28), y: size.height - DimensionMinder.safeTop - DimensionMinder.scaled(28))
        pauseKey.alpha = 0
        addChild(pauseKey)
    }

    private func conjurePauseKey() -> SKNode {
        let r: CGFloat = DimensionMinder.scaled(15)
        let container = SKNode()

        let bg = SKShapeNode(circleOfRadius: r)
        bg.fillColor = GlyphKit.twilightSurface
        bg.strokeColor = GlyphKit.wisp.withAlphaComponent(0.4)
        bg.lineWidth = 1.5
        bg.position = .zero
        container.addChild(bg)

        let barW: CGFloat = DimensionMinder.scaled(3.5)
        let barH: CGFloat = DimensionMinder.scaled(12)
        let gap: CGFloat = DimensionMinder.scaled(3)
        for sign in [-1, 1] {
            let bar = SKShapeNode(rectOf: CGSize(width: barW, height: barH), cornerRadius: 1)
            bar.fillColor = GlyphKit.pearl
            bar.strokeColor = .clear
            bar.position = CGPoint(x: CGFloat(sign) * gap, y: 0)
            container.addChild(bar)
        }

        return container
    }

    private func refreshHUD() {
        tallyNode.text = "\(tally.current)"
        coinLabelNode.text = "\(VaultKeeper.coins + tally.coins)"
        if momentum.streak > 1 {
            comboNode.text = "x\(Int(momentum.multiplier)) · \(momentum.streak)"
            comboNode.alpha = 1
        } else {
            comboNode.alpha = 0
        }
        if modeIdentifier == "timed" {
            chronoNode.text = IntervalMinder.formattedSpan(max(0, remainingSpan))
        }
    }

    private func refreshDirectiveDisplay() {
        let text = ordinance.directiveText
        directiveNode.text = text

        let pop = SKAction.sequence([
            SKAction.scale(to: 1.25, duration: 0.08),
            SKAction.scale(to: 1.0, duration: 0.1)
        ])
        directiveNode.run(pop)

        if let pigment = ordinance.highlightPigment {
            directiveNode.fontColor = pigment.uiColor
        } else {
            directiveNode.fontColor = GlyphKit.phosphor
        }
    }

    // MARK: - Phases

    private func commencePrelude() {
        phase = .prelude
        let countdown = ["3", "2", "1", "GO"]
        let sf = DimensionMinder.scaleFactor

        for (i, text) in countdown.enumerated() {
            let node = SKLabelNode(fontNamed: GlyphKit.primaryTypeface)
            node.text = text
            node.fontSize = (text == "GO" ? 42 : 56) * sf
            node.fontColor = text == "GO" ? GlyphKit.phosphor : GlyphKit.pearl
            node.position = CGPoint(x: size.width / 2, y: size.height / 2)
            node.alpha = 0
            node.setScale(1.5)
            node.zPosition = 100
            addChild(node)

            let delay = Double(i) * 0.6
            node.run(SKAction.sequence([
                SKAction.wait(forDuration: delay),
                SKAction.group([
                    SKAction.fadeAlpha(to: 1, duration: 0.08),
                    SKAction.scale(to: 1.0, duration: 0.15)
                ]),
                SKAction.wait(forDuration: 0.3),
                SKAction.fadeOut(withDuration: 0.12),
                SKAction.removeFromParent()
            ]))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.commenceEngagement()
        }
    }

    private func commenceEngagement() {
        phase = .engagement
        gameSpan = 0
        targetsStruck = 0
        momentum.reconstitute()
        tally.reconstitute()
        escalation.reconstitute()
        ordinance.reconstitute()
        refreshHUD()
        refreshDirectiveDisplay()
        ordinance.commenceCycling()
        manifestWave()
        startGameLoop()
        pauseKey.run(SKAction.fadeIn(withDuration: GlyphKit.brisk))
    }

    private func startGameLoop() {
        lastSpawnTime = 0
        lastUpdateTime = 0
    }

    private func terminateEngagement() {
        guard phase == .engagement else { return }
        phase = .epilogue
        ordinance.cease()
        expungeAllQuarries()
        tally.persistCoins()
        tally.persistZenith()
        pauseKey.run(SKAction.fadeOut(withDuration: GlyphKit.brisk))
        dismissPauseOverlay()

        let pane = EpiloguePane()
        pane.delegate = self
        addChild(pane)
        pane.unveil(
            finalTally: tally.current,
            zenith: tally.zenith(),
            pinnacleStreak: momentum.pinnacleStreak,
            duration: gameSpan,
            in: self
        )
    }

    // MARK: - Pause

    private func enactIntermission() {
        phase = .intermission
        pauseKey.run(SKAction.fadeOut(withDuration: GlyphKit.brisk))

        let sf = DimensionMinder.scaleFactor
        let overlay = SKNode()
        overlay.zPosition = 100

        let veil = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        veil.fillColor = UIColor.black.withAlphaComponent(0.55)
        veil.alpha = 0
        overlay.addChild(veil)

        let titleNode = SKLabelNode(fontNamed: GlyphKit.primaryTypeface)
        titleNode.text = "PAUSED"
        titleNode.fontSize = 30 * sf
        titleNode.fontColor = GlyphKit.pearl
        titleNode.position = CGPoint(x: size.width / 2, y: size.height / 2 + 30 * sf)
        titleNode.verticalAlignmentMode = .center
        titleNode.horizontalAlignmentMode = .center
        titleNode.alpha = 0
        overlay.addChild(titleNode)

        let resumeKey = conjurePauseKeyButton("RESUME", color: GlyphKit.violaceous)
        resumeKey.position = CGPoint(x: size.width / 2, y: size.height / 2 - 30 * sf)
        resumeKey.alpha = 0
        resumeKey.name = "resumeKey"
        overlay.addChild(resumeKey)

        let menuKey = conjurePauseKeyButton("MENU", color: GlyphKit.wisp)
        menuKey.position = CGPoint(x: size.width / 2, y: size.height / 2 - 82 * sf)
        menuKey.alpha = 0
        menuKey.name = "menuKey"
        overlay.addChild(menuKey)

        addChild(overlay)
        pauseOverlay = overlay

        veil.run(SKAction.fadeAlpha(to: 1, duration: GlyphKit.standard))
        let nodes: [SKNode] = [titleNode, resumeKey, menuKey]
        for (i, node) in nodes.enumerated() {
            node.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.1 + Double(i) * 0.06),
                SKAction.fadeIn(withDuration: GlyphKit.standard)
            ]))
        }
    }

    private func dissolveIntermission() {
        guard let overlay = pauseOverlay else { return }
        overlay.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: GlyphKit.brisk),
            SKAction.removeFromParent()
        ]))
        pauseOverlay = nil
        phase = .engagement
        pauseKey.run(SKAction.fadeIn(withDuration: GlyphKit.brisk))
    }

    private func dismissPauseOverlay() {
        pauseOverlay?.removeFromParent()
        pauseOverlay = nil
    }

    private func conjurePauseKeyButton(_ text: String, color: UIColor) -> SKNode {
        let bw: CGFloat = DimensionMinder.scaled(140)
        let bh: CGFloat = DimensionMinder.scaled(40)
        let container = SKNode()

        let bg = SKShapeNode(rectOf: CGSize(width: bw, height: bh), cornerRadius: 8)
        bg.fillColor = color
        bg.strokeColor = .clear
        bg.position = .zero
        container.addChild(bg)

        let lbl = SKLabelNode(fontNamed: GlyphKit.primaryTypeface)
        lbl.text = text
        lbl.fontSize = DimensionMinder.scaled(16)
        lbl.fontColor = .white
        lbl.verticalAlignmentMode = .center
        lbl.horizontalAlignmentMode = .center
        lbl.position = .zero
        container.addChild(lbl)

        return container
    }

    // MARK: - Spawning

    private func manifestWave() {
        expungeAllQuarries()

        let count = escalation.quarryCount
        let badCount = max(1, Int(Float(count) * escalation.malignantRatio))
        let boonRoll = Int.random(in: 0...10)
        let boonCount: Int
        if escalation.tier >= 6, boonRoll < 3 { boonCount = 2 }
        else if boonRoll < 3 { boonCount = 1 }
        else { boonCount = 0 }
        let goodCount = count - badCount - boonCount
        let diameter = DimensionMinder.quarryDiameter
        let speed = escalation.movementCelerity

        for _ in 0..<goodCount {
            let q = Quarry.conjure(
                variety: .benign,
                pigment: QuarryPigment.allCases.randomElement()!,
                at: DimensionMinder.randomLocus(diameter: diameter),
                diameter: diameter,
                dynamics: randomDynamics(speed: speed)
            )
            addChild(q); q.enactBirthFlourish()
            quarries.append(q)
        }

        for _ in 0..<badCount {
            let q = Quarry.conjure(
                variety: .malignant,
                pigment: QuarryPigment.allCases.randomElement()!,
                at: DimensionMinder.randomLocus(diameter: diameter),
                diameter: diameter,
                dynamics: randomDynamics(speed: speed)
            )
            addChild(q); q.enactBirthFlourish()
            quarries.append(q)
        }

        for _ in 0..<boonCount {
            let q = Quarry.conjure(
                variety: .boon,
                pigment: QuarryPigment.allCases.randomElement()!,
                at: DimensionMinder.randomLocus(diameter: diameter),
                diameter: diameter,
                dynamics: .stationary
            )
            addChild(q); q.enactBirthFlourish(); q.enactPulse()
            quarries.append(q)
        }

        // Ensure at least one benign quarry matches the current ordinance
        let benignQuarries = quarries.filter { $0.variety == .benign }
        if let requiredPigment = ordinance.highlightPigment,
           !benignQuarries.contains(where: { ordinance.validate($0) }),
           let first = benignQuarries.first {
            // Re-render the first benign quarry with matching pigment
            let locus = first.position
            let dyn = first.dynamics
            first.removeFromParent()
            quarries.removeAll { $0 === first }
            let corrected = Quarry.conjure(
                variety: .benign, pigment: requiredPigment,
                at: locus, diameter: diameter, dynamics: dyn
            )
            addChild(corrected); corrected.enactBirthFlourish()
            quarries.append(corrected)
        }
    }

    private func randomDynamics(speed: CGFloat) -> QuarryDynamics {
        let roll = Int.random(in: 0...10)
        if roll < 3 + escalation.tier / 2 { return .stationary }
        if roll < 7 + escalation.tier / 3 { return .randomDrift(speed: speed * 0.6) }
        return .randomRicochet(speed: speed)
    }

    private func expungeAllQuarries() {
        for q in quarries {
            q.removeAllActions()
            q.removeFromParent()
        }
        quarries.removeAll()
    }

    // MARK: - Game Loop

    override func update(_ currentTime: TimeInterval) {
        guard phase == .engagement else { return }

        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let delta = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        let clampedDelta = min(delta, 1.0 / 30.0)

        gameSpan += clampedDelta
        escalation.advance(by: clampedDelta)

        if modeIdentifier == "timed" {
            remainingSpan = 60 - gameSpan
            refreshHUD()
            if remainingSpan <= 0 {
                terminateEngagement()
                return
            }
        }

        let bounds = DimensionMinder.playableRegion
        for q in quarries {
            q.advance(by: clampedDelta, in: bounds)
        }

        // Spawn based on cadence
        if gameSpan - lastSpawnTime >= escalation.spawnCadence {
            lastSpawnTime = gameSpan
            manifestWave()
        }
    }

    // MARK: - Touch

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)

        switch phase {
        case .engagement:
            // Pause button check — allow in entire HUD band
            if pauseKey.contains(loc) && pauseKey.alpha > 0 {
                enactIntermission()
                return
            }
            // HUD exclusion zone
            if loc.y > size.height - DimensionMinder.safeBottom - 20 || loc.y < DimensionMinder.safeTop + 20 { return }

            let hit = quarries
                .filter { $0.hitTestContains(loc) }
                .max { $0.zPosition < $1.zPosition }
            guard let quarry = hit else {
                enactMissEffect(at: loc)
                return
            }
            processStrike(on: quarry, at: loc)

        case .intermission:
            guard let overlay = pauseOverlay else { return }
            let resumeKey = overlay.childNode(withName: "resumeKey") as? SKNode
            let menuKey = overlay.childNode(withName: "menuKey") as? SKNode
            if let key = resumeKey, key.contains(loc) {
                dissolveIntermission()
            } else if let key = menuKey, key.contains(loc) {
                tally.persistCoins()
                onQuit?()
            }

        default:
            break
        }
    }

    private func processStrike(on quarry: Quarry, at loc: CGPoint) {
        // Malignant = instant game over
        guard quarry.variety != .malignant else {
            enactMalignantStrike(quarry, at: loc)
            return
        }

        // Check ordinance
        guard ordinance.validate(quarry) else {
            // Wrong color — combo reset only
            momentum.reset()
            refreshHUD()
            resonance.triggerImpact(.medium)
            enactInvalidStrike(quarry, at: loc)
            return
        }

        // Valid hit
        targetsStruck += 1
        momentum.increment()
        tally.append(base: quarry.baseTally, multiplier: momentum.multiplier, isFever: momentum.isFever)

        let coinsEarned = tally.registerCoins(
            variety: quarry.variety,
            isFever: momentum.isFever
        )
        refreshHUD()
        resonance.trigger(momentum.isFever ? .flourish : .tap)

        enactValidStrike(quarry, at: loc)
        if coinsEarned > 0 {
            conjureCoinDrop(at: quarry.position, amount: coinsEarned)
        }

        if momentum.isFever && feverGlow == nil {
            enactFeverOnset()
        }

        quarries.removeAll { $0 === quarry }
    }

    // MARK: - Effects

    private func enactValidStrike(_ quarry: Quarry, at loc: CGPoint) {
        let emitter = Splinter.conjure(momentum.isFever ? .feverBurst : .bloom, at: quarry.position)
        addChild(emitter)
        emitter.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.6),
            SKAction.removeFromParent()
        ]))
        quarry.enactDeathFlourish {}
    }

    private func conjureCoinDrop(at origin: CGPoint, amount: Int) {
        let sf = DimensionMinder.scaleFactor
        let target = CGPoint(x: size.width * 0.08 + 7 * sf, y: DimensionMinder.hudY - 22 * sf)

        let coin = SKShapeNode(circleOfRadius: 6 * sf)
        coin.fillColor = GlyphKit.gilded
        coin.strokeColor = GlyphKit.gilded.withAlphaComponent(0.5)
        coin.lineWidth = 1
        coin.position = origin
        coin.zPosition = 25
        addChild(coin)

        let label = SKLabelNode(fontNamed: GlyphKit.monospaceTypeface)
        label.text = "+\(amount)"
        label.fontSize = 11 * sf
        label.fontColor = GlyphKit.gilded
        label.position = CGPoint(x: origin.x, y: origin.y + 12 * sf)
        label.zPosition = 25
        addChild(label)

        let fly = SKAction.move(to: target, duration: 0.35)
        fly.timingMode = .easeIn
        coin.run(SKAction.sequence([
            SKAction.group([fly, SKAction.scale(to: 0.3, duration: 0.35)]),
            SKAction.removeFromParent()
        ]))

        label.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.2),
            SKAction.fadeOut(withDuration: 0.18),
            SKAction.removeFromParent()
        ]))

        coinLabelNode.run(SKAction.sequence([
            SKAction.scale(to: 1.3, duration: 0.08),
            SKAction.scale(to: 1.0, duration: 0.1)
        ]))
    }

    private func enactMalignantStrike(_ quarry: Quarry, at loc: CGPoint) {
        resonance.trigger(.crunch)
        resonance.triggerImpact(.heavy)

        let emitter = Splinter.conjure(.rupture, at: quarry.position)
        addChild(emitter)
        emitter.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.removeFromParent()
        ]))

        // Red flash overlay
        let flash = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        flash.fillColor = GlyphKit.ember.withAlphaComponent(0.3)
        flash.zPosition = 50
        flash.alpha = 0
        addChild(flash)
        flash.run(SKAction.sequence([
            SKAction.fadeAlpha(to: 1, duration: 0.06),
            SKAction.fadeOut(withDuration: 0.25),
            SKAction.removeFromParent()
        ]))

        enactShudder()
        quarry.enactDeathFlourish {}

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            self?.terminateEngagement()
        }
    }

    private func enactInvalidStrike(_ quarry: Quarry, at loc: CGPoint) {
        resonance.triggerImpact(.light)
        quarry.enactDeathFlourish {}
        quarries.removeAll { $0 === quarry }
    }

    private func enactMissEffect(at loc: CGPoint) {
        let dot = SKShapeNode(circleOfRadius: 3)
        dot.fillColor = GlyphKit.wisp
        dot.strokeColor = .clear
        dot.position = loc
        dot.zPosition = 20
        addChild(dot)
        dot.run(SKAction.sequence([
            SKAction.group([
                SKAction.fadeOut(withDuration: 0.3),
                SKAction.scale(to: 3, duration: 0.3)
            ]),
            SKAction.removeFromParent()
        ]))
    }

    private func enactFeverOnset() {
        let glow = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        glow.fillColor = GlyphKit.gilded.withAlphaComponent(0.06)
        glow.strokeColor = .clear
        glow.zPosition = 49
        addChild(glow)
        glow.run(SKAction.sequence([
            SKAction.fadeAlpha(to: 1, duration: 0.3),
            SKAction.fadeOut(withDuration: 1.5)
        ]))
        feverGlow = glow

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) { [weak self] in
            self?.feverGlow?.removeFromParent()
            self?.feverGlow = nil
        }
    }

    private func enactShudder() {
        guard let cam = camera else { return }
        let shake = SKAction.sequence([
            SKAction.moveBy(x: -8, y: 4, duration: 0.03),
            SKAction.moveBy(x: 6, y: -3, duration: 0.03),
            SKAction.moveBy(x: -5, y: -2, duration: 0.03),
            SKAction.moveBy(x: 4, y: 2, duration: 0.03),
            SKAction.moveBy(x: 0, y: 0, duration: 0.03)
        ])
        cam.run(shake)
    }
}

// MARK: - EpiloguePaneDelegate

extension ArenaScene: EpiloguePaneDelegate {
    func epilogueDidRequestRetry() {
        children.filter { $0 is EpiloguePane }.forEach { ($0 as? EpiloguePane)?.shroud() }
        dismissPauseOverlay()
        quarries.removeAll()
        feverGlow?.removeFromParent()
        feverGlow = nil
        tally.reconstitute()
        momentum.reconstitute()
        escalation.reconstitute()
        refreshHUD()
        commencePrelude()
    }

    func epilogueDidRequestQuit() {
        onQuit?()
    }
}
