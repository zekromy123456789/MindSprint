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
                VStack(alignment: .leading, spacing: 8) {
                    Text("Classic").font(.headline)
                    Text("This game is in development. Rules and options will be confirmed before it becomes available.")
                        .foregroundStyle(.secondary)
                }
                Button("Coming soon") { }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                    .disabled(true)
                Text("No personal best yet").font(.footnote).foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .navigationTitle(game.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
