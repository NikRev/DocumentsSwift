import UIKit

class SettingsViewController: UIViewController {

    private let tableView = UITableView()
    private let sortingSwitch = UISwitch()
    private let cellIdentifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        // Устанавливаем начальное состояние переключателя
        sortingSwitch.isOn = UserDefaults.standard.bool(forKey: "sortingEnabled")
        sortingSwitch.addTarget(self, action: #selector(sortingSwitchChanged), for: .valueChanged)

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        title = "Settings"
        tableView.tableFooterView = UIView()
    }

    @objc private func sortingSwitchChanged() {
        UserDefaults.standard.set(sortingSwitch.isOn, forKey: "sortingEnabled")
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Sorting"
            cell.accessoryView = sortingSwitch
        case 1:
            cell.textLabel?.text = "Change Password"
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        case 1:
            // Открываем экран для смены пароля
            let changePasswordViewController = ChangePasswordViewController()
            let navigationController = UINavigationController(rootViewController: changePasswordViewController)
            present(navigationController, animated: true, completion: nil)
        default:
            break
        }
    }
}
