
import UIKit

extension UIViewController {

    //寻找当前 UIViewController 的顶层 UIView
    func topViewEF() -> UIView {
        var recentView = self
        while let parentVC = recentView.parentViewController {
            recentView = parentVC
        }
        return recentView.view
    }
}