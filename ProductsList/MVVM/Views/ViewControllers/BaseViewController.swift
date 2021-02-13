//
//  BaseViewController.swift
//  MyTaxi
//
//  Created by Vahid on 07/11/2020.
//

import Foundation
import NVActivityIndicatorView
import UIKit

// Base View Controller subclass with UIViewController
class BaseViewController: UIViewController {
    lazy var nvActivityIndicatorView: NVActivityIndicatorView = {
        let frameIndicator = CGRect(x: 0, y: 0, width: 100, height: 100)
        let nvActivityIndicatorView = NVActivityIndicatorView(
            frame: frameIndicator, type:
            NVActivityIndicatorType.ballScaleRippleMultiple,
            color: UIColor.orange, padding: 0.0
        )
        return nvActivityIndicatorView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showErrorMessage(_ message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }

    func showLoadingView(_ view: UIView) {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height

        DispatchQueue.main.async {
            let alignCenter = self.nvActivityIndicatorView.frame.size.width / 2
            var point = CGPoint(x: w / 2 - alignCenter, y: h / 2 - alignCenter - 100)
            if h <= w {
                point = CGPoint(x: point.x, y: point.y + 100)
            }
            self.nvActivityIndicatorView.frame = CGRect(origin: point, size: self.nvActivityIndicatorView.frame.size)
            view.addSubview(self.nvActivityIndicatorView)
            self.nvActivityIndicatorView.startAnimating()
        }
    }

    func hideLoadingView(_ view: UIView) {
        DispatchQueue.main.async {
            if self.nvActivityIndicatorView.isDescendant(of: view) {
                self.nvActivityIndicatorView.stopAnimating()
                self.nvActivityIndicatorView.removeFromSuperview()
            }
        }
    }
}
