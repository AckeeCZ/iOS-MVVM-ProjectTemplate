import UIKit

final class AppFlowController: FlowController {
    var childControllers = [FlowController]()

    private let window: UIWindow

    // MARK: Initializers

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: Public interface

    func start() {
        let vm = ExampleViewModel(dependencies: dependencies)
        let vc = ExampleViewController(viewModel: vm)

        window.rootViewController = vc
    }

    func handle(routingAction action: RoutingAction) {

    }
}
