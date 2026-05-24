//
//  CanvasViewController.swift
//  canvasLab
//
//  Created by Gerard Recinto on 4/12/17.
//  Copyright © 2017 Gerard Recinto. All rights reserved.
//

import UIKit

@MainActor
class CanvasViewController: ViewController {

    @IBOutlet weak var trayView: UIView!

    private var newlyCreatedFace: UIImageView?
    private var newlyCreatedFaceOriginalCenter: CGPoint = .zero
    private var trayOriginalCenter: CGPoint = .zero
    private var trayDownOffset: CGFloat = 250
    private var trayUp: CGPoint = .zero
    private var trayDown: CGPoint = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x, y: trayView.center.y + trayDownOffset)
    }

    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        switch sender.state {
        case .began:
            trayOriginalCenter = trayView.center
        case .changed:
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        case .ended:
            let velocity = sender.velocity(in: view)
            let target = velocity.y > 0 ? trayDown : trayUp
            let damping: CGFloat = velocity.y > 0 ? 0.8 : 0.5
            UIView.animate(withDuration: 0.4, delay: 0,
                           usingSpringWithDamping: damping,
                           initialSpringVelocity: 1, options: []) {
                self.trayView.center = target
            }
        default:
            break
        }
    }

    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        switch sender.state {
        case .began:
            guard let imageView = sender.view as? UIImageView else { return }
            let face = UIImageView(image: imageView.image)
            face.isUserInteractionEnabled = true
            view.addSubview(face)
            face.center = CGPoint(x: imageView.center.x, y: imageView.center.y + trayView.frame.origin.y)
            newlyCreatedFace = face
            newlyCreatedFaceOriginalCenter = face.center
        case .changed:
            newlyCreatedFace?.center = CGPoint(
                x: newlyCreatedFaceOriginalCenter.x + translation.x,
                y: newlyCreatedFaceOriginalCenter.y + translation.y
            )
        default:
            break
        }
    }
}
