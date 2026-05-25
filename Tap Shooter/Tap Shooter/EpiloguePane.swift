import SpriteKit

protocol EpiloguePaneDelegate: AnyObject {
    func epilogueDidRequestRetry()
    func epilogueDidRequestQuit()
}

final class EpiloguePane: SKNode {
    weak var delegate: EpiloguePaneDelegate?
    private var retryKey: SKNode!
    private var quitKey: SKNode!

    func unveil(
        finalTally: Int,
        zenith: Int,
        pinnacleStreak: Int,
        duration: TimeInterval,
        in scene: SKScene
    ) {
        let w = scene.size.width
        let h = scene.size.height
        let sf = DimensionMinder.scaleFactor

        let veil = SKShapeNode(rect: CGRect(x: 0, y: 0, width: w, height: h))
        veil.fillColor = UIColor.black.withAlphaComponent(0.6)
        veil.alpha = 0
        addChild(veil)

        let cardW: CGFloat = min(w * 0.82, 340)
        let cardH: CGFloat = 300 * sf
        let cardRect = CGRect(x: (w - cardW) / 2, y: (h - cardH) / 2, width: cardW, height: cardH)
        let cardTop = cardRect.maxY
        let cardBot = cardRect.minY

        let card = SKShapeNode(rect: cardRect, cornerRadius: 16)
        card.fillColor = GlyphKit.twilightSurface
        card.strokeColor = GlyphKit.violaceous.withAlphaComponent(0.35)
        card.lineWidth = 1
        card.alpha = 0
        addChild(card)

        let glow = SKShapeNode(rect: cardRect, cornerRadius: 16)
        glow.fillColor = .clear
        glow.strokeColor = GlyphKit.violaceous.withAlphaComponent(0.15)
        glow.lineWidth = 8
        glow.glowWidth = 4
        glow.alpha = 0
        addChild(glow)

        var allNodes: [SKNode] = []

        // Title
        let titleNode = makeSingleLabel("GAME OVER", size: 26 * sf, color: GlyphKit.ember)
        titleNode.verticalAlignmentMode = .center
        titleNode.position = CGPoint(x: w / 2, y: cardTop - 30 * sf)
        titleNode.alpha = 0; addChild(titleNode); allNodes.append(titleNode)

        // Score
        let tallyPair = makeStatPair(
            value: "\(finalTally)", caption: "SCORE",
            valueSize: 42 * sf, captionSize: 13 * sf
        )
        tallyPair.position = CGPoint(x: w / 2, y: cardTop - 78 * sf)
        tallyPair.alpha = 0; addChild(tallyPair); allNodes.append(tallyPair)

        // Stats row
        let statY = cardTop - 138 * sf
        let leftX = cardRect.minX + cardW * 0.26
        let rightX = cardRect.maxX - cardW * 0.26

        let zenPair = makeStatPair(value: "\(zenith)", caption: "BEST", valueSize: 17 * sf, captionSize: 10 * sf)
        zenPair.position = CGPoint(x: leftX, y: statY)
        zenPair.alpha = 0; addChild(zenPair); allNodes.append(zenPair)

        let strPair = makeStatPair(value: "\(pinnacleStreak)", caption: "MAX COMBO", valueSize: 17 * sf, captionSize: 10 * sf)
        strPair.position = CGPoint(x: rightX, y: statY)
        strPair.alpha = 0; addChild(strPair); allNodes.append(strPair)

        let durPair = makeStatPair(value: IntervalMinder.formattedFractional(duration), caption: "SURVIVED", valueSize: 17 * sf, captionSize: 10 * sf)
        durPair.position = CGPoint(x: w / 2, y: statY - 48 * sf)
        durPair.alpha = 0; addChild(durPair); allNodes.append(durPair)

        // Buttons
        let btnY = cardBot + 44 * sf
        retryKey = makeKey("RETRY", color: GlyphKit.violaceous)
        retryKey.position = CGPoint(x: w / 2 - 70 * sf, y: btnY)
        retryKey.alpha = 0; addChild(retryKey); allNodes.append(retryKey)

        quitKey = makeKey("MENU", color: GlyphKit.wisp)
        quitKey.position = CGPoint(x: w / 2 + 70 * sf, y: btnY)
        quitKey.alpha = 0; addChild(quitKey); allNodes.append(quitKey)

        // Staggered entrance
        veil.run(SKAction.fadeAlpha(to: 1, duration: GlyphKit.standard))
        card.run(SKAction.fadeAlpha(to: 1, duration: GlyphKit.standard))
        glow.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.1),
            SKAction.fadeAlpha(to: 1, duration: GlyphKit.leisurely)
        ]))
        for (i, node) in allNodes.enumerated() {
            node.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.18 + Double(i) * 0.06),
                SKAction.group([
                    SKAction.fadeAlpha(to: 1, duration: GlyphKit.standard),
                    SKAction.moveBy(x: 0, y: 8, duration: GlyphKit.standard)
                ])
            ]))
        }

        isUserInteractionEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let loc = touch.location(in: self)

        if retryKey.contains(loc) {
            bounce(retryKey)
            delegate?.epilogueDidRequestRetry()
        } else if quitKey.contains(loc) {
            bounce(quitKey)
            delegate?.epilogueDidRequestQuit()
        }
    }

    func shroud() {
        run(SKAction.sequence([
            SKAction.fadeOut(withDuration: GlyphKit.brisk),
            SKAction.removeFromParent()
        ]))
    }

    // MARK: - Label builders

    private func makeSingleLabel(_ text: String, size: CGFloat, color: UIColor) -> SKLabelNode {
        let n = SKLabelNode(fontNamed: GlyphKit.primaryTypeface)
        n.text = text
        n.fontSize = size
        n.fontColor = color
        n.horizontalAlignmentMode = .center
        return n
    }

    private func makeStatPair(value: String, caption: String, valueSize: CGFloat, captionSize: CGFloat) -> SKNode {
        let container = SKNode()

        let valueLabel = SKLabelNode(fontNamed: GlyphKit.primaryTypeface)
        valueLabel.text = value
        valueLabel.fontSize = valueSize
        valueLabel.fontColor = GlyphKit.pearl
        valueLabel.verticalAlignmentMode = .center
        valueLabel.horizontalAlignmentMode = .center
        valueLabel.position = CGPoint(x: 0, y: captionSize * 0.7)
        container.addChild(valueLabel)

        let captionLabel = SKLabelNode(fontNamed: GlyphKit.secondaryTypeface)
        captionLabel.text = caption
        captionLabel.fontSize = captionSize
        captionLabel.fontColor = GlyphKit.wisp
        captionLabel.verticalAlignmentMode = .center
        captionLabel.horizontalAlignmentMode = .center
        captionLabel.position = CGPoint(x: 0, y: -valueSize * 0.7)
        container.addChild(captionLabel)

        return container
    }

    private func makeKey(_ text: String, color: UIColor) -> SKNode {
        let bw: CGFloat = DimensionMinder.scaled(120)
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

    private func bounce(_ node: SKNode) {
        node.run(SKAction.sequence([
            SKAction.scale(to: 0.85, duration: 0.05),
            SKAction.scale(to: 1.0, duration: 0.08)
        ]))
    }
}
