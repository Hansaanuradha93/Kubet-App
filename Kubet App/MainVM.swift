import UIKit
import Firebase

final class MainVM {
    
    // MARK: Properties
    var fullName: String? { didSet { checkFormValidity() } }
    var phoneNumber: String? { didSet { checkFormValidity() } }
    var urlString: String? = "https://www.google.com" // TODO: fetch the correct url from firebase and replace this dummy value
    
    
    // MARK: Bindlable
    var bindalbeIsFormValid = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()
}


// MARK: - Public Methods
extension MainVM {
    
    func registerUser(completion: @escaping (Bool, String) -> ()) {
        bindableIsRegistering.value = true
        
        Auth.auth().signInAnonymously() { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.bindableIsRegistering.value = false
                completion(false, error.localizedDescription)
                return
            }
            
            self.saveUserInfoToFirestore(completion: completion)
        }
    }
}


// MARK: - Fileprivate Methods
fileprivate extension MainVM {
    
    func saveUserInfoToFirestore(completion: @escaping (Bool, String) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let userInfo = [
            "uid": uid,
            "fullName": fullName ?? "",
            "phoneNumber": phoneNumber ?? ""
            ] as [String : Any]
                
        Firestore.firestore().collection("kubet_users").addDocument(data: userInfo) { [weak self] error in
            guard let self = self else { return }
            self.bindableIsRegistering.value = false
            
            if let error = error {
                print(error.localizedDescription)
                completion(false, Strings.somethingWentWrong)
                return
            }
            completion(true, Strings.authenticationSuccessfull)
        }
    }
    
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && phoneNumber?.isEmpty == false && phoneNumber?.count ?? 0 >= 9
        bindalbeIsFormValid.value = isFormValid
    }
}
