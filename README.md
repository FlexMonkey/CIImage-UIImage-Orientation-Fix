# CIImage-UIImage-Orientation-Fix
##### _Demo of UIImageOrientation to TIFF Orientation conversion that fixes orientation issues when creating CIImage from UIImage_

If you are creating a `CIImage` from a `UIImage` which originates from the photo library (e.g. with `UIImagePickerController`)  you may find the simple conversion such as `CIImage(image: UIImage(named: "sunflower.jpg")!)` fails to orient images properly, for example portrait images will be rotated to landscape.

This issue can be resolved by looking at the `imageOrientation` of the `UIImage `returned by the system, translating it from a `UIImageOrientation` to a TIFF orientation and applying that to the `CIImage`.

The code to do that looks like this (where `image` is the supplied `UIImage`):

```swift
let ciImage = CIImage(image: image)?.imageByApplyingOrientation(imageOrientationToTiffOrientation(image.imageOrientation))
```

The conversion function, `imageOrientationToTiffOrientation`, is a simple switch:

```swift
func imageOrientationToTiffOrientation(value: UIImageOrientation) -> Int32
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
```
There’s a demonstration project available here at my GitHub repository here that implements this fix.
