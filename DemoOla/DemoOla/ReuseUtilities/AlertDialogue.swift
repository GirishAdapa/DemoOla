//
//  AlertDialogue.swift
//  OlaDemo
//
//  Created by Abhishek Singh on 03/03/21.
//  Copyright © 2021 Girish. All rights reserved.
//

import UIKit

extension UIView{
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 475647
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.color = activityColor
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        backgroundView.addSubview(activityIndicator)
        self.addSubview(backgroundView)
    }
    func activityStopAnimating() {
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
}

struct ReuseAlert {
static func present(title: String?, message: String, actions: ReuseAlert.Action..., from controller: UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for action in actions {
        alertController.addAction(action.alertAction)
    }
    controller.present(alertController, animated: true, completion: nil)
    }
}

extension ReuseAlert {
    enum Action {
        case ok(handler: (() -> Void)?)
        case retry(handler: (() -> Void)?)
        case close

        // Returns the title of our action button
        private var title: String {
            switch self {
            case .ok:
                return "OK"
            case .retry:
                return "Retry"
            case .close:
                return "Close"
            }
        }

        // Returns the completion handler of our button
        private var handler: (() -> Void)? {
            switch self {
            case .ok(let handler):
                return handler
            case .retry(let handler):
                return handler
            case .close:
                return nil
            }
        }

        var alertAction: UIAlertAction {
            return UIAlertAction(title: title, style: .default, handler: { _ in
                if let handler = self.handler {
                    handler()
                }
            })
        }
    }
}



class ActivityIndicatorView
{
    var view: UIView!

var activityIndicator: UIActivityIndicatorView!

var title: String!

init(title: String, center: CGPoint, width: CGFloat = 200.0, height: CGFloat = 50.0)
{
    self.title = title

    let x = center.x - width/2.0
    let y = center.y - height/2.0

    self.view = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
    self.view.backgroundColor = UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 51.0/255.0, alpha: 0.5)
    self.view.layer.cornerRadius = 10

    self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    self.activityIndicator.color = UIColor.black
    self.activityIndicator.hidesWhenStopped = false

    let titleLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
    titleLabel.text = title
    titleLabel.textColor = UIColor.black

    self.view.addSubview(self.activityIndicator)
    self.view.addSubview(titleLabel)
}

func getViewActivityIndicator() -> UIView
{
    return self.view
}

func startAnimating()
{
    DispatchQueue.main.async {
     self.activityIndicator.startAnimating()
     UIApplication.shared.beginIgnoringInteractionEvents()
    }
}

func stopAnimating()
{
    DispatchQueue.main.async {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        self.view.removeFromSuperview()
    }
    
}
//end
}


