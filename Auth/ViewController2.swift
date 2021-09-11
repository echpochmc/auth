//
//  ViewController2.swift
//  Auth
//
//  Created by Азат Султанов on 11.09.2021.
//

import UIKit

class ViewController2: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    
    let defaults = UserDefaultsData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        logoutButton.layer.cornerRadius = logoutButton.frame.height / 2
        
        User.users.forEach { user in
            if user.email == defaults.getUserEmail() {
                emailLabel.text = user.email
                nameLabel.text = user.name
                surnameLabel.text = user.surname
                imageView.image = user.image
            }
        }
    }
    // MARK: - Actions
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        defaults.deleteData()
        navigationController?.popViewController(animated: true)
    }
}
