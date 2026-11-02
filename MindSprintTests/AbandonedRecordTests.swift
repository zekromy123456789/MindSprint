import XCTest
@testable import MindSprint

private final class AbandonedClock: SessionClock { var now: TimeInterval = 0 }
private final class CrossingClock: SessionClock {
    var time: TimeInterval = 0
    var samples: [TimeInterval] = []
    var now: TimeInterval {
        if !samples.isEmpty { return samples.removeFirst() }
        return time
    }
}

final class AbandonedRecordTests: XCTestCase {
    func testAllGamesRecordOnlyStartedAbandonment() throws {
        let c = AbandonedClock()
        var a = ArithmeticRound(difficulty: .easy, clock: c, seed: 2)
        var p = ArithmeticProRound(difficulty: .hard, clock: c, seed: 2)
        var s = SequenceRound(difficulty: .expert, clock: c, seed: 2)
        var o = OptiverRound(difficulty: .normal, clock: c, seed: 2)
        var l = LetterSpeedRound(difficulty: .easy, clock: c, seed: 2)
        var m = MemoryRound(clock: c, seed: 2)
        var r = RiskRound(clock: c, seed: 2)
        var f = FlexibilityRound(clock: c, seed: 2)
        a.start(); p.start(); s.start(); o.start(); l.start(); m.beginStage(); r.start(); f.start()
        c.now = 3
        a.refresh(); p.refresh(); s.refresh(); o.refresh(); l.refresh(); m.refresh(); r.refresh(); f.refresh()
        a.abandon(); p.abandon(); s.abandon(); o.abandon(); l.abandon(); m.abandon(); r.abandon(); f.abandon()
        let records = try [XCTUnwrap(a.terminalRecord), XCTUnwrap(p.terminalRecord), XCTUnwrap(s.terminalRecord),
                           XCTUnwrap(o.terminalRecord), XCTUnwrap(l.terminalRecord), XCTUnwrap(m.terminalRecord),
                           XCTUnwrap(r.terminalRecord), XCTUnwrap(f.terminalRecord)]
        XCTAssertEqual(Set(records.map { $0.configuration.game }).count, 8)
        XCTAssertTrue(records.allSatisfy { $0.outcome == .abandoned })
        XCTAssertEqual(a.terminalRecord, a.terminalRecord)
        XCTAssertNil(a.completedRecord)
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appendingPathComponent("records.sqlite")
        do {
            let store = try RecordStore(url: url)
            for record in records { XCTAssertTrue(try store.insertOnce(record)); XCTAssertFalse(try store.insertOnce(record)) }
        }
        let saved = try RecordStore(url: url).allRecords()
        XCTAssertEqual(saved.count, 8)
        for record in saved { XCTAssertNil(RecordSummary(records: saved, configuration: record.configuration).bestScore) }
    }

    func testPreplayExitDoesNotCreateHistory() {
        let c = AbandonedClock()
        var a = ArithmeticRound(difficulty: .classic, clock: c, seed: 1)
        var m = MemoryRound(clock: c, seed: 1)
        var l = LetterSpeedRound(clock: c, seed: 1)
        a.start(); m.beginStage(); l.start()
        a.abandon(); m.abandon(); l.abandon()
        XCTAssertNil(a.terminalRecord)
        XCTAssertNil(m.terminalRecord)
        XCTAssertNil(l.terminalRecord)
    }

    func testExpiryWinsOverAbandonAndIsNotDuplicated() throws {
        let c = AbandonedClock()
        var a = ArithmeticRound(difficulty: .classic, clock: c, seed: 1)
        a.start(); c.now = 3; a.refresh(); c.now = 123; a.abandon()
        let record = try XCTUnwrap(a.terminalRecord)
        XCTAssertEqual(record.outcome, .completed)
        XCTAssertEqual(a.completedRecord, record)
        a.abandon()
        XCTAssertEqual(a.terminalRecord, record)
    }

    func testExpiryBetweenLeaveChecksStillCompletes() throws {
        let clock = CrossingClock()
        var round = ArithmeticRound(difficulty: .classic, clock: clock, seed: 1)
        round.start(); clock.time = 3; round.refresh()
        clock.samples = [122.999, 123]
        clock.time = 123
        round.abandon()
        let record = try XCTUnwrap(round.terminalRecord)
        XCTAssertEqual(round.phase, .completed)
        XCTAssertEqual(record.outcome, .completed)
        XCTAssertEqual(round.completedRecord, record)
    }

    @MainActor
    func testFailedAbandonedSaveCanBeRetried() throws {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: dir) }
        let parent = dir.appendingPathComponent("blocked")
        try Data().write(to: parent)
        let manager = RecordsManager(databaseURL: parent.appendingPathComponent("records.sqlite"))
        let c = AbandonedClock()
        var r = RiskRound(clock: c, seed: 1)
        r.start(); c.now = 3; r.refresh(); r.abandon()
        let record = try XCTUnwrap(r.terminalRecord)
        XCTAssertFalse(manager.save(record))
        XCTAssertEqual(manager.pendingCount, 1)
        manager.reload()
        XCTAssertNotNil(manager.loadError)
        try FileManager.default.removeItem(at: parent)
        manager.retryPending()
        XCTAssertEqual(manager.pendingCount, 0)
        XCTAssertNil(manager.loadError)
        XCTAssertEqual(manager.records, [record])
    }
}
