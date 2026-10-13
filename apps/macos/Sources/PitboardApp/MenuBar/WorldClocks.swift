import Foundation
import SwiftUI

struct WorldClock: Identifiable {
    let city: String
    let flag: String
    let zone: String
    var id: String { zone }

    static let cities = [
        WorldClock(city: "Buenos Aires", flag: "🇦🇷", zone: "America/Argentina/Buenos_Aires"),
        WorldClock(city: "CDMX", flag: "🇲🇽", zone: "America/Mexico_City"),
        WorldClock(city: "São Paulo", flag: "🇧🇷", zone: "America/Sao_Paulo"),
        WorldClock(city: "Nueva York", flag: "🇺🇸", zone: "America/New_York"),
    ]

    func time(at date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: zone)
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct WorldClocks: View {
    var body: some View {
        TimelineView(.everyMinute) { context in
            Section("World clocks") {
                ForEach(WorldClock.cities) { clock in
                    Text("\(clock.flag) \(clock.city)   \(clock.time(at: context.date))")
                        .monospacedDigit()
                        .accessibilityIdentifier("clock.\(clock.zone)")
                }
            }
        }
    }
}
