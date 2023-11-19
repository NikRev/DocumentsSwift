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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавить фотографию", style: .plain, target: self, action: #selector(addPhoto))
    }
    
    @objc func loadContents() {
        do {
            contents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
            tableView.reloadData()
        } catch {
            showAlert(title: "Ошибка", message: "Не удалось загрузить содержимое директории.")
            print("ошибка: \(error.localizedDescription)")
        }
    }
    
    @objc func addPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
  
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            let imageURL = documentsDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("png")
            if let imageData = image.pngData() {
                do {
                    try imageData.write(to: imageURL)
                    contents.append(imageURL)
                    tableView.reloadData()
                } catch {
                    showAlert(title: "Ошибка", message: "Не удалось сохранить изображение.")
                    print("Error saving image: \(error.localizedDescription)")
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let fileURL = contents[indexPath.row]
        cell.textLabel?.text = fileURL.lastPathComponent
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = contents[indexPath.row]
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
            showAlert(title: "Ошибка", message: "Не удалось удалить файл.")
            print("Error deleting file: \(error.localizedDescription)")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
