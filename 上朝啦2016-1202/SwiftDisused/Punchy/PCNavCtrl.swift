
import UIKit

class PCNavCtrl: UINavigationController, UINavigationControllerDelegate {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.delegate = self
    }

    func navigationController(navigationController: UINavigationController,
                              willShowViewController viewController: UIViewController,
                                                     animated: Bool) {
        //隐藏状态栏
        navigationController.setNavigationBarHidden(
            viewController.respondsToSelector(Selector("hideNavCtrl")),
            animated: false)

        removeGestureAll(self)
    }

    //去除所有手势
    func removeGestureAll(controller: UIViewController) {
        if nil != controller.navigationController {
            if controller.navigationController!
                .respondsToSelector(Selector("interactivePopGestureRecognizer")) {
                // 禁用返回手势
                controller.navigationController!
                    .interactivePopGestureRecognizer!.enabled = false
            }
        }

        for ele in [controller.view, controller.topViewEF()] {
            if let gestures = ele.gestureRecognizers {
                for gesture in gestures {
                    ele.removeGestureRecognizer(gesture)
                }
            }
        }
    }
}
