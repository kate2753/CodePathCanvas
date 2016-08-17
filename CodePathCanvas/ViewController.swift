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
}

