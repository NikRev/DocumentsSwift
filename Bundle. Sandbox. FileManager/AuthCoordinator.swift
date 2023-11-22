import UIKit

class AuthCoordinator {
    var navigationController: UINavigationController?

    func start() {
        let authController = AuthContoller()
        authController.coordinator = self
        navigationController = UINavigationController(rootViewController: authController)
    }

    func showTabBar() {
        let tabBarViewController = TabBarViewController()
        navigationController?.pushViewController(tabBarViewController, animated: true)
    }
}

