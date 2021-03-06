//
//  OrderPayTableViewCell.swift
//  LiangPiao
//
//  Created by Zhang on 07/11/2016.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit

class OrderPayTableViewCell: UITableViewCell {

    var lineLabel:GloabLineView!
    var receiptsLabel:UILabel!
    var discountCoupon:UILabel!
    var packingFee:UILabel!
    
    var didMakeConstraints:Bool = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpView()
    }
    
    func setUpView() {
        
        let receipts = self.createLabel(CGRectMake(15, 25, 50, 17), name:"代收票款")
        self.contentView.addSubview(receipts)
        
        let discount = self.createLabel(CGRectMake(15, 57, 50, 17), name:"优惠券")
        self.contentView.addSubview(discount)
        
        let packing = self.createLabel(CGRectMake(15, 89, 50, 17), name:"配送费")
        self.contentView.addSubview(packing)
        
        receiptsLabel = self.createLabel(CGRectMake(SCREENWIDTH - 180, 25, 165, 17),name: "360 元")
        receiptsLabel.textAlignment = .Right
        self.contentView.addSubview(receiptsLabel)
        
        discountCoupon = self.createLabel(CGRectMake(SCREENWIDTH - 180, 57, 165, 17),name: "0.00 元")
        discountCoupon.textAlignment = .Right
        self.contentView.addSubview(discountCoupon)
        
        packingFee = self.createLabel(CGRectMake(SCREENWIDTH - 180, 89, 165, 17),name: "8.00 元")
        packingFee.textAlignment = .Right
        self.contentView.addSubview(packingFee)
        
        lineLabel = GloabLineView(frame: CGRectMake(15, 124.5, SCREENWIDTH - 30, 0.5))
        self.contentView.addSubview(lineLabel)
        
        self.updateConstraintsIfNeeded()
    }
    
    func setData(model:OrderList) {
        let doubleMuch = Double(Double(model.remainCount) * Double(model.ticket.price))
        let much = "\(doubleMuch)".muchType("\(doubleMuch)")
        let deliveryPrice = "\(model.deliveryPrice)".muchType("\(model.deliveryPrice)")
        receiptsLabel.text = "\(much) 元"
        packingFee.text = "\(deliveryPrice) 元"
    }
    
    func createLabel(frame:CGRect,name:String) -> UILabel {
        let label = UILabel(frame:frame)
        label.font = App_Theme_PinFan_R_12_Font
        label.textColor = UIColor.init(hexString: App_Theme_384249_Color)
        label.text = name
        return label
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !self.didMakeConstraints {
            self.didMakeConstraints = true
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
