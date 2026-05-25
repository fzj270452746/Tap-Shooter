import UIKit

final class PrimerPane: UIView {
    var onDismiss: (() -> Void)?

    private let backdrop = UIView()
    private let panel = UIView()
    private let scrollView = UIScrollView()
    private let closeKey = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        compose()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func compose() {
        backdrop.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        backdrop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBackdropTap)))
        addSubview(backdrop)

        panel.backgroundColor = GlyphKit.twilightSurface
        panel.layer.cornerRadius = 18
        panel.layer.borderWidth = 1
        panel.layer.borderColor = GlyphKit.violaceous.withAlphaComponent(0.35).cgColor
        panel.alpha = 0
        panel.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        panel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(panel)

        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(scrollView)

        closeKey.setTitle("X", for: .normal)
        closeKey.titleLabel?.font = UIFont(name: GlyphKit.primaryTypeface, size: DimensionMinder.scaled(18)) ?? .boldSystemFont(ofSize: 18)
        closeKey.setTitleColor(GlyphKit.wisp, for: .normal)
        closeKey.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        closeKey.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(closeKey)

        NSLayoutConstraint.activate([
            backdrop.topAnchor.constraint(equalTo: topAnchor),
            backdrop.bottomAnchor.constraint(equalTo: bottomAnchor),
            backdrop.leadingAnchor.constraint(equalTo: leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: trailingAnchor),

            panel.centerXAnchor.constraint(equalTo: centerXAnchor),
            panel.centerYAnchor.constraint(equalTo: centerYAnchor),
            panel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            panel.widthAnchor.constraint(lessThanOrEqualToConstant: 380),
            panel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.82),
            panel.heightAnchor.constraint(lessThanOrEqualToConstant: 640 * DimensionMinder.scaleFactor),

            closeKey.topAnchor.constraint(equalTo: panel.topAnchor, constant: 12 * DimensionMinder.scaleFactor),
            closeKey.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -12 * DimensionMinder.scaleFactor),
            closeKey.widthAnchor.constraint(equalToConstant: 36 * DimensionMinder.scaleFactor),
            closeKey.heightAnchor.constraint(equalToConstant: 36 * DimensionMinder.scaleFactor),

            scrollView.topAnchor.constraint(equalTo: panel.topAnchor, constant: 54 * DimensionMinder.scaleFactor),
            scrollView.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20 * DimensionMinder.scaleFactor),
            scrollView.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20 * DimensionMinder.scaleFactor),
            scrollView.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -20 * DimensionMinder.scaleFactor),
        ])
    }

    func unveil(in parent: UIView) {
        frame = parent.bounds
        parent.addSubview(self)
        layoutIfNeeded()
        renderContent()

        UIView.animate(withDuration: 0.25) {
            self.backdrop.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        }
        UIView.animate(withDuration: 0.45, delay: 0.05, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.3, options: []) {
            self.panel.alpha = 1
            self.panel.transform = .identity
        }
    }

    func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.backdrop.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.panel.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }

    // MARK: - Content

    private func renderContent() {
        let sf = DimensionMinder.scaleFactor
        let w = scrollView.bounds.width
        var y: CGFloat = 0

        y = addTitle("HOW TO PLAY", at: y, width: w, sf: sf)
        y += 12 * sf
        y = addSection("TARGETS", at: y, width: w, sf: sf,
            bullets: [
                ("●", "Normal targets — tap to score points. Their color must match the current rule.", GlyphKit.pearl),
                ("✕", "Danger targets — do NOT tap these! Hitting one ends your game immediately.", GlyphKit.ember),
                ("●", "Coin targets — tap to earn coins. Gold fill with a dot symbol. Coins unlock themes.", GlyphKit.gilded),
            ])
        y += 14 * sf
        y = addSection("RULES", at: y, width: w, sf: sf,
            bullets: [
                ("", "The rule at the top-right tells you which colors to hit or avoid. It changes every few seconds.", GlyphKit.phosphor),
                ("", "HIT ONLY GREEN — you must only tap green targets.", GlyphKit.verdant),
                ("", "AVOID BLUE — tap any color except blue.", GlyphKit.cerulean),
                ("", "HIT ANY TARGET — all colors are fair game.", GlyphKit.pearl),
            ])
        y += 14 * sf
        y = addSection("SCORING", at: y, width: w, sf: sf,
            bullets: [
                ("", "Each valid hit scores 10 points × combo multiplier.", GlyphKit.pearl),
                ("", "Combo: 1–5 hits = ×1, 6–10 hits = ×2, 11+ hits = ×3.", GlyphKit.gilded),
                ("", "Fever Mode: at 10+ combo streak, you earn 50% bonus points and double coins.", GlyphKit.phosphor),
                ("", "Hitting a wrong color resets your combo to zero.", GlyphKit.ember),
            ])
        y += 14 * sf
        y = addSection("MODES", at: y, width: w, sf: sf,
            bullets: [
                ("", "ENDLESS — play until you hit a danger target. Survive as long as you can.", GlyphKit.pearl),
                ("", "60 SEC — score as many points as possible within the time limit.", GlyphKit.pearl),
            ])
        y += 14 * sf
        y = addSection("COINS & SHOP", at: y, width: w, sf: sf,
            bullets: [
                ("", "Earn coins by hitting gold coin targets during gameplay.", GlyphKit.gilded),
                ("", "Spend coins in the Theme Shop to unlock new color palettes.", GlyphKit.violaceous),
                ("", "Themes change backgrounds, panels, buttons, and text colors.", GlyphKit.pearl),
            ])

        scrollView.contentSize = CGSize(width: w, height: y)
    }

    private func addTitle(_ text: String, at y: CGFloat, width: CGFloat, sf: CGFloat) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: GlyphKit.primaryTypeface, size: 26 * sf) ?? .boldSystemFont(ofSize: 26 * sf)
        label.textColor = GlyphKit.pearl
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: y, width: width, height: 32 * sf)
        scrollView.addSubview(label)
        return label.frame.maxY
    }

    private func addSection(_ title: String, at y: CGFloat, width: CGFloat, sf: CGFloat,
                            bullets: [(symbol: String, text: String, color: UIColor)]) -> CGFloat {
        var cy = y
        let header = UILabel()
        header.text = title
        header.font = UIFont(name: GlyphKit.primaryTypeface, size: 15 * sf) ?? .boldSystemFont(ofSize: 15 * sf)
        header.textColor = GlyphKit.phosphor
        header.frame = CGRect(x: 0, y: cy, width: width, height: 20 * sf)
        scrollView.addSubview(header)
        cy = header.frame.maxY + 4 * sf

        for bullet in bullets {
            let line = UILabel()
            let symbolPart = bullet.symbol.isEmpty ? "" : "\(bullet.symbol)  "
            line.text = "\(symbolPart)\(bullet.text)"
            line.font = UIFont(name: GlyphKit.secondaryTypeface, size: 12 * sf) ?? .systemFont(ofSize: 12 * sf)
            line.textColor = bullet.color
            line.numberOfLines = 0
            line.lineBreakMode = .byWordWrapping
            let fitSize = line.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            line.frame = CGRect(x: 0, y: cy, width: width, height: fitSize.height)
            scrollView.addSubview(line)
            cy = line.frame.maxY + 3 * sf
        }
        return cy
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
