import Foundation
import KeychainAccess

class PasswordModel {
    
    var isPasswordSet: Bool = false
    var storedService: String?
    var temporaryPassword: String = "" 
    
    private let keychain = Keychain(service: "bundle.identifier")

    func verifyPassword(_ enteredPassword: String) -> Bool {
        do {
            let storedPassword = try keychain.get("yourKeyForPassword")
            return enteredPassword == storedPassword
        } catch {
            print("Error retrieving password from Keychain: \(error)")
            return false
        }
    }

    func savePasswordToKeychain(password: String) {
        do {
            try keychain.set(password, key: "yourKeyForPassword")
        } catch {
            print("Error saving password to Keychain: \(error)")
        }
    }
}
