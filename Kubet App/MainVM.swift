import UIKit

final class MainVM {
    
    // MARK: Properties
    var fullName: String? { didSet { checkFormValidity() } }
    var phoneNumber: String? { didSet { checkFormValidity() } }
    
    
    // MARK: Bindlable
    var bindalbeIsFormValid = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()
}


// MARK: - Fileprivate Methods
fileprivate extension MainVM {
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && phoneNumber?.isEmpty == false && phoneNumber?.count ?? 0 >= 9
        bindalbeIsFormValid.value = isFormValid
    }
}
