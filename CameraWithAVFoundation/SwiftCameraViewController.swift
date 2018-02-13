//
//  SwiftCameraViewController.swift
//  CameraWithAVFoundation
//
//  Created by Yoshiyuki Kawashima on 2018/02/11.
//  Copyright © 2018 Gabriel Alvarado. All rights reserved.
//

import UIKit

class SwiftCameraViewController: UIViewController {

  var cameraView: CameraSessionView!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func launchCamera(_ sender: Any) {
    //Set white status bar
    setNeedsStatusBarAppearanceUpdate()

    //Instantiate the camera view & assign its frame
    cameraView = CameraSessionView.init(frame: view.frame)

    //Set the camera view's delegate and add it as a subview
    cameraView.delegate = self

    //Apply animation effect to present the camera view
    let applicationLoadViewIn: CATransition = CATransition()
    applicationLoadViewIn.duration = 0.6
    applicationLoadViewIn.type = kCATransitionReveal
    applicationLoadViewIn.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    cameraView.layer.add(applicationLoadViewIn, forKey: kCATransitionReveal)

    view.addSubview(cameraView)

    //____________________________Example Customization____________________________
    // cameraView.setTopBarColor(UIColor.init(red:0.97, green:0.97, blue:0.97, alpha: 0.64))
    // cameraView.hideFlashButton() //On iPad flash is not present, hence it wont appear.
    // cameraView.hideCameraToggleButton()
    // cameraView.hideDismissButton()
  }

  func prefersStatusBarHidden() -> Bool {
    return true
  }

}

extension SwiftCameraViewController: CACameraSessionDelegate {

  func didCapture(_ image: UIImage) {
    print("CAPTURED IMAGE");
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    cameraView.removeFromSuperview()
  }

  @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer) {
    //Show error alert if image could not be saved
    if error != nil {
      let ac = UIAlertController(title: "Error!", message: "Image couldn't be saved", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(ac, animated: true, completion: nil)
    }
  }

}
