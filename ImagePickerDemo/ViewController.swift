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
        label.textAlignment = .center
        
        return label
    }()
    
    let imageView: UIImageView =
    {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    
    let ciContext = CIContext()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.addSubview(imageView)
        view.addSubview(label)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let picker = UIImagePickerController()
        
        picker.sourceType = .photoLibrary
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any])
    {
        defer
        {
            dismiss(animated: true, completion: nil)
        }
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let ciImage = CIImage(image: image)?
                .applyingOrientation(imageOrientationToTiffOrientation(image.imageOrientation))
            else
        {
            return
        }

        let pointillize = CIFilter(name: "CIPointillize",
            withInputParameters: [kCIInputImageKey: ciImage])!
        
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(pointillize.outputImage!,
            from: pointillize.outputImage!.extent)

        imageView.image = UIImage(cgImage: cgImage!)
        label.isHidden = true
    }
    
    override func viewDidLayoutSubviews()
    {
        imageView.frame = view.bounds.insetBy(dx: 100, dy: 100)
        label.frame = view.bounds
    }
  
}

func imageOrientationToTiffOrientation(_ value: UIImageOrientation) -> Int32
{
    switch (value)
    {
    case .up:
        return 1
    case .down:
        return 3
    case .left:
        return 8
    case .right:
        return 6
    case .upMirrored:
        return 2
    case .downMirrored:
        return 4
    case .leftMirrored:
        return 5
    case .rightMirrored:
        return 7
    }
}
