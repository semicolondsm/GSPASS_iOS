//
//  MealCollectionViewCell.swift
//  GSPASS
//
//  Created by 김수완 on 2021/06/02.
//

import UIKit
import CollectionViewPagingLayout

class MealCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var breakfastMealLabel: UILabel!
    @IBOutlet weak var lunchMealLabel: UILabel!
    @IBOutlet weak var dinerMealLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension MealCollectionViewCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        .layout(.blur)
    }
}
