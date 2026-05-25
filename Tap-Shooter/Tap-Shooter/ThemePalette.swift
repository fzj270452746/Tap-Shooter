import UIKit

struct Theme {
    let id: String
    let name: String
    let price: Int
    let abyss: UInt64
    let twilightSurface: UInt64
    let pearl: UInt64
    let wisp: UInt64
    let violaceous: UInt64
    let phosphor: UInt64
    let ember: UInt64
    let gilded: UInt64

    func swatchColors() -> [UIColor] {
        [UIColor(hex: abyss), UIColor(hex: pearl), UIColor(hex: violaceous), UIColor(hex: phosphor), UIColor(hex: gilded)]
    }
}

final class ThemeConductor {
    static let shared = ThemeConductor()

    let themes: [Theme] = [
        Theme(
            id: "neonVoid", name: "Neon Void", price: 0,
            abyss: 0x08081a, twilightSurface: 0x12122e,
            pearl: 0xf0f0ff, wisp: 0x7b8db3,
            violaceous: 0xb388ff, phosphor: 0x00e5ff,
            ember: 0xff1744, gilded: 0xffd740
        ),
        Theme(
            id: "crimsonDusk", name: "Crimson Dusk", price: 100,
            abyss: 0x0d0710, twilightSurface: 0x1f1222,
            pearl: 0xffe8e8, wisp: 0xb38080,
            violaceous: 0xff6b6b, phosphor: 0xff8a65,
            ember: 0xff1744, gilded: 0xffd740
        ),
        Theme(
            id: "oceanDepths", name: "Ocean Depths", price: 500,
            abyss: 0x010d20, twilightSurface: 0x0a1a3a,
            pearl: 0xe0f0ff, wisp: 0x6b8db3,
            violaceous: 0x40c4ff, phosphor: 0x00e5ff,
            ember: 0xff5252, gilded: 0xffd740
        ),
        Theme(
            id: "goldenHour", name: "Golden Hour", price: 2000,
            abyss: 0x140f08, twilightSurface: 0x221a10,
            pearl: 0xfff5e0, wisp: 0xb3a080,
            violaceous: 0xffb74d, phosphor: 0xffcc80,
            ember: 0xff6d00, gilded: 0xffd740
        ),
        Theme(
            id: "frostByte", name: "Frost Byte", price: 8000,
            abyss: 0x080e1a, twilightSurface: 0x111c2e,
            pearl: 0xe8f4ff, wisp: 0x8199b3,
            violaceous: 0x64ffda, phosphor: 0x80f0ff,
            ember: 0xff3d5c, gilded: 0xffd740
        ),
        Theme(
            id: "phantomMist", name: "Phantom Mist", price: 30000,
            abyss: 0x0e0e15, twilightSurface: 0x1a1a28,
            pearl: 0xf0e8ff, wisp: 0x9088a8,
            violaceous: 0xb388ff, phosphor: 0xcc80ff,
            ember: 0xff1744, gilded: 0xffd740
        ),
        Theme(
            id: "solarFlare", name: "Solar Flare", price: 100000,
            abyss: 0x0a0a0a, twilightSurface: 0x1a1a1a,
            pearl: 0xffffff, wisp: 0x999999,
            violaceous: 0xffd740, phosphor: 0xffe57f,
            ember: 0xff5252, gilded: 0xffd740
        ),
    ]

    private(set) var purchasedIDs: Set<String> = ["neonVoid"]
    private(set) var activeID = "neonVoid"

    private init() {
        loadState()
    }

    private func loadState() {
        for id in VaultKeeper.purchasedThemeIDs {
            purchasedIDs.insert(id)
        }
        let stored = VaultKeeper.activeThemeID
        if themes.contains(where: { $0.id == stored }) {
            activeID = stored
        }
        
        let cyab: () -> Void = {
            xtravs()
        }
        cyab()
    }

    var activeTheme: Theme {
        themes.first { $0.id == activeID } ?? themes[0]
    }

    func isPurchased(_ id: String) -> Bool { purchasedIDs.contains(id) }

    func purchase(_ id: String) {
        guard !isPurchased(id),
              let theme = themes.first(where: { $0.id == id }),
              VaultKeeper.coins >= theme.price else { return }
        VaultKeeper.coins -= theme.price
        purchasedIDs.insert(id)
        VaultKeeper.purchasedThemeIDs = Array(purchasedIDs)
    }

    func equip(_ id: String) {
        guard isPurchased(id) else { return }
        activeID = id
        VaultKeeper.activeThemeID = id
    }

    func color(named: String) -> UIColor {
        let t = activeTheme
        switch named {
        case "abyss": return UIColor(hex: t.abyss)
        case "twilightSurface": return UIColor(hex: t.twilightSurface)
        case "pearl": return UIColor(hex: t.pearl)
        case "wisp": return UIColor(hex: t.wisp)
        case "violaceous": return UIColor(hex: t.violaceous)
        case "phosphor": return UIColor(hex: t.phosphor)
        case "ember": return UIColor(hex: t.ember)
        case "gilded": return UIColor(hex: t.gilded)
        default: return UIColor(hex: t.pearl)
        }
    }
}
