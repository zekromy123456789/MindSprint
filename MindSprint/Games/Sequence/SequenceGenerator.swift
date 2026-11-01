import Foundation

enum SequenceFamily: CaseIterable {
    case arithmetic, geometric, quadratic, special
}

enum SpecialSequence: CaseIterable {
    case squares, cubes, triangular
}

struct SequenceQuestion: Equatable {
    let family: SequenceFamily
    let terms: [Int]
    let isReversed: Bool

    init(family: SequenceFamily, terms: [Int], isReversed: Bool) {
        precondition(terms.count == 5)
        self.family = family
        self.terms = terms
        self.isReversed = isReversed
    }

    var visibleTerms: [Int] { Array(terms.prefix(4)) }
    var answer: Int { terms[4] }
    func accepts(_ text: String) -> Bool { text == String(answer) }
}

struct SequenceGenerator {
    let difficulty: Difficulty

    init(difficulty: Difficulty = .classic) { self.difficulty = difficulty }

    // Custom levels select subsets of the verified Classic question domain.
    var families: [SequenceFamily] {
        switch difficulty {
        case .classic: return SequenceFamily.allCases
        case .easy: return [.arithmetic, .special]
        case .normal: return [.arithmetic, .geometric, .special]
        case .hard: return [.geometric, .quadratic, .special]
        case .expert: return [.quadratic]
        }
    }

    func next<R: RandomNumberGenerator>(using random: inout R) -> SequenceQuestion {
        let family = families.randomElement(using: &random)!
        return make(family, using: &random)
    }

    func make<R: RandomNumberGenerator>(_ family: SequenceFamily, using random: inout R) -> SequenceQuestion {
        let terms: [Int]
        switch family {
        case .arithmetic:
            let initial = Int.random(in: 5...22, using: &random)
            let step = Int.random(in: 2...22, using: &random)
            terms = (0..<5).map { initial + $0 * step }
        case .geometric:
            let initial = Int.random(in: 5...22, using: &random)
            let ratio = Int.random(in: 2...9, using: &random)
            var next = initial
            terms = (0..<5).map { _ in
                let value = next
                next *= ratio
                return value
            }
        case .quadratic:
            let a = Int.random(in: -8...8, using: &random)
            let b = Int.random(in: -8...8, using: &random)
            let c = Int.random(in: -8...8, using: &random)
            terms = (1...5).map { a * $0 * $0 + b * $0 + c }
        case .special:
            let kind = SpecialSequence.allCases.randomElement(using: &random)!
            let start = Int.random(in: 1...5, using: &random)
            terms = (start..<(start + 5)).map { index in
                switch kind {
                case .squares: return index * index
                case .cubes: return index * index * index
                case .triangular: return index * (index + 1) / 2
                }
            }
        }
        let reverse = Bool.random(using: &random)
        return SequenceQuestion(family: family, terms: reverse ? Array(terms.reversed()) : terms,
                                isReversed: reverse)
    }
}
