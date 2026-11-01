import Foundation

struct LetterRow: Equatable {
    let first: Int?
    let second: Int?

    init(first: Int?, second: Int?) {
        precondition(first != nil || second != nil)
        precondition(first.map { (1...26).contains($0) } ?? true)
        precondition(second.map { (1...26).contains($0) } ?? true)
        self.first = first
        self.second = second
    }

    var value: Int {
        switch (first, second) {
        case let (a?, b?): return abs(a - b)
        case let (a?, nil): return a
        case let (nil, b?): return b
        case (nil, nil): preconditionFailure("A row must have a letter")
        }
    }

    static func display(_ value: Int?) -> String {
        guard let value else { return "" }
        return String(UnicodeScalar(64 + value)!)
    }
}

struct LetterChoice: Equatable {
    let rows: [LetterRow]
    init(rows: [LetterRow]) {
        precondition(rows.count == 10)
        self.rows = rows
    }
    var value: Int { rows.reduce(0) { $0 + $1.value } }
}

enum LetterTarget: Equatable { case highest, lowest }

struct LetterQuestion: Equatable {
    let target: LetterTarget
    let choices: [LetterChoice]
    let correctIndex: Int

    init?(target: LetterTarget, choices: [LetterChoice]) {
        guard choices.count == 4 else { return nil }
        let values = choices.map(\.value)
        let extreme = target == .highest ? values.max()! : values.min()!
        let indices = values.indices.filter { values[$0] == extreme }
        guard indices.count == 1 else { return nil }
        self.target = target
        self.choices = choices
        correctIndex = indices[0]
    }
}

struct LetterSpeedGenerator {
    let difficulty: Difficulty

    init(difficulty: Difficulty = .classic) { self.difficulty = difficulty }

    // Custom modes vary the letter domain; they do not claim reference equivalence.
    var letterRange: ClosedRange<Int> {
        switch difficulty {
        case .classic: return 1...26
        case .easy: return 1...6
        case .normal: return 1...12
        case .hard: return 8...26
        case .expert: return 14...26
        }
    }

    func next<R: RandomNumberGenerator>(using random: inout R) -> LetterQuestion {
        // Regenerate the entire question on a tied target as in the reference.
        // A bounded fallback prevents repeated tied questions from looping forever.
        for _ in 0..<128 {
            let target: LetterTarget = Int.random(in: 0..<4, using: &random) == 0 ? .lowest : .highest
            var choices: [LetterChoice] = []
            for _ in 0..<4 {
                var rows: [LetterRow] = []
                for _ in 0..<10 {
                    let firstBlank = Int.random(in: 0..<100, using: &random) < 15
                    if firstBlank {
                        rows.append(LetterRow(first: nil, second: Int.random(in: letterRange, using: &random)))
                    } else {
                        let first = Int.random(in: letterRange, using: &random)
                        let secondBlank = Int.random(in: 0..<100, using: &random) < 15
                        rows.append(LetterRow(first: first, second: secondBlank ? nil : Int.random(in: letterRange, using: &random)))
                    }
                }
                choices.append(LetterChoice(rows: rows))
            }
            if let question = LetterQuestion(target: target, choices: choices) { return question }
        }
        let choices = (letterRange.lowerBound..<(letterRange.lowerBound + 4)).map { value in
            LetterChoice(rows: (0..<10).map { _ in LetterRow(first: value, second: nil) })
        }
        return LetterQuestion(target: .highest, choices: choices)!
    }
}
