import AppKit
import SwiftUI

struct GeneralSettings: View {
    let openAtLogin: OpenAtLogin
    @AppStorage(DefaultsKey.menuBarShows) private var shows = MenuBarShows.nameAndUsage
    @AppStorage("worldClocks.buenosAires") private var buenosAires = true
    @AppStorage("worldClocks.mexicoCity") private var mexicoCity = true
    @AppStorage("worldClocks.saoPaulo") private var saoPaulo = true
    @AppStorage("worldClocks.newYork") private var newYork = true

    var body: some View {
        Form {
            Section {
                Toggle(
                    "Open Pitboard at login",
                    isOn: Binding(
                        get: { openAtLogin.state != .disabled },
                        set: { openAtLogin.set($0) })
                )
                .accessibilityIdentifier("settings.openAtLogin")
                if openAtLogin.state == .requiresApproval {
                    LabeledContent {
                        Button("Open Login Items Settings…") {
                            openAtLogin.openSystemSettings()
                        }
                    } label: {
                        Text("macOS is waiting for you to allow Pitboard in Login Items.")
                            .explanatory()
                    }
                }
                if let failed = openAtLogin.failed {
                    Text(failed).explanatory()
                }
                Picker("Menu bar shows", selection: $shows) {
                    ForEach(MenuBarShows.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
            }
            Section("World clocks in menu bar") {
                Toggle("🇦🇷 Buenos Aires", isOn: $buenosAires)
                Toggle("🇲🇽 CDMX", isOn: $mexicoCity)
                Toggle("🇧🇷 São Paulo", isOn: $saoPaulo)
                Toggle("🇺🇸 Nueva York", isOn: $newYork)
            }
        }
        .formStyle(.grouped)
        .task {
            openAtLogin.read()
            // Login Items approval happens in System Settings; coming back reruns no `.task`.
            for await _ in NotificationCenter.default.notifications(
                named: NSApplication.didBecomeActiveNotification)
            {
                openAtLogin.read()
            }
        }
    }
}
