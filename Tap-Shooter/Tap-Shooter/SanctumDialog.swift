import UIKit

final class SanctumDialog: UIView {
    private let backdrop = UIView()
    private let panel = UIView()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private var actionButtons: [UIButton] = []
    private var actionClosures: [() -> Void] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBase()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupBase() {
        backdrop.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        backdrop.alpha = 0
        addSubview(backdrop)

        panel.backgroundColor = GlyphKit.twilightSurface
        panel.layer.cornerRadius = 18
        panel.layer.borderWidth = 1
        panel.layer.borderColor = GlyphKit.violaceous.withAlphaComponent(0.35).cgColor
        panel.layer.shadowColor = GlyphKit.violaceous.cgColor
        panel.layer.shadowOffset = .zero
        panel.layer.shadowRadius = 20
        panel.layer.shadowOpacity = 0.35
        panel.alpha = 0
        panel.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        addSubview(panel)

        titleLabel.font = UIFont(name: GlyphKit.primaryTypeface, size: 22) ?? .boldSystemFont(ofSize: 22)
        titleLabel.textColor = GlyphKit.pearl
        titleLabel.textAlignment = .center
        panel.addSubview(titleLabel)

        bodyLabel.font = UIFont(name: GlyphKit.secondaryTypeface, size: 14) ?? .systemFont(ofSize: 14)
        bodyLabel.textColor = GlyphKit.wisp
        bodyLabel.textAlignment = .center
        bodyLabel.numberOfLines = 0
        panel.addSubview(bodyLabel)
    }

    func configure(title: String, message: String, actions: [(title: String, style: DialogActionStyle, handler: () -> Void)]) {
        titleLabel.text = title
        bodyLabel.text = message
        actionButtons.forEach { $0.removeFromSuperview() }
        actionButtons.removeAll()
        actionClosures.removeAll()

        for (index, action) in actions.enumerated() {
            let btn = renderButton(title: action.title, style: action.style, tag: index)
            panel.addSubview(btn)
            actionButtons.append(btn)
            actionClosures.append(action.handler)
        }
        setNeedsLayout()
    }

    private func renderButton(title: String, style: DialogActionStyle, tag: Int) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont(name: GlyphKit.secondaryTypeface, size: 16) ?? .systemFont(ofSize: 16, weight: .medium)
        btn.tag = tag
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(onButtonTap(_:)), for: .touchUpInside)
        switch style {
        case .primary:
            btn.backgroundColor = GlyphKit.violaceous
            btn.setTitleColor(.white, for: .normal)
        case .destructive:
            btn.backgroundColor = GlyphKit.ember
            btn.setTitleColor(.white, for: .normal)
        case .plain:
            btn.backgroundColor = .clear
            btn.setTitleColor(GlyphKit.wisp, for: .normal)
            btn.layer.borderWidth = 1
            btn.layer.borderColor = GlyphKit.wisp.withAlphaComponent(0.4).cgColor
        }
        return btn
    }

    @objc private func onButtonTap(_ sender: UIButton) {
        dismiss { [weak self] in
            self?.actionClosures[sender.tag]()
        }
    }

    func unveil(in parent: UIView) {
        frame = parent.bounds
        parent.addSubview(self)
        UIView.animate(
            withDuration: GlyphKit.standard,
            delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,
            options: .curveEaseOut
        ) {
            self.backdrop.alpha = 1
            self.panel.alpha = 1
            self.panel.transform = .identity
        }
    }

    func dismiss(completion: @escaping () -> Void) {
        UIView.animate(
            withDuration: GlyphKit.brisk,
            delay: 0, options: .curveEaseIn
        ) {
            self.backdrop.alpha = 0
            self.panel.alpha = 0
            self.panel.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        } completion: { _ in
            self.removeFromSuperview()
            completion()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backdrop.frame = bounds

        let panelW: CGFloat = min(bounds.width * 0.82, 340)
        let panelH = calculatePanelHeight(width: panelW)
        panel.frame = CGRect(
            x: (bounds.width - panelW) / 2,
            y: (bounds.height - panelH) / 2,
            width: panelW, height: panelH
        )

        let pad: CGFloat = 22
        titleLabel.frame = CGRect(x: pad, y: pad + 4, width: panelW - pad * 2, height: 28)
        bodyLabel.frame = CGRect(x: pad, y: pad + 36, width: panelW - pad * 2, height: bodyLabel.sizeThatFits(CGSize(width: panelW - pad * 2, height: .greatestFiniteMagnitude)).height)

        let btnY = bodyLabel.frame.maxY + pad
        let btnW = (panelW - pad * CGFloat(actionButtons.count + 1)) / CGFloat(max(actionButtons.count, 1))
        for (i, btn) in actionButtons.enumerated() {
            btn.frame = CGRect(
                x: pad + CGFloat(i) * (btnW + pad),
                y: btnY, width: btnW, height: 44
            )
        }
    }

    private func calculatePanelHeight(width: CGFloat) -> CGFloat {
        let pad: CGFloat = 22
        let bodyH = bodyLabel.sizeThatFits(CGSize(width: width - pad * 2, height: .greatestFiniteMagnitude)).height
        return pad + 40 + bodyH + pad + 44 + pad
    }
}

enum DialogActionStyle { case primary, destructive, plain }
