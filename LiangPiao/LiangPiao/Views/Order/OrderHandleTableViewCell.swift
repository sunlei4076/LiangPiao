//
//  OrderHandleTableViewCell.swift
//  LiangPiao
//
//  Created by Zhang on 07/11/2016.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit

class OrderHandleTableViewCell: UITableViewCell {

    var cancelOrderBtn:UIButton!
    var payOrderBtn:UIButton!
    var didMakeContraints:Bool = false
    
    var linLabel:GloabLineView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpView()
    }
    
    func setUpView() {
        
        cancelOrderBtn = self.createButton("取消订单", backGround: UIColor.whiteColor(), titleColor: UIColor.init(hexString: App_Theme_4BD4C5_Color))
        cancelOrderBtn.buttonSetTitleColor(App_Theme_4BD4C5_Color, sTitleColor: App_Theme_40C6B7_Color)
        self.contentView.addSubview(cancelOrderBtn)
        
        payOrderBtn = self.createButton("立即支付", backGround: UIColor.init(hexString: App_Theme_4BD4C5_Color), titleColor: UIColor.whiteColor())
        payOrderBtn.buttonSetThemColor(App_Theme_4BD4C5_Color, selectColor: App_Theme_40C6B7_Color, size: CGSize.init(width: 80, height: 30))
        self.contentView.addSubview(payOrderBtn)
        
        linLabel = GloabLineView(frame: CGRectMake(15, 0, SCREENWIDTH - 30, 0.5))
        self.contentView.addSubview(linLabel)
        
        self.updateConstraintsIfNeeded()
    }
    
    func createButton(title:String, backGround:UIColor, titleColor:UIColor) -> UIButton {
        let  button = UIButton(type: .Custom)
        button.setTitle(title, forState: .Normal)
        button.backgroundColor = UIColor.whiteColor()
        if backGround != UIColor.init(hexString: App_Theme_4BD4C5_Color) {
            button.layer.cornerRadius = 2.0
            button.layer.borderColor = UIColor.init(hexString: App_Theme_4BD4C5_Color).CGColor
            button.layer.borderWidth = 1.0
        }
        button.clipsToBounds = true
        button.titleLabel?.font = App_Theme_PinFan_R_13_Font
        button.layer.backgroundColor = backGround.CGColor
        button.layer.borderColor = titleColor.CGColor
        button.layer.masksToBounds = true
        button.setTitleColor(titleColor, forState: .Normal)
        return button
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !self.didMakeContraints {
            
            cancelOrderBtn.snp_makeConstraints(closure: { (make) in
                make.right.equalTo(self.payOrderBtn.snp_left).offset(-12)
                make.centerY.equalTo(self.contentView.snp_centerY).offset(0)
                make.size.equalTo(CGSizeMake(80, 30))
            })
            
            payOrderBtn.snp_makeConstraints(closure: { (make) in
                make.right.equalTo(self.contentView.snp_right).offset(-15)
                make.centerY.equalTo(self.contentView.snp_centerY).offset(0)
                make.size.equalTo(CGSizeMake(80, 30))
            })
            
            self.didMakeContraints = true
            
        }
        super.updateConstraints()
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
