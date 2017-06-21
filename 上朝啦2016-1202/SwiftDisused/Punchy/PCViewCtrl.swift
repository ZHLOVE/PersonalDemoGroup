
import UIKit

class PCViewController: UIViewController {

    //将跳转后的VC的导航栏返回按钮标题设为空
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        let returnButtonItem = UIBarButtonItem()
        returnButtonItem.title = ""
        self.navigationItem.backBarButtonItem = returnButtonItem
    }
}
