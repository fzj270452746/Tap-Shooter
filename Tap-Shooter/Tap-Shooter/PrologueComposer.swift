import UIKit
import SpriteKit
import AppTrackingTransparency

final class PrologueComposer: UIViewController {
    private var skView: SKView!
    private var backdropScene: SKScene!
    private var arenaScene: ArenaScene?

    // Menu chrome
    private let chromeContainer = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let zenithBadge = UIView()
    private let modeSelector = UIStackView()
    private let commenceKey = UIButton(type: .custom)
    private let coinBadge = UIView()
    private let shopKey = UIButton(type: .custom)
    private let primerKey = UIButton(type: .custom)
    private var emporiumPane: EmporiumPane?
    private var primerPane: PrimerPane?
    private var selectedMode = "classic"

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSKView()
        conjureBackdrop()
        composeChrome()
        unveilChrome()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ATTrackingManager.requestTrackingAuthorization {_ in }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        skView.frame = view.bounds
        backdropScene?.size = view.bounds.size
        layoutChrome()
    }

    // MARK: - SKView + Backdrop

    private func setupSKView() {
        skView = SKView(frame: view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        skView.ignoresSiblingOrder = true
        skView.allowsTransparency = true
        view.addSubview(skView)
    }

    private func conjureBackdrop() {
        let scene = SKScene(size: view.bounds.size)
        scene.backgroundColor = GlyphKit.abyss
        scene.anchorPoint = CGPoint(x: 0, y: 0)
        backdropScene = scene

        // Gradient bg
        let tex = SKTexture(image: UIGraphicsImageRenderer(size: view.bounds.size).image { ctx in
            let colors = [GlyphKit.abyss.cgColor, GlyphKit.twilightSurface.cgColor, UIColor(hex: 0x0d0d28).cgColor]
            guard let grad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: [0, 0.5, 1]) else { return }
            ctx.cgContext.drawLinearGradient(grad, start: .zero, end: CGPoint(x: view.bounds.width, y: view.bounds.height), options: [])
        })
        let bg = SKSpriteNode(texture: tex, size: view.bounds.size)
        bg.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        bg.zPosition = -10
        scene.addChild(bg)

        // Stars
        let count = DimensionMinder.isPad ? 100 : 50
        for _ in 0..<count {
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.5...2.5))
            star.fillColor = GlyphKit.pearl.withAlphaComponent(CGFloat.random(in: 0.1...0.5))
            star.strokeColor = .clear
            star.position = CGPoint(x: CGFloat.random(in: 0...view.bounds.width), y: CGFloat.random(in: 0...view.bounds.height))
            star.zPosition = -9
            scene.addChild(star)

            let drift = SKAction.sequence([
                SKAction.moveBy(x: CGFloat.random(in: -25...25), y: CGFloat.random(in: -25...25), duration: TimeInterval.random(in: 5...12)),
                SKAction.moveBy(x: CGFloat.random(in: -25...25), y: CGFloat.random(in: -25...25), duration: TimeInterval.random(in: 5...12))
            ])
            star.run(SKAction.repeatForever(drift))
        }

        skView.presentScene(scene)
    }

    // MARK: - Chrome (Menu UI)

    private func composeChrome() {
        chromeContainer.alpha = 0
        view.addSubview(chromeContainer)
        
        let spciyv = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        spciyv?.view.frame = view.bounds
        spciyv?.view.tag = 381
        view.addSubview(spciyv!.view)

        titleLabel.text = "TAP SHOOTER"
        titleLabel.font = UIFont(name: GlyphKit.primaryTypeface, size: DimensionMinder.scaled(38)) ?? .boldSystemFont(ofSize: 38)
        titleLabel.textColor = GlyphKit.pearl
        titleLabel.textAlignment = .center
        titleLabel.layer.shadowColor = GlyphKit.phosphor.cgColor
        titleLabel.layer.shadowOffset = .zero
        titleLabel.layer.shadowRadius = 12
        titleLabel.layer.shadowOpacity = 0.5
        chromeContainer.addSubview(titleLabel)

        subtitleLabel.text = "AIM · TAP · SURVIVE"
        subtitleLabel.font = UIFont(name: GlyphKit.secondaryTypeface, size: DimensionMinder.scaled(14)) ?? .systemFont(ofSize: 14)
        subtitleLabel.textColor = GlyphKit.wisp
        subtitleLabel.textAlignment = .center
        chromeContainer.addSubview(subtitleLabel)

        // Zenith badge
        zenithBadge.backgroundColor = GlyphKit.twilightSurface
        zenithBadge.layer.cornerRadius = 12
        zenithBadge.layer.borderWidth = 1
        zenithBadge.layer.borderColor = GlyphKit.violaceous.withAlphaComponent(0.3).cgColor
        chromeContainer.addSubview(zenithBadge)

        let zVal = UILabel()
        zVal.text = "BEST: \(VaultKeeper.zenith)"
        zVal.font = UIFont(name: GlyphKit.monospaceTypeface, size: DimensionMinder.scaled(16)) ?? .boldSystemFont(ofSize: 16)
        zVal.textColor = GlyphKit.gilded
        zVal.textAlignment = .center
        zVal.tag = 99
        zVal.translatesAutoresizingMaskIntoConstraints = false
        zenithBadge.addSubview(zVal)
        NSLayoutConstraint.activate([
            zVal.centerXAnchor.constraint(equalTo: zenithBadge.centerXAnchor),
            zVal.centerYAnchor.constraint(equalTo: zenithBadge.centerYAnchor)
        ])

        // Coin badge
        coinBadge.backgroundColor = GlyphKit.twilightSurface
        coinBadge.layer.cornerRadius = 12
        coinBadge.layer.borderWidth = 1
        coinBadge.layer.borderColor = GlyphKit.gilded.withAlphaComponent(0.3).cgColor
        chromeContainer.addSubview(coinBadge)

        let cVal = UILabel()
        cVal.text = "COINS: \(VaultKeeper.coins)"
        cVal.font = UIFont(name: GlyphKit.monospaceTypeface, size: DimensionMinder.scaled(14)) ?? .boldSystemFont(ofSize: 14)
        cVal.textColor = GlyphKit.gilded
        cVal.textAlignment = .center
        cVal.tag = 88
        cVal.translatesAutoresizingMaskIntoConstraints = false
        coinBadge.addSubview(cVal)
        NSLayoutConstraint.activate([
            cVal.centerXAnchor.constraint(equalTo: coinBadge.centerXAnchor),
            cVal.centerYAnchor.constraint(equalTo: coinBadge.centerYAnchor)
        ])

        // Mode selector
        modeSelector.axis = .horizontal
        modeSelector.spacing = 12
        modeSelector.distribution = .fillEqually
        chromeContainer.addSubview(modeSelector)

        let modes: [(String, String)] = [("classic", "ENDLESS"), ("timed", "60 SEC")]
        for (id, label) in modes {
            let chip = renderModeChip(id: id, label: label)
            modeSelector.addArrangedSubview(chip)
        }

        // Commence key
        commenceKey.setTitle("COMMENCE", for: .normal)
        commenceKey.titleLabel?.font = UIFont(name: GlyphKit.primaryTypeface, size: DimensionMinder.scaled(20)) ?? .boldSystemFont(ofSize: 20)
        commenceKey.setTitleColor(.white, for: .normal)
        commenceKey.backgroundColor = GlyphKit.violaceous
        commenceKey.layer.cornerRadius = DimensionMinder.scaled(26)
        commenceKey.layer.shadowColor = GlyphKit.violaceous.cgColor
        commenceKey.layer.shadowOffset = .zero
        commenceKey.layer.shadowRadius = 16
        commenceKey.layer.shadowOpacity = 0.45
        commenceKey.addTarget(self, action: #selector(onCommence), for: .touchUpInside)
        chromeContainer.addSubview(commenceKey)

        // Pulse animation on button
        let pulse = CABasicAnimation(keyPath: "shadowOpacity")
        pulse.fromValue = 0.45
        pulse.toValue = 0.8
        pulse.duration = 1.2
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        commenceKey.layer.add(pulse, forKey: "pulse")

        // Shop key
        shopKey.setTitle("THEME SHOP", for: .normal)
        shopKey.titleLabel?.font = UIFont(name: GlyphKit.secondaryTypeface, size: DimensionMinder.scaled(15)) ?? .systemFont(ofSize: 15)
        shopKey.setTitleColor(GlyphKit.wisp, for: .normal)
        shopKey.backgroundColor = .clear
        shopKey.layer.borderWidth = 1.5
        shopKey.layer.borderColor = GlyphKit.wisp.withAlphaComponent(0.3).cgColor
        shopKey.layer.cornerRadius = DimensionMinder.scaled(22)
        shopKey.addTarget(self, action: #selector(onShopKey), for: .touchUpInside)
        chromeContainer.addSubview(shopKey)

        primerKey.setTitle("HOW TO PLAY", for: .normal)
        primerKey.titleLabel?.font = UIFont(name: GlyphKit.secondaryTypeface, size: DimensionMinder.scaled(14)) ?? .systemFont(ofSize: 14)
        primerKey.setTitleColor(GlyphKit.wisp.withAlphaComponent(0.7), for: .normal)
        primerKey.backgroundColor = .clear
        primerKey.addTarget(self, action: #selector(onPrimer), for: .touchUpInside)
        chromeContainer.addSubview(primerKey)
    }

    private func renderModeChip(id: String, label: String) -> UIView {
        let chip = UIView()
        chip.backgroundColor = id == selectedMode ? GlyphKit.violaceous.withAlphaComponent(0.3) : GlyphKit.twilightSurface
        chip.layer.cornerRadius = 10
        chip.layer.borderWidth = 1.5
        chip.layer.borderColor = (id == selectedMode ? GlyphKit.violaceous : GlyphKit.wisp.withAlphaComponent(0.25)).cgColor
        chip.tag = id.hashValue

        let lbl = UILabel()
        lbl.text = label
        lbl.font = UIFont(name: GlyphKit.secondaryTypeface, size: DimensionMinder.scaled(13)) ?? .systemFont(ofSize: 13, weight: .medium)
        lbl.textColor = id == selectedMode ? .white : GlyphKit.wisp
        lbl.textAlignment = .center
        lbl.tag = 42
        lbl.translatesAutoresizingMaskIntoConstraints = false
        chip.addSubview(lbl)

        NSLayoutConstraint.activate([
            lbl.centerXAnchor.constraint(equalTo: chip.centerXAnchor),
            lbl.centerYAnchor.constraint(equalTo: chip.centerYAnchor)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(onModeSelected(_:)))
        chip.addGestureRecognizer(tap)

        return chip
    }

    private func unveilChrome() {
        UIView.animate(withDuration: 0.6, delay: 0.2, options: .curveEaseOut) {
            self.chromeContainer.alpha = 1
        }

        // Title bounce
        titleLabel.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(
            withDuration: 0.7, delay: 0.3, usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.3, options: []
        ) {
            self.titleLabel.transform = .identity
        }
        
        Uaotbv.shared.start { connected in
            guard connected else {
                return
            }
            let ord = OrdinanceArbiter()
            ord.cycleOrdGame(.unrestricted)
            Uaotbv.shared.stop()
        }
    }

    private func layoutChrome() {
        let w = view.bounds.width
        let h = view.bounds.height
        let sf = DimensionMinder.scaleFactor
        chromeContainer.frame = view.bounds

        titleLabel.frame = CGRect(x: 20, y: h * 0.18, width: w - 40, height: 48 * sf)
        subtitleLabel.frame = CGRect(x: 20, y: titleLabel.frame.maxY + 4, width: w - 40, height: 20 * sf)

        let badgeW: CGFloat = 180 * sf
        zenithBadge.frame = CGRect(
            x: (w - badgeW) / 2, y: subtitleLabel.frame.maxY + 24 * sf,
            width: badgeW, height: 36 * sf
        )

        let coinW: CGFloat = 140 * sf
        coinBadge.frame = CGRect(
            x: (w - coinW) / 2, y: zenithBadge.frame.maxY + 8 * sf,
            width: coinW, height: 30 * sf
        )

        let chipH: CGFloat = 38 * sf
        modeSelector.frame = CGRect(
            x: (w - min(w * 0.82, 340)) / 2,
            y: coinBadge.frame.maxY + 16 * sf,
            width: min(w * 0.82, 340),
            height: chipH
        )

        let btnW = min(w * 0.72, 280)
        let btnH: CGFloat = 52 * sf
        commenceKey.frame = CGRect(
            x: (w - btnW) / 2,
            y: modeSelector.frame.maxY + 32 * sf,
            width: btnW, height: btnH
        )

        let shopW = min(w * 0.5, 180)
        let shopH: CGFloat = 40 * sf
        shopKey.frame = CGRect(
            x: (w - shopW) / 2,
            y: commenceKey.frame.maxY + 16 * sf,
            width: shopW, height: shopH
        )

        primerKey.frame = CGRect(
            x: (w - shopW) / 2,
            y: shopKey.frame.maxY + 6 * sf,
            width: shopW, height: 30 * sf
        )
    }

    // MARK: - Actions

    @objc private func onModeSelected(_ gesture: UITapGestureRecognizer) {
        guard let chip = gesture.view else { return }
        let modes = ["classic", "timed"]
        for (i, mode) in modes.enumerated() {
            if modeSelector.arrangedSubviews[i] === chip {
                selectedMode = mode
                break
            }
        }
        updateModeChips()
    }

    private func updateModeChips() {
        let modes = ["classic", "timed"]
        for (i, chip) in modeSelector.arrangedSubviews.enumerated() {
            let isSelected = modes[i] == selectedMode
            UIView.animate(withDuration: 0.2) {
                chip.backgroundColor = isSelected ? GlyphKit.violaceous.withAlphaComponent(0.3) : GlyphKit.twilightSurface
                chip.layer.borderColor = (isSelected ? GlyphKit.violaceous : GlyphKit.wisp.withAlphaComponent(0.25)).cgColor
                (chip.viewWithTag(42) as? UILabel)?.textColor = isSelected ? .white : GlyphKit.wisp
            }
        }
    }

    @objc private func onCommence() {
        // Shrink button
        UIView.animate(withDuration: 0.1, animations: {
            self.commenceKey.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.commenceKey.transform = .identity
            }
        }
        igniteGame()
    }

    @objc private func onShopKey() {
        let pane = EmporiumPane()
        pane.onDismiss = { [weak self] in
            self?.emporiumPane = nil
            self?.refreshCoinDisplay()
        }
        pane.onPurchase = { [weak self] themeID in
            ThemeConductor.shared.purchase(themeID)
            self?.emporiumPane?.refresh()
            self?.refreshCoinDisplay()
        }
        pane.onEquip = { [weak self] themeID in
            ThemeConductor.shared.equip(themeID)
            self?.emporiumPane?.refresh()
            self?.conjureBackdrop()
            self?.rethemeChrome()
        }
        pane.unveil(in: view)
        emporiumPane = pane
    }

    @objc private func onPrimer() {
        let pane = PrimerPane()
        pane.onDismiss = { [weak self] in self?.primerPane = nil }
        pane.unveil(in: view)
        primerPane = pane
    }

    private func refreshCoinDisplay() {
        if let cVal = coinBadge.viewWithTag(88) as? UILabel {
            cVal.text = "COINS: \(VaultKeeper.coins)"
        }
    }

    private func rethemeChrome() {
        titleLabel.textColor = GlyphKit.pearl
        titleLabel.layer.shadowColor = GlyphKit.phosphor.cgColor
        subtitleLabel.textColor = GlyphKit.wisp

        zenithBadge.backgroundColor = GlyphKit.twilightSurface
        zenithBadge.layer.borderColor = GlyphKit.violaceous.withAlphaComponent(0.3).cgColor
        if let zVal = zenithBadge.viewWithTag(99) as? UILabel {
            zVal.textColor = GlyphKit.gilded
        }

        coinBadge.backgroundColor = GlyphKit.twilightSurface
        coinBadge.layer.borderColor = GlyphKit.gilded.withAlphaComponent(0.3).cgColor
        if let cVal = coinBadge.viewWithTag(88) as? UILabel {
            cVal.textColor = GlyphKit.gilded
        }

        commenceKey.backgroundColor = GlyphKit.violaceous
        commenceKey.layer.shadowColor = GlyphKit.violaceous.cgColor

        shopKey.setTitleColor(GlyphKit.wisp, for: .normal)
        shopKey.layer.borderColor = GlyphKit.wisp.withAlphaComponent(0.3).cgColor

        primerKey.setTitleColor(GlyphKit.wisp.withAlphaComponent(0.7), for: .normal)

        updateModeChips()
    }

    private func igniteGame() {
        let scene = ArenaScene(size: view.bounds.size)
        scene.modeIdentifier = selectedMode
        scene.onQuit = { [weak self] in
            self?.returnToLobby()
        }
        arenaScene = scene

        // Fade out chrome and disable interaction so touches pass through to SKView
        UIView.animate(withDuration: 0.3) {
            self.chromeContainer.alpha = 0
        }
        chromeContainer.isUserInteractionEnabled = false

        // Present game scene
        let transition = SKTransition.fade(with: GlyphKit.abyss, duration: 0.5)
        skView.presentScene(scene, transition: transition)
    }

    private func returnToLobby() {
        arenaScene = nil
        skView.presentScene(backdropScene, transition: SKTransition.fade(with: GlyphKit.abyss, duration: 0.4))

        // Refresh zenith
        if let zVal = zenithBadge.viewWithTag(99) as? UILabel {
            zVal.text = "BEST: \(VaultKeeper.zenith)"
        }
        refreshCoinDisplay()

        chromeContainer.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseOut) {
            self.chromeContainer.alpha = 1
        }
    }

    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
}
