//
//  TicketToolsTableViewCell.swift
//  LiangPiao
//
//  Created by Zhang on 02/11/2016.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
import ReactiveCocoa

typealias ToolViewSelectIndexPathRow = (indexPath:NSIndexPath, str:AnyObject) -> Void

class ToolView:UIView {
    
    var tableView:UITableView!
    var dataArray:NSArray!
    var toolViewSelectIndexPathRow:ToolViewSelectIndexPathRow!
    var singnalTap:UITapGestureRecognizer!
    
    init(frame: CGRect,data:NSArray) {
        super.init(frame: frame)
        let image = UIImage.init(color: UIColor.init(hexString: App_Theme_384249_Color, andAlpha: 0.6), size: frame.size)

        let imageView = UIImageView(image: image)
        imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        self.addSubview(imageView)
        self.backgroundColor = UIColor.init(red: 56.0/255.0, green: 66.0/255.0, blue: 73.0/255.0, alpha: 0.9)
        
        dataArray = NSArray(array: data as [AnyObject], copyItems: true)
        
//        singnalTap = UITapGestureRecognizer(target: self, action: #selector(ToolView.viewSignalTap(_:)))
//        singnalTap.numberOfTapsRequired = 1
//        singnalTap.numberOfTouchesRequired = 1
//        self.addGestureRecognizer(singnalTap)
        
//        let effectView = UIVisualEffectView(effect: UIBlurEffect.init(style: .Light))
//        effectView.frame = self.frame
//        effectView.contentView.addSubview(imageView)
//        self.addSubview(effectView)
        
        
        self.setUpTableView()
        
    }
    
    func viewSignalTap(sender:UITapGestureRecognizer) {
        if toolViewSelectIndexPathRow != nil {
//            self.toolViewSelectIndexPathRow(indexPath:NSIndexPath(forRow: 0, inSection: 0), str: "")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTableView(){
        tableView = UITableView(frame: CGRectMake(0,0,SCREENWIDTH, CGFloat(6 * 50)), style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .None
        self.addSubview(tableView)
    }
}

extension ToolView : UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if toolViewSelectIndexPathRow != nil {
            if indexPath.row == 0 {
                self.toolViewSelectIndexPathRow(indexPath: indexPath, str: "")
            }else{
                self.toolViewSelectIndexPathRow(indexPath: indexPath, str: dataArray[indexPath.row - 1])
            }
        }
    }
}

extension ToolView : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdenf = "ToolView"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdenf)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdenf)
        }
        let detailLabel = UILabel()
        if indexPath.row == 0 {
            detailLabel.text = "全部"
            detailLabel.textColor = UIColor.init(hexString: App_Theme_4BD4C5_Color)
        }else{
            detailLabel.textColor = UIColor.init(hexString: App_Theme_384249_Color)
            detailLabel.text = "\(dataArray[indexPath.row - 1])"
        }
        detailLabel.font = App_Theme_PinFan_R_12_Font
        cell?.contentView.addSubview(detailLabel)
        detailLabel.snp_makeConstraints(closure: { (make) in
            make.centerY.equalTo((cell?.contentView.snp_centerY)!).offset(0)
            make.left.equalTo((cell?.contentView.snp_left)!).offset(25)
        })
        cell?.selectionStyle = .None
        cell?.updateConstraintsIfNeeded()
        let lineLabel = GloabLineView(frame: CGRectMake(15,49.5,SCREENWIDTH - 30, 0.5))
        cell?.contentView.addSubview(lineLabel)
        return cell!
    }
}

enum TicketToolsViewType {
    case left
    case center
    case right
}
enum TicketSortType {
    case downType
    case upType
    case noneType
}

typealias TicketToolsClouse = (tag:NSInteger) -> Void
typealias TicketToolsSortClouse = (tag:NSInteger, type:TicketSortType) -> Void
class TicketToolsView: UIView {
    var toolsLabel:UILabel!
    var imageView:UIImageView!
    dynamic var isShow:Bool = false
    var ticketToolsClouse:TicketToolsClouse!
    var ticketToolsSortClouse:TicketToolsSortClouse!
    
    var racDisposable: RACDisposable!
    var ticketSortType:TicketSortType = .noneType
    
    private var myContext = 0

    init(frame:CGRect, title:String, image:UIImage?, type:TicketToolsViewType) {
        super.init(frame: frame)
        self.setUpView(frame, title:title, image:image, type:type)
        if type == .right {
            let single = UITapGestureRecognizer(target: self, action: #selector(TicketToolsView.pricePress(_:)))
            single.numberOfTapsRequired = 1
            single.numberOfTouchesRequired = 1
            self.addGestureRecognizer(single)
        }else if  type == .left {
            let single = UITapGestureRecognizer(target: self, action: #selector(TicketToolsView.singlePress(_:)))
            single.numberOfTapsRequired = 1
            single.numberOfTouchesRequired = 1
            self.addGestureRecognizer(single)
            racDisposable = rac_observeKeyPath("isShow", options: .New, observer: self) { (object, objects, newValue, oldValue) in
                self.startAnimation()
            }
        }else{
            let single = UITapGestureRecognizer(target: self, action: #selector(TicketToolsView.singlePress(_:)))
            single.numberOfTapsRequired = 1
            single.numberOfTouchesRequired = 1
            self.addGestureRecognizer(single)
            racDisposable = rac_observeKeyPath("isShow", options: .New, observer: self) { (object, objects, newValue, oldValue) in
            }
        }

    }
    deinit {
        racDisposable = nil
    }
    
    func singlePress(sender:UITapGestureRecognizer) {
        if (ticketToolsClouse != nil) {
            self.ticketToolsClouse(tag: (sender.view?.tag)!)
        }
    }
    
    func pricePress(sender:UITapGestureRecognizer) {
        if (ticketToolsSortClouse != nil) {
            if self.ticketSortType == .noneType || self.ticketSortType == .upType {
                self.imageView.image = UIImage.init(named: "Icon_Ranking_03")
                self.ticketSortType = .downType
            }else{
                self.imageView.image = UIImage.init(named: "Icon_Ranking_02")
                self.ticketSortType = .upType
            }
            self.ticketToolsSortClouse(tag: (sender.view?.tag)!, type: self.ticketSortType)
        }
    }
    
    
    func setUpView(frame:CGRect, title:String, image:UIImage?, type:TicketToolsViewType) {
        toolsLabel = UILabel()
        toolsLabel.text = title
        toolsLabel.userInteractionEnabled = true
        toolsLabel.textColor = UIColor.init(hexString: App_Theme_8A96A2_Color)
        toolsLabel.font = App_Theme_PinFan_R_12_Font
        self.addSubview(toolsLabel)
        
        if image != nil {
            imageView = UIImageView()
            imageView.image = image
            imageView.userInteractionEnabled = true
            self.addSubview(imageView)
        }
    
        switch type {
        case .left:
            self.tag = 1
            toolsLabel.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(self.snp_centerY).offset(0)
                make.left.equalTo(self.snp_left).offset(10)
            })
            imageView.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(self.snp_centerY).offset(1)
                make.left.equalTo(self.toolsLabel.snp_right).offset(12)
            })
        case .center:
            self.tag = 2
            self.layer.borderColor = UIColor.init(hexString: App_Theme_E9EBF2_Color).CGColor
            self.layer.borderWidth = 0.5
            toolsLabel.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(self.snp_centerY).offset(0)
                make.centerX.equalTo(self.snp_centerX).offset(0)
            })
        default:
            self.tag = 3
            imageView.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(self.snp_centerY).offset(0)
                make.right.equalTo(self.snp_right).offset(0)
            })
            toolsLabel.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(self.snp_centerY).offset(0)
                make.right.equalTo(self.imageView.snp_left).offset(-12)
            })
        }
    }
    
    func startAnimation() {
        //创建旋转动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        //旋转角度
        anim.toValue = 1 * M_PI
        //旋转指定角度需要的时间
        anim.duration = 1
        //旋转重复次数
        anim.repeatCount = MAXFLOAT
        //动画执行完后不移除
        anim.removedOnCompletion = true
        //将动画添加到视图的laye上
        imageView.layer.addAnimation(anim, forKey: nil)
        //取消动画
        imageView.layer.removeAllAnimations()
        //这个是旋转方向的动画
        UIView.animateWithDuration(AnimationTime) { () -> Void in
            //指定旋转角度是180°
            self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, CGFloat(M_PI))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let TicketToolsViewWidth = (SCREENWIDTH - 30)/3
typealias TicketCellClouse = (tag:NSInteger) ->Void
typealias TicketCellSortClouse = (tag:NSInteger, type:TicketSortType) ->Void

class TicketToolsTableViewCell: UITableViewCell {

    var nomalPriceTick:TicketToolsView!
    var rowTicket:TicketToolsView!
    var sortPriceTick:TicketToolsView!
    var didMakeContraints:Bool = false
    var toolsView: UIView!
    
    var lineLabel:GloabLineView!

    var toplineLabel:GloabLineView!
    
    var ticketCellClouse:TicketCellClouse!
    var ticketCellSortClouse:TicketCellSortClouse!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpView()
    }
    
    func setUpView() {
        toolsView = UIView(frame: CGRectMake(0,0,SCREENWIDTH,42))
        self.contentView.addSubview(toolsView)
        
        nomalPriceTick = TicketToolsView(frame: CGRectMake(15, 0, TicketToolsViewWidth, 42), title: "票面原价", image: UIImage.init(named: "Icon_Selected_Form_Normal")!, type: .left)
        nomalPriceTick.ticketToolsClouse = { tag in
            if self.nomalPriceTick.isShow {
                self.nomalPriceTick.isShow = false
            }else{
                self.nomalPriceTick.isShow = true
            }
            if self.rowTicket.isShow {
                self.rowTicket.isShow = false
            }
            if self.sortPriceTick.isShow {
                self.sortPriceTick.isShow = false
            }
            if self.ticketCellClouse != nil {
                self.ticketCellClouse(tag: tag)
            }
        }
        toolsView.addSubview(nomalPriceTick)
        
        rowTicket = TicketToolsView(frame: CGRectMake(TicketToolsViewWidth + 15, 0, TicketToolsViewWidth, 42), title: "座位", image: nil, type: .center)
        rowTicket.ticketToolsClouse = { tag in
            if self.rowTicket.isShow {
                self.rowTicket.isShow = false
            }else{
                self.rowTicket.isShow = true
            }
            if self.nomalPriceTick.isShow {
                self.nomalPriceTick.isShow = false
            }
            if self.sortPriceTick.isShow {
                self.sortPriceTick.isShow = false
            }
        
            if self.ticketCellClouse != nil {
                self.ticketCellClouse(tag: tag)
            }
        }
        toolsView.addSubview(rowTicket)
        
        sortPriceTick = TicketToolsView(frame: CGRectMake(TicketToolsViewWidth * 2 + 15, 0, TicketToolsViewWidth, 42), title: "售价", image: UIImage.init(named: "Icon_Ranking")!, type: .right)
        sortPriceTick.ticketToolsSortClouse = { tag, type in
            if self.sortPriceTick.isShow {
                self.sortPriceTick.isShow = false
            }else{
                self.sortPriceTick.isShow = true
            }
            if self.rowTicket.isShow {
                self.rowTicket.isShow = false
            }
            if self.sortPriceTick.isShow {
                self.sortPriceTick.isShow = false
            }
            if self.ticketCellSortClouse != nil {
                self.ticketCellSortClouse(tag: tag, type: type)
            }
        }
        toolsView.addSubview(sortPriceTick)
        
        lineLabel = GloabLineView(frame: CGRectMake(15, 41.5, SCREENWIDTH - 30, 0.5))
        toolsView.addSubview(lineLabel)
        
        let signal = NSNotificationCenter.defaultCenter().rac_addObserverForName(ToolViewNotifacationName, object: nil)
        signal.subscribeNext { (object) in
            let str = object.object as! String
            switch str {
                case "100":
                    self.nomalPriceTick.isShow = false
                case "200":
                    self.rowTicket.isShow = false
                default :
                    self.sortPriceTick.isShow = false
            }
        }
        
        self.updateConstraintsIfNeeded()
        
        toplineLabel = GloabLineView(frame: CGRectMake(15, 0, SCREENWIDTH - 30, 0.5))
        self.contentView.addSubview(toplineLabel)
    }
    
    func setUpDescriptionView() -> UIView {
        
        let toolsView = UIView(frame: CGRectMake(0,0,SCREENWIDTH,42))
        let nomalPriceTick = TicketToolsView(frame: CGRectMake(15, 0, TicketToolsViewWidth, 41), title: "票面价格", image: UIImage.init(named: "Icon_Selected_Form_Normal")!, type: .left)
        let rowTicket = TicketToolsView(frame: CGRectMake(TicketToolsViewWidth + 15, 1, TicketToolsViewWidth, 41), title: "座位", image: UIImage.init(named: "Icon_Selected_Form_Normal")!, type: .center)
        let sortPriceTick = TicketToolsView(frame: CGRectMake(TicketToolsViewWidth * 2 + 15, 0, TicketToolsViewWidth, 41), title: "价格", image: UIImage.init(named: "Icon_Ranking")!, type: .right)
        nomalPriceTick.ticketToolsClouse = { tag in
            if nomalPriceTick.isShow {
                nomalPriceTick.isShow = false
            }else{
                nomalPriceTick.isShow = true
            }
            if rowTicket.isShow {
                rowTicket.isShow = false
            }
            if sortPriceTick.isShow {
                sortPriceTick.isShow = false
            }
            if self.ticketCellClouse != nil {
                self.ticketCellClouse(tag: tag)
            }
        }
        toolsView.addSubview(nomalPriceTick)
        
        
        rowTicket.ticketToolsClouse = { tag in
            if rowTicket.isShow {
                rowTicket.isShow = false
            }else{
                rowTicket.isShow = true
            }
            if nomalPriceTick.isShow {
                nomalPriceTick.isShow = false
            }
            if sortPriceTick.isShow {
                sortPriceTick.isShow = false
            }
            
            if self.ticketCellClouse != nil {
                self.ticketCellClouse(tag: tag)
            }
        }
        toolsView.addSubview(rowTicket)
        
        
        sortPriceTick.ticketToolsSortClouse = { tag, type in
            if sortPriceTick.isShow {
                sortPriceTick.isShow = false
            }else{
                sortPriceTick.isShow = true
            }
            if rowTicket.isShow {
                rowTicket.isShow = false
            }
            if sortPriceTick.isShow {
                sortPriceTick.isShow = false
            }
            if self.ticketCellSortClouse != nil {
                self.ticketCellSortClouse(tag: tag, type: type)
            }
        }
        toolsView.addSubview(sortPriceTick)
        
        
        let lineLabel = GloabLineView(frame: CGRectMake(15, 41.5, SCREENWIDTH - 30, 0.5))
        toolsView.addSubview(lineLabel)
        
        let signal = NSNotificationCenter.defaultCenter().rac_addObserverForName(ToolViewNotifacationName, object: nil)
        signal.subscribeNext { (object) in
            let str = object.object as! String
            switch str {
            case "100":
                self.nomalPriceTick.isShow = false
            case "200":
                self.rowTicket.isShow = false
            default :
                self.sortPriceTick.isShow = false
            }
        }
        
        let toplineLabel = GloabLineView(frame: CGRectMake(15, 0, SCREENWIDTH - 30, 0.5))
        self.contentView.addSubview(toplineLabel)
        
        return toolsView
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ToolViewNotifacationName, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !self.didMakeContraints {
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
