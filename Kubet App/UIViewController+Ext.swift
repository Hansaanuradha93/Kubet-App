import UIKit

extension UIViewController {
    
    func showPreloader() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.6
        backgroundView.tag = 475647
        backgroundView.layer.cornerRadius = 10
        view.addSubview(backgroundView)
        backgroundView.centerInSuperview(size: CGSize(width: 120, height: 90))
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        backgroundView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])
        
        view.isUserInteractionEnabled = false
    }

    
    func hidePreloader() {
        if let background = view.viewWithTag(475647){
            background.removeFromSuperview()
        }
        view.isUserInteractionEnabled = true
    }
}