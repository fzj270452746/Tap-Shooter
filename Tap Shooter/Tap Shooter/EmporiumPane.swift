import UIKit

final class EmporiumPane: UIView {
    var onDismiss: (() -> Void)?
    var onPurchase: ((String) -> Void)?
    var onEquip: ((String) -> Void)?

    private let backdrop = UIView()
    private let panel = UIView()
    private let titleLabel = UILabel()
    private let coinLabel = UILabel()
    private let closeKey = UIButton(type: .system)
    private let scrollView = UIScrollView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        compose()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Composition

    private func compose() {
        backdrop.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        backdrop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackdropTap)))
        addSubview(backdrop)

        panel.backgroundColor = GlyphKit.twilightSurface
        panel.layer.cornerRadius = 18
        panel.layer.borderWidth = 1
        panel.layer.borderColor = GlyphKit.violaceous.withAlphaComponent(0.35).cgColor
        panel.layer.shadowColor = GlyphKit.violaceous.cgColor
        panel.layer.shadowOffset = .zero
        panel.layer.shadowRadius = 20
        panel.layer.shadowOpacity = 0.2
        panel.alpha = 0
        panel.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        panel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(panel)

        titleLabel.text = "THEME EMPORIUM"
        titleLabel.font = UIFont(name: GlyphKit.primaryTypeface, size: DimensionMinder.scaled(22)) ?? .boldSystemFont(ofSize: 22)
        titleLabel.textColor = GlyphKit.pearl
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(titleLabel)

        coinLabel.text = "COINS: \(VaultKeeper.coins)"
        coinLabel.font = UIFont(name: GlyphKit.monospaceTypeface, size: DimensionMinder.scaled(14)) ?? .boldSystemFont(ofSize: 14)
        coinLabel.textColor = GlyphKit.gilded
        coinLabel.textAlignment = .center
        coinLabel.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(coinLabel)

        closeKey.setTitle("X", for: .normal)
        closeKey.titleLabel?.font = UIFont(name: GlyphKit.primaryTypeface, size: DimensionMinder.scaled(18)) ?? .boldSystemFont(ofSize: 18)
        closeKey.setTitleColor(GlyphKit.wisp, for: .normal)
        closeKey.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        closeKey.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(closeKey)

        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(scrollView)

        NSLayoutConstraint.activate([
            backdrop.topAnchor.constraint(equalTo: topAnchor),
            backdrop.bottomAnchor.constraint(equalTo: bottomAnchor),
            backdrop.leadingAnchor.constraint(equalTo: leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: trailingAnchor),

            panel.centerXAnchor.constraint(equalTo: centerXAnchor),
            panel.centerYAnchor.constraint(equalTo: centerYAnchor),
            panel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.88),
            panel.widthAnchor.constraint(lessThanOrEqualToConstant: 360),
            panel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.78),
            panel.heightAnchor.constraint(lessThanOrEqualToConstant: 600 * DimensionMinder.scaleFactor),

            titleLabel.topAnchor.constraint(equalTo: panel.topAnchor, constant: 16 * DimensionMinder.scaleFactor),
            titleLabel.centerXAnchor.constraint(equalTo: panel.centerXAnchor),

            coinLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            coinLabel.centerXAnchor.constraint(equalTo: panel.centerXAnchor),

            closeKey.topAnchor.constraint(equalTo: panel.topAnchor, constant: 12 * DimensionMinder.scaleFactor),
            closeKey.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -12 * DimensionMinder.scaleFactor),
            closeKey.widthAnchor.constraint(equalToConstant: 36 * DimensionMinder.scaleFactor),
            closeKey.heightAnchor.constraint(equalToConstant: 36 * DimensionMinder.scaleFactor),

            scrollView.topAnchor.constraint(equalTo: coinLabel.bottomAnchor, constant: 10 * DimensionMinder.scaleFactor),
            scrollView.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 16 * DimensionMinder.scaleFactor),
            scrollView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -16 * DimensionMinder.scaleFactor),
            scrollView.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -16 * DimensionMinder.scaleFactor),
        ])
    }

    func unveil(in parent: UIView) {
        frame = parent.bounds
        parent.addSubview(self)
        layoutIfNeeded()

        UIView.animate(withDuration: 0.25) {
            self.backdrop.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        }
        UIView.animate(withDuration: 0.45, delay: 0.05, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.3, options: []) {
            self.panel.alpha = 1
            self.panel.transform = .identity
        }

        refresh()
    }

    func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.backdrop.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.panel.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }

    // MARK: - Refresh

    func refresh() {
        coinLabel.text = "COINS: \(VaultKeeper.coins)"
        scrollView.subviews.forEach { $0.removeFromSuperview() }

        let sf = DimensionMinder.scaleFactor
        let cardH: CGFloat = 88 * sf
        let gap: CGFloat = 10 * sf
        let cardW = scrollView.bounds.width
        var y: CGFloat = 0

        for theme in ThemeConductor.shared.themes {
            let card = renderCard(theme: theme, width: cardW, height: cardH)
            card.frame = CGRect(x: 0, y: y, width: cardW, height: cardH)
            scrollView.addSubview(card)
            y += cardH + gap
        }

        scrollView.contentSize = CGSize(width: cardW, height: max(y - gap, 0))
    }

    // MARK: - Card rendering

    private func renderCard(theme: Theme, width: CGFloat, height: CGFloat) -> UIView {
        let sf = DimensionMinder.scaleFactor
        let card = UIView()
        card.backgroundColor = GlyphKit.twilightSurface.withAlphaComponent(0.5)
        card.layer.cornerRadius = 10
        card.layer.borderWidth = 1

        let isActive = theme.id == ThemeConductor.shared.activeID
        let isPurchased = ThemeConductor.shared.isPurchased(theme.id)
        let canAfford = VaultKeeper.coins >= theme.price

        if isActive {
            card.layer.borderColor = GlyphKit.phosphor.withAlphaComponent(0.5).cgColor
        } else if isPurchased {
            card.layer.borderColor = GlyphKit.violaceous.withAlphaComponent(0.3).cgColor
        } else {
            card.layer.borderColor = GlyphKit.wisp.withAlphaComponent(0.15).cgColor
        }

        // Swatch dots
        let swatchR: CGFloat = 8 * sf
        let swatchGap: CGFloat = 18 * sf
        let swatchY: CGFloat = 10 * sf
        var sx: CGFloat = 12 * sf
        for color in theme.swatchColors() {
            let dot = UIView()
            dot.backgroundColor = color
            dot.layer.cornerRadius = swatchR
            dot.frame = CGRect(x: sx, y: swatchY, width: swatchR * 2, height: swatchR * 2)
            card.addSubview(dot)
            sx += swatchR * 2 + swatchGap
        }

        // Name
        let nameLabel = UILabel()
        nameLabel.text = theme.name.uppercased()
        nameLabel.font = UIFont(name: GlyphKit.primaryTypeface, size: DimensionMinder.scaled(13)) ?? .boldSystemFont(ofSize: 13)
        nameLabel.textColor = GlyphKit.pearl
        nameLabel.frame = CGRect(x: 12 * sf, y: swatchY + swatchR * 2 + 6 * sf, width: width - 24 * sf, height: 17 * sf)
        card.addSubview(nameLabel)

        // Price or status
        let infoLabel = UILabel()
        if isActive {
            infoLabel.text = "EQUIPPED"
            infoLabel.textColor = GlyphKit.phosphor
        } else if isPurchased {
            infoLabel.text = "OWNED"
            infoLabel.textColor = GlyphKit.violaceous
        } else {
            infoLabel.text = "\(theme.price) coins"
            infoLabel.textColor = GlyphKit.wisp
        }
        infoLabel.font = UIFont(name: GlyphKit.secondaryTypeface, size: DimensionMinder.scaled(11)) ?? .systemFont(ofSize: 11)
        infoLabel.frame = CGRect(x: 12 * sf, y: nameLabel.frame.maxY + 1, width: width - 24 * sf, height: 15 * sf)
        card.addSubview(infoLabel)

        // Action button
        let btnW: CGFloat = 80 * sf
        let btnH: CGFloat = 30 * sf
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = UIFont(name: GlyphKit.secondaryTypeface, size: DimensionMinder.scaled(12)) ?? .boldSystemFont(ofSize: 12)

        let btnX = width - btnW - 10 * sf
        let btnY = (height - btnH) / 2

        if isActive {
            btn.setTitle("EQUIPPED", for: .normal)
            btn.setTitleColor(GlyphKit.phosphor, for: .normal)
            btn.backgroundColor = GlyphKit.phosphor.withAlphaComponent(0.15)
            btn.isUserInteractionEnabled = false
        } else if isPurchased {
            btn.setTitle("EQUIP", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = GlyphKit.violaceous
            btn.addTarget(self, action: #selector(onEquipTap(_:)), for: .touchUpInside)
            btn.tag = theme.id.hashValue
        } else {
            btn.setTitle("BUY", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = canAfford ? GlyphKit.violaceous : GlyphKit.wisp.withAlphaComponent(0.4)
            btn.addTarget(self, action: #selector(onBuyTap(_:)), for: .touchUpInside)
            btn.tag = theme.id.hashValue
        }

        btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
        card.addSubview(btn)

        return card
    }

    private func themeForHash(_ hash: Int) -> Theme? {
        ThemeConductor.shared.themes.first { $0.id.hashValue == hash }
    }

    @objc private func onBuyTap(_ sender: UIButton) {
        guard let theme = themeForHash(sender.tag) else { return }
        guard VaultKeeper.coins >= theme.price else {
            enactInsufficientFunds(sender)
            return
        }
        onPurchase?(theme.id)
    }

    private func enactInsufficientFunds(_ sender: UIButton) {
        guard let card = sender.superview else { return }
        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.values = [0, -6, 6, -5, 5, -3, 3, 0]
        shake.keyTimes = [0, 0.12, 0.25, 0.37, 0.5, 0.62, 0.75, 0.87]
        shake.duration = 0.45
        card.layer.add(shake, forKey: "shake")

        sender.backgroundColor = GlyphKit.ember.withAlphaComponent(0.6)
        UIView.animate(withDuration: 0.4) {
            sender.backgroundColor = GlyphKit.wisp.withAlphaComponent(0.4)
        }

        coinLabel.textColor = GlyphKit.ember
        UIView.animate(withDuration: 0.4) {
            self.coinLabel.textColor = GlyphKit.gilded
        }
    }

    @objc private func onEquipTap(_ sender: UIButton) {
        guard let theme = themeForHash(sender.tag) else { return }
        onEquip?(theme.id)
    }

    @objc private func onClose() {
        dismiss()
        onDismiss?()
    }

    @objc private func onBackdropTap() {
        dismiss()
        onDismiss?()
    }
}
