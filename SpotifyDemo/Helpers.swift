import UIKit

func generateRandomData() -> [[UIColor]] {
    let numberOfRows = 20
    let numberOfItemsPerRow = 15

    return (0..<numberOfRows).map { _ in
        return (0..<numberOfItemsPerRow).map { _ in UIColor.randomColor() }
    }
}

extension UIColor {
    class func randomColor() -> UIColor {

        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100

        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}

var imageDictionary = NSMutableDictionary()

extension UIImageView {
    func loadImageFromPath(urlString: String) {
        if let img = imageDictionary[urlString] as? UIImage {
            image = img
        } else {
            image = UIImage()
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                let url = NSURL(string: urlString)!
                let data = NSData(contentsOfURL: url)!
                dispatch_async(dispatch_get_main_queue(), {
                    if let img = UIImage(data: data) {
                        imageDictionary.setValue(img, forKey: urlString)
                        self.image = img
                    }
                })
            }
        }
    }
    
    func makeImageCircular() {
        let imageLayer = layer
        imageLayer.cornerRadius = 1
        imageLayer.borderWidth = 1
        imageLayer.borderColor = UIColor.lightGrayColor().CGColor
        imageLayer.masksToBounds = true
        
        layer.cornerRadius = frame.size.width/2
        layer.masksToBounds = true
    }
    
    func makeCornersRound() {
        layer.cornerRadius = 2.5
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.lightGrayColor().CGColor
        clipsToBounds = true
    }
}

enum Segue : String {
    case SeachVC, ArtistProfileVC, SongTVC, AlbumTVC
}