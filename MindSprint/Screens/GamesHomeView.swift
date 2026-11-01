import SwiftUI

struct GameDescriptor: Identifiable {
    let id: GameID
    let title: String
    let summary: String
    let symbol: String
    let rule: String

    static let all: [GameDescriptor] = [
        .init(id: .arithmetic, title: "Arithmetic", summary: "Build speed with the four operations.", symbol: "plus.forwardslash.minus", rule: "Solve each expression as quickly as you can."),
        .init(id: .arithmeticPro, title: "Arithmetic Pro", summary: "Work through compound expressions.", symbol: "function", rule: "Use the order of operations to solve each expression."),
        .init(id: .sequence, title: "Sequence", summary: "Find the missing number.", symbol: "list.number", rule: "Identify the pattern and complete the sequence."),
        .init(id: .optiver, title: "Optiver 80 in 8", summary: "Choose answers against the clock.", symbol: "timer", rule: "Choose the missing value from four options."),
        .init(id: .memory, title: "Memory", summary: "Recall digits in different orders.", symbol: "rectangle.stack", rule: "Watch the digits, then recall them in the requested order."),
        .init(id: .risk, title: "Risk", summary: "Decide when to collect.", symbol: "balloon", rule: "Pump for points or collect before the balloon pops."),
        .init(id: .flexibility, title: "Flexibility", summary: "Compare meaning and color.", symbol: "arrow.left.arrow.right", rule: "Decide whether the left word matches the right text color."),
        .init(id: .letterSpeed, title: "Letter Speed", summary: "Compare letter values quickly.", symbol: "character", rule: "Calculate the letter-grid values and choose the requested extreme.")
    ]
}

struct GamesHomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("A little sharper, every day.")
                        .font(.title2.bold())
                    Text("Explore eight games for focus and mental speed.")
                        .foregroundStyle(.secondary)
                }
                ForEach(GameDescriptor.all) { game in
                    NavigationLink {
                        GamePreparationView(game: game)
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: game.symbol)
                                .font(.title3.weight(.semibold))
                                .frame(width: 44, height: 44)
                                .background(.teal.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                                .accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(game.title).font(.headline).foregroundStyle(.primary)
                                Text(game.summary).font(.subheadline).foregroundStyle(.secondary)
                            }
                            Spacer(minLength: 4)
                            Image(systemName: "chevron.right").font(.caption.bold()).foregroundStyle(.tertiary)
                        }
                        .padding(14)
                        .background(.background, in: RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.secondary.opacity(0.15)))
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("game-\(game.id.rawValue)")
                }
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("MindSprint")
    }
}

struct GamePreparationView: View {
    let game: GameDescriptor
    @State private var difficulty: Difficulty = .classic
    @State private var proDifficulty: Difficulty = .normal

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Image(systemName: game.symbol)
                    .font(.largeTitle)
                    .foregroundStyle(.teal)
                    .accessibilityHidden(true)
                Text(game.summary).font(.title2.bold())
                VStack(alignment: .leading, spacing: 8) {
                    Text("How to play").font(.headline)
                    Text(game.rule).foregroundStyle(.secondary)
                }
                if game.id == .arithmetic {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Difficulty").font(.headline)
                        Picker("Difficulty", selection: $difficulty) {
                            ForEach(Difficulty.allCases, id: \.self) { level in
                                Text(level.rawValue.capitalized).tag(level)
                            }
                        }
                        Text("Solve as many as you can in two minutes. Correct answers advance automatically.")
                            .foregroundStyle(.secondary)
                    }
                    NavigationLink("Start", destination: ArithmeticGameView(difficulty: difficulty))
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("start-arithmetic")
                } else if game.id == .arithmeticPro {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Original questions").font(.headline)
                        Text("These independently created expressions have a different mix from the reference game. Solve as many as you can in two minutes.")
                            .foregroundStyle(.secondary)
                        Picker("Difficulty", selection: $proDifficulty) {
                            ForEach(ArithmeticProGenerator.difficulties, id: \.self) { level in
                                Text(level.rawValue.capitalized).tag(level)
                            }
                        }
                        .accessibilityIdentifier("pro-difficulty")
                    }
                    NavigationLink("Start", destination: ArithmeticProGameView(difficulty: proDifficulty))
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("start-pro")
                } else if game.id == .sequence {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Difficulty").font(.headline)
                        Picker("Difficulty", selection: $difficulty) {
                            ForEach(Difficulty.allCases, id: \.self) { level in
                                Text(level.rawValue.capitalized).tag(level)
                            }
                        }
                        .accessibilityIdentifier("sequence-difficulty")
                        Text("Custom levels change the types of patterns you see.").font(.footnote)
                            .foregroundStyle(.secondary)
                        Text("Find each missing number. Correct answers advance automatically; you have two minutes.")
                            .foregroundStyle(.secondary)
                    }
                    NavigationLink("Start", destination: SequenceGameView(difficulty: difficulty))
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("start-sequence")
                } else if game.id == .optiver {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("80 questions · 8 minutes").font(.headline)
                        Text("Choose the missing value. Correct answers earn 1 point; incorrect answers lose 2 points.")
                        Picker("Difficulty", selection: $difficulty) {
                            ForEach(Difficulty.allCases, id: \.self) { level in
                                Text(level.rawValue.capitalized).tag(level)
                            }
                        }.accessibilityIdentifier("optiver-difficulty")
                        Text("Custom levels change the operations you practice.")
                            .font(.footnote).foregroundStyle(.secondary)
                        Text("Questions use reference-style formatting and avoid invalid or ambiguous equations.")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                    NavigationLink("Start", destination: OptiverGameView(difficulty: difficulty))
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("start-optiver")
                } else if game.id == .memory {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Three rounds").font(.headline)
                        Text("Recall digits in order, in reverse, then from smallest to largest. Each length allows two attempts.")
                            .foregroundStyle(.secondary)
                    }
                    NavigationLink("Start", destination: MemoryGameView())
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("start-memory")
                } else if game.id == .risk {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("20 rounds").font(.headline)
                        Text("Each balloon starts with one unbanked point. Pump to increase it, or collect before it pops.")
                            .foregroundStyle(.secondary)
                    }
                    NavigationLink("Start", destination: RiskGameView())
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("start-risk")
                } else if game.id == .flexibility {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("60 seconds").font(.headline)
                        Text("Compare the left word's meaning with the right word's ink color. Correct answers earn 1 point; incorrect answers lose 1 point.")
                            .foregroundStyle(.secondary)
                    }
                    NavigationLink("Start", destination: FlexibilityGameView())
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("start-flexibility")
                } else if game.id == .letterSpeed {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("10 rounds · 30 seconds each").font(.headline)
                        Text("A = 1 through Z = 26. For two letters, take the difference between their values; for one letter, use its value. Add the ten rows and choose the highest or lowest total. Faster correct answers earn more points.")
                            .foregroundStyle(.secondary)
                    }
                    NavigationLink("Start", destination: LetterSpeedGameView())
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("start-letter-speed")
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Classic").font(.headline)
                        Text("This game is in development. Rules and options will be confirmed before it becomes available.")
                            .foregroundStyle(.secondary)
                    }
                    Button("Coming soon") { }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                        .disabled(true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .navigationTitle(game.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
