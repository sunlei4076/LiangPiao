//
//  DetailAddressTableViewCell.swift
//  LiangPiao
//
//  Created by Zhang on 05/11/2016.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit

class DetailAddressTableViewCell: UITableViewCell {

    
    var textView:UITextView!
    var didMakeConstraints:Bool = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpView()
    }
    
    func setUpView(){
        textView = UITextView()
        textView.placeholder = "请填写详细地址"
        textView.tintColor = UIColor.init(hexString: App_Theme_4BD4C5_Color)
        textView.placeholderLabel.font = App_Theme_PinFan_R_13_Font
        textView.placeholderLabel.textColor = UIColor.init(hexString: App_Theme_BBC1CB_Color)
        textView.scrollEnabled = false
        textView.returnKeyType = .Done
        textView.font = App_Theme_PinFan_R_13_Font
        textView.textColor = UIColor.init(hexString: App_Theme_384249_Color)
        self.contentView.addSubview(textView)
        
        self.updateConstraintsIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !self.didMakeConstraints {
            textView.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(self.contentView.snp_top).offset(7)
                make.bottom.equalTo(self.contentView.snp_bottom).offset(-17)
                make.left.equalTo(self.contentView.snp_left).offset(10)
                make.right.equalTo(self.contentView.snp_right).offset(-15)
            })
            self.didMakeConstraints = true
        }
        super.updateConstraints()
    }
    
    func setPlaceholerText(text:String) {
        textView.placeholder = text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
