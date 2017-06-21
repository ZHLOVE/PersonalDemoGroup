//
//  MSMenuButtonGroup.swift
//  mugshot
//
//  Created by Venpoo on 15/8/17.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

import UIKit

class MSMenuButtonGroup {

    enum Type {
        case Category   // 有内容
        case Blank      // 无内容空白
        case Feedback   // 反馈
    }
    /// 对应的分类信息，在 type 为 .Category 时非空
    let category: CategoryModel?
    let type: Type

    init?(type: Type) {
        self.category = nil
        self.type = type

        // 不允许通过这种方式创建 .Category 类型的对象
        // 保证 .Category 一定存在 category
        if type == .Category {
            return nil
        }
    }

    init(category: CategoryModel) {
        self.category = category
        self.type = .Category
    }

    func cell(table: MSMenuViewController, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = table.collectionViewMenu.dequeueReusableCellWithReuseIdentifier(
            "MSMenuButtonGroup", forIndexPath: indexPath)

        let iconView = cell.viewWithTag(1) as? UIImageView
        let nameLabel = cell.viewWithTag(2) as? UILabel

        // 根据类型不同，为各个项目设置点击效果
        if type == .Blank {
            cell.selectedBackgroundView = nil
        } else {
            let selectedView = UIView(frame: cell.frame)
            selectedView.backgroundColor = UIColor(redColor: 221,
                greenColor: 221, blueColor: 221, alpha: 1)
            cell.selectedBackgroundView = selectedView
        }

        // 设置子控件的内容
        switch type {
        case .Category:
            if MSNetwork.modelOnline {
                iconView!.setImageWithURL(category!.iconUrl,
                    placeholder: UIImage(named: "menu_init"),
                    placeholder_err: UIImage(named: "menu_err"),
                    animated: true)
            } else {
                iconView!.image = self.getMenuBtnImgByID(1)
            }
            nameLabel!.text = category!.name
            nameLabel!.font = nameLabel!.font.fontWithSize(16)
        case .Feedback:
            iconView!.image = UIImage(named: "icon_feedback")
            nameLabel!.text = NSLocalizedString("Not enough? Tell me.", comment: "")
            nameLabel!.font = nameLabel!.font.fontWithSize(12)
        case .Blank:
            iconView!.image = nil
            nameLabel!.text = ""
        }

        return cell
    }

    func getMenuBtnImgByID(imgId: Int) -> UIImage {
        var imgName = "menu_err"
        switch imgId {
        case 1:
            imgName = "button_1"
            break
        case 2:
            imgName = "button_2"
            break
        case 3:
            imgName = "button_3"
            break
        case 4:
            imgName = "button_4"
            break
        case 5:
            imgName = "button_5"
            break
        case 6, 14:
            imgName = "button_6_14"
            break
        case 7, 12, 15:
            imgName = "button_7_12_15"
            break
        case 8:
            imgName = "button_8"
            break
        case 9:
            imgName = "button_9"
            break
        case 10:
            imgName = "button_10"
            break
        default:
            imgName = "menu_err"
            break
        }
        return UIImage(named: imgName)!
    }
}
