import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var contents: [URL] = []

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadContents()
    }

    func setupUI() {
        title = "Documents"
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addPhoto))
    }

    @objc func loadContents() {
        do {
            contents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
            tableView.reloadData()
        } catch {
            myPresentAlert(title: "Ошибка", message: "Не удалось загрузить содержимое директории.")
            print("Ошибка: \(error.localizedDescription)")
        }
    }

    @objc func addPhoto() {
        print("Добавить фотографию")
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            let imageURL = documentsDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("png")
            if let imageData = image.pngData() {
                do {
                    try imageData.write(to: imageURL)
                    contents.append(imageURL)
                    tableView.reloadData()
                } catch {
                    myPresentAlert(title: "Ошибка", message: "Не удалось сохранить изображение.")
                    print("Ошибка при сохранении изображения: \(error.localizedDescription)")
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let fileURL = contents[indexPath.row]
        cell.textLabel?.text = fileURL.lastPathComponent
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Вы можете добавить дополнительную логику для обработки выбора строки (если необходимо)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (_, _, completionHandler) in
            self?.deleteFile(at: indexPath)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func deleteFile(at indexPath: IndexPath) {
        let fileURL = contents[indexPath.row]
        do {
            try FileManager.default.removeItem(at: fileURL)
            contents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            myPresentAlert(title: "Ошибка", message: "Не удалось удалить файл.")
            print("Ошибка при удалении файла: \(error.localizedDescription)")
        }
    }
}

extension UIViewController {
    func myPresentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
