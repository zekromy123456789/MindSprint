import UIKit

@MainActor
final class HapticFeedback {
    static let shared = HapticFeedback()
    private let keyGenerator = UIImpactFeedbackGenerator(style: .soft)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private init() {}

    func prepare() {
        keyGenerator.prepare()
        notificationGenerator.prepare()
    }

    func keypress(enabled: Bool) {
        guard enabled else { return }
        keyGenerator.impactOccurred(intensity: 0.35)
        keyGenerator.prepare()
    }

    func result(_ type: UINotificationFeedbackGenerator.FeedbackType, enabled: Bool) {
        guard enabled else { return }
        notificationGenerator.notificationOccurred(type)
        notificationGenerator.prepare()
    }
}
