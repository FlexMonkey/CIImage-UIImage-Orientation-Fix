# CIImage-UIImage-Orientation-Fix
##### _Demo of UIImageOrientation to TIFF Orientation conversion that fixes orientation issues when creating CIImage from UIImage_

If you are creating a `CIImage` from a `UIImage` which originates from the photo library (e.g. with `UIImagePickerController`)  you may find the simple conversion such as `CIImage(image: UIImage(named: "sunflower.jpg")!)` fails to orient images properly, for example portrait images will be rotated to landscape.

This issue can be resolved by looking at the `imageOrientation` of the `UIImage `returned by the system, translating it from a `UIImageOrientation` to a TIFF orientation and applying that to the `CIImage`.

The code to do that looks like this (where image is the supplied UIImage):

```swift
let ciImage = CIImage(image: image)?.imageByApplyingOrientation(imageOrientationToTiffOrientation(image.imageOrientation))
```

The conversion function, `imageOrientationToTiffOrientation`, is a simple switch:

```swift
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
```
There’s a demonstration project available here at my GitHub repository here that implements this fix.
