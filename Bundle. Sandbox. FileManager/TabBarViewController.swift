import UIKit

class TabBarViewController: UITabBarController {

    let viewController = ViewController()
    let settingsViewController = SettingsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        let filesTabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
        let settingsTabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        viewController.tabBarItem = filesTabBarItem
        settingsViewController.tabBarItem = settingsTabBarItem

        // Используем UINavigationController для каждого экрана
        let filesNavigationController = UINavigationController(rootViewController: viewController)
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)

        viewControllers = [filesNavigationController, settingsNavigationController]
    }
}
