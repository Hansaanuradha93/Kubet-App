import UIKit
import Firebase

final class MainVM {
    
    // MARK: Properties
    var fullName: String? { didSet { checkFormValidity() } }
    var phoneNumber: String? { didSet { checkFormValidity() } }
    
    
    // MARK: Bindlable
    var bindalbeIsFormValid = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()
}


// MARK: - Public Methods
extension MainVM {
    
    func registerUser(completion: @escaping (Bool, String) -> ()) {
        guard let fullName = fullName, let phoneNumber = phoneNumber else { return }
        bindableIsRegistering.value = true
        
        Auth.auth().signInAnonymously() { [weak self] authResult, error in
            guard let self = self else { return }
            self.bindableIsRegistering.value = false
            
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            completion(true, "Registering successful")
        }
    }
}


// MARK: - Fileprivate Methods
fileprivate extension MainVM {
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && phoneNumber?.isEmpty == false && phoneNumber?.count ?? 0 >= 9
        bindalbeIsFormValid.value = isFormValid
    }
}
