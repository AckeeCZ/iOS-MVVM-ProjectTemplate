import Foundation

protocol FlowController: class {
    var childControllers: [FlowController] { get set }

    func start()
    func handle(routingAction action: RoutingAction)
    func addChild(_ flowController: FlowController)
}

extension FlowController {
    func addChild(_ flowController: FlowController) {
        if !childControllers.contains { $0 === flowController } {
            childControllers.append(flowController)
        }
    }

    func removeChild(_ flowController: FlowController) {
        if let index = childControllers.index (where: { $0 === flowController }) {
            childControllers.remove(at: index)
        }
    }
}
