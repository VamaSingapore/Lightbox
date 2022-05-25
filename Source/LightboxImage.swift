import UIKit
import SDWebImage

open class LightboxImage {

  open fileprivate(set) var image: UIImage?
  open fileprivate(set) var imageURL: URL?
  open fileprivate(set) var videoURL: URL?
  open fileprivate(set) var imageClosure: (() -> UIImage)?
  open var text: String
    
    var hasVideoContent: Bool {
        return videoURL != nil
    }
    
    var hasImageContent: Bool {
        return (imageURL != nil) || (image != nil)
    }

  // MARK: - Initialization

  internal init(text: String = "") {
    self.text = text
  }

  public init(image: UIImage? = nil, videoURL: URL? = nil) {
    self.image = image
    self.text = ""
    self.videoURL = videoURL
  }
    
  public init(videoURL: URL) {
      self.image = nil
      self.text = ""
      self.videoURL = videoURL
    }

  public init(imageURL: URL? = nil, text: String = "", videoURL: URL? = nil) {
    self.imageURL = imageURL
    self.text = text
    self.videoURL = videoURL
  }


  open func addImageTo(_ imageView: SDAnimatedImageView, completion: ((UIImage?) -> Void)? = nil) {
    if let image = image {
      imageView.image = image
      completion?(image)
    } else if let imageURL = imageURL {
      LightboxConfig.loadImage(imageView, imageURL, completion)
    } else if let imageClosure = imageClosure {
      let img = imageClosure()
      imageView.image = img
      completion?(img)
    } else {
      imageView.image = nil
      completion?(nil)
    }
  }
}
