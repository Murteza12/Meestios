//
//  chatView.swift
//  meestApp
//
//  Created by Yash on 8/22/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation
import UIKit

class chatView:UIView {
    
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lbl1:UILabel!
    var contentView: UIView?
    let nibName = "chatView"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
