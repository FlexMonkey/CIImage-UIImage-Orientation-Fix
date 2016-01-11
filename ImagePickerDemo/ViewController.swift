//
//  ViewController.swift
//  ImagePickerDemo
//
//  Created by Simon Gladman on 11/01/2016.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    let label: UILabel =
    {
        let label = UILabel()
    
        label.text = "Touch the screen to open image picker"
        label.textAlignment = .Center
        
        return label
    }()
    
    let imageView: UIImageView =
    {
        let imageView = UIImageView()
        
        imageView.contentMode = .ScaleAspectFit
        
        return imageView
    }()
    
    
    let ciContext = CIContext()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.addSubview(imageView)
        view.addSubview(label)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        let picker = UIImagePickerController()
        
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        defer
        {
            dismissViewControllerAnimated(true, completion: nil)
        }

        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            ciImage = CIImage(image: image)?
                .imageByApplyingOrientation(imageOrientationToTiffOrientation(image.imageOrientation))
            else
        {
            return
        }
        
        let pointillize = CIFilter(name: "CIPointillize",
            withInputParameters: [kCIInputImageKey: ciImage])!
        
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(pointillize.outputImage!,
            fromRect: pointillize.outputImage!.extent)
        
        imageView.image = UIImage(CGImage: cgImage)
        label.hidden = true
    }
    
    override func viewDidLayoutSubviews()
    {
        imageView.frame = view.bounds.insetBy(dx: 100, dy: 100)
        label.frame = view.bounds
    }
  
}

func imageOrientationToTiffOrientation(value: UIImageOrientation) -> Int32
{
    switch (value)
    {
    case UIImageOrientation.Up:
        return 1
    case UIImageOrientation.Down:
        return 3
    case UIImageOrientation.Left:
        return 8
    case UIImageOrientation.Right:
        return 6
    case UIImageOrientation.UpMirrored:
        return 2
    case UIImageOrientation.DownMirrored:
        return 4
    case UIImageOrientation.LeftMirrored:
        return 5
    case UIImageOrientation.RightMirrored:
        return 7
    }
}
