import Foundation
import Testing
@testable import PitboardApp

@Test func worldClocksUseCityTimeZones() {
    let winter = Date(timeIntervalSince1970: 1_736_942_400) // 2025-01-15 12:00 UTC
    #expect(WorldClock.cities.map { $0.time(at: winter) } == ["09:00", "06:00", "09:00", "07:00"])
    let summer = Date(timeIntervalSince1970: 1_752_580_800) // 2025-07-15 12:00 UTC
    #expect(WorldClock.cities.map { $0.time(at: summer) } == ["09:00", "06:00", "09:00", "08:00"])
}
