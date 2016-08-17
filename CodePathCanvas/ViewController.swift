//
//  ViewController.swift
//  CodePathCanvas
//
//  Created by kate_odnous on 8/17/16.
//  Copyright © 2016 Kate Odnous. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var trayView: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()

    trayCenterWhenOpen = trayView.center
    trayCenterWhenClosed = CGPoint(x: trayView.center.x, y: trayView.center.y + trayView.frame.height - 30)
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  var trayOriginalCenter: CGPoint!
  var trayCenterWhenOpen: CGPoint!
  var trayCenterWhenClosed: CGPoint!
  @IBAction func onTrayPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
    if panGestureRecognizer.state == UIGestureRecognizerState.Began {
      trayOriginalCenter = trayView.center
    } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
      let translation = panGestureRecognizer.translationInView(trayView)
      trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
    } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
      let velocity = panGestureRecognizer.velocityInView(trayView)
      UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
        self.trayView.center = velocity.y > 0 ? self.trayCenterWhenClosed : self.trayCenterWhenOpen
        }, completion: nil)
    }
  }

  @IBAction func onTrayTapGesture(sender: UITapGestureRecognizer) {
    UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
      self.trayView.center = self.trayView.center.y == self.trayCenterWhenOpen.y ? self.trayCenterWhenClosed : self.trayCenterWhenOpen
      }, completion: nil)

  }

  var newlyCreatedFaceOriginalCenter: CGPoint!
  var newlyCreatedFace: UIImageView!
  @IBAction func onSmileyTapGesture(panGestureRecognizer: UIPanGestureRecognizer) {
    if panGestureRecognizer.state == UIGestureRecognizerState.Began {
      // Gesture recognizers know the view they are attached to
      let imageView = panGestureRecognizer.view as! UIImageView

      // Create a new image view that has the same image as the one currently panning
      newlyCreatedFace = UIImageView(image: imageView.image)
      newlyCreatedFace.userInteractionEnabled = true
      // Add the new face to the tray's parent view.
      view.addSubview(newlyCreatedFace)

      // Initialize the position of the new face.
      newlyCreatedFace.center = imageView.center

      // Since the original face is in the tray, but the new face is in the
      // main view, you have to offset the coordinates
      newlyCreatedFace.center.y += trayView.frame.origin.y
      newlyCreatedFaceOriginalCenter = newlyCreatedFace.center

      let canvasSmiliePanGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.onCanvasSmileyPanGesture))
      newlyCreatedFace.addGestureRecognizer(canvasSmiliePanGesture)

    } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
      let translation = panGestureRecognizer.translationInView(panGestureRecognizer.view)
      newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
    }
  }

  var imageViewOriginalCenter: CGPoint!
  func onCanvasSmileyPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
    let imageView = panGestureRecognizer.view as! UIImageView

    if panGestureRecognizer.state == UIGestureRecognizerState.Began {
      imageView.frame = CGRect(origin: imageView.frame.origin, size: CGSize(width: imageView.frame.width + 5, height: imageView.frame.height + 5))
      imageViewOriginalCenter = imageView.center
    } else if panGestureRecognizer.state == .Changed {
      let translation = panGestureRecognizer.translationInView(panGestureRecognizer.view)
      imageView.center = CGPoint(x: imageViewOriginalCenter.x + translation.x, y: imageViewOriginalCenter.y + translation.y)
    } else if panGestureRecognizer.state == .Ended {
      imageView.frame = CGRect(origin: imageView.frame.origin, size: CGSize(width: imageView.frame.width - 5, height: imageView.frame.height - 5))
    }
  }
}

