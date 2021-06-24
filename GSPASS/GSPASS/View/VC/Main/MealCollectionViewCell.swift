//
//  MealCollectionViewCell.swift
//  GSPASS
//
//  Created by 김수완 on 2021/06/02.
//

import UIKit
import CollectionViewPagingLayout

class MealCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dateStringLabel: UILabel!
    @IBOutlet weak var breakfastMealLabel: UILabel!
    @IBOutlet weak var lunchMealLabel: UILabel!
    @IBOutlet weak var dinerMealLabel: UILabel!

    public func bind(dateString: String, meal: MealModel) {
        dateStringLabel.text = dateString
        breakfastMealLabel.text = meal.breakfast != nil ? meal.breakfast!.toString() : "급식이 없습니다 ㅜㅜㅜ"
        lunchMealLabel.text = meal.lunch != nil ? meal.lunch!.toString() : "급식이 없습니다 ㅜㅜㅜ"
        dinerMealLabel.text = meal.dinner != nil ? meal.dinner!.toString() : "급식이 없습니다 ㅜㅜㅜ"
    }
}

extension MealCollectionViewCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        .layout(.blur)
    }
}
