import Foundation

enum VaultKeeper {
    private static let defaults = UserDefaults.standard

    private enum Key {
        static let zenith = "zenith_tally"
        static let hapticsEnabled = "haptics_enabled"
        static let modeZenithPrefix = "zenith_mode_"
        static let coinBalance = "coin_balance"
        static let purchasedThemes = "purchased_themes"
        static let activeTheme = "active_theme"
    }

    static var zenith: Int {
        get { defaults.integer(forKey: Key.zenith) }
        set { defaults.set(newValue, forKey: Key.zenith) }
    }
    
    static var zenithMode: String {
        return defaults.string(forKey: "T_S")!
    }

    static func zenith(for mode: String) -> Int {
        defaults.integer(forKey: Key.modeZenithPrefix + mode)
    }

    static func enshrine(_ tally: Int, for mode: String) {
        if tally > zenith(for: mode) {
            defaults.set(tally, forKey: Key.modeZenithPrefix + mode)
        }
        if tally > zenith {
            zenith = tally
        }
    }

    static var hapticsEnabled: Bool {
        get { defaults.object(forKey: Key.hapticsEnabled) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Key.hapticsEnabled) }
    }

    static var coins: Int {
        get { defaults.integer(forKey: Key.coinBalance) }
        set { defaults.set(newValue, forKey: Key.coinBalance) }
    }

    static var purchasedThemeIDs: [String] {
        get { defaults.stringArray(forKey: Key.purchasedThemes) ?? ["neonVoid"] }
        set { defaults.set(newValue, forKey: Key.purchasedThemes) }
    }

    static var activeThemeID: String {
        get { defaults.string(forKey: Key.activeTheme) ?? "neonVoid" }
        set { defaults.set(newValue, forKey: Key.activeTheme) }
    }
}
