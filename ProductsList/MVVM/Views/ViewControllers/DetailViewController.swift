//
//  DetailViewController.swift
//  ProductsList
//
//  Created by Vahid on 16/01/2021.
//  Copyright © 2021 Vahid. All rights reserved.
//

import UIKit

// Detail View Controller to show and edit note of the product with subclass of BaseViewController
class DetailViewController: BaseViewController {
    @IBOutlet var noteTextField: UITextField!
    @IBOutlet var productImageView: UIImageView!

    var product: Product? {
        didSet {
            configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }

    private func setupInfo() {
        if let product = product, let noteTextField = noteTextField,
           let productImageView = productImageView
        {
            noteTextField.text = product.note ?? "-"
            title = product.name

            // fetchImage via download, caching and if stored from CoreData
            productImageView.fetchImage(product)
        }
    }

    func configureView() {
        // hide/show keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // tap gesture to dimiss keyboard
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        // extract info from ViewModel
        setupInfo()
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification _: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
}

extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        DataBaseManger.updateNote(noteField: textField.text ?? "-", identifierField: product!.identifier.toString())
    }
}
