//
//  MySellViewModel.swift
//  LiangPiao
//
//  Created by Zhang on 05/12/2016.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit

class PriceModel: NSObject {
    var minPrice:Int = 0
    var maxPrice:Int = 0
}

class MySellViewModel: NSObject {

    var pageViewControllers:NSMutableArray!
    let pageTitle = ["订单交易","票品管理"]
    var controller:MySellPagerViewController!
    var soldCount:Int = 0
    var orderListModel:OrderListModel!
    var ticketShowModel = NSMutableArray()
    let mySellOrder = MySellOrderViewController()
    let mySellManager = MySellManagerViewController()
    override init() {
        super.init()
        mySellOrder.viewModel = self
        mySellManager.viewModel = self
        pageViewControllers = NSMutableArray.init(array: [mySellOrder,mySellManager])

    }
    
    // MARK :TaPageViewController
    func numberOfControllersInPagerController() -> Int{
        return self.pageTitle.count
    }
    
    func pagerControllerTitleForIndex(index:Int) -> String{
        return pageTitle[index] 
    }
    
    func pagerControllerControllerForIndex(index:Int) -> UIViewController {
        return pageViewControllers[index] as! UIViewController 
    }
    
    //MARK: MySellViewController
    func mySellOrderTableViewDidSelect(indexPath:NSIndexPath, controller:MySellPagerViewController){
        let controllerVC = OrderStatusViewController()
        controllerVC.viewModel.selectIndexPath = indexPath
        controllerVC.viewModel.model = self.orderListModel.orderList[indexPath.section]
        controllerVC.viewModel.reloadeMySellOrderList = { selectIndexPath, model in
            self.orderListModel.orderList[indexPath.section] = model
            self.mySellOrder.tableView.reloadSections(NSIndexSet.init(index: selectIndexPath.section), withRowAnimation: .Automatic)
        }
        NavigationPushView(self.controller, toConroller: controllerVC)
    }
    
    func mySellOrderNumberOfSection() -> Int{
        if orderListModel != nil {
            return orderListModel.orderList.count
        }
        return 0
    }
    
    func mySellOrderNumbrOfRowInSection(section:Int) ->Int{
        return 3
    }
    
    func mySellTableViewHeightForRow(indexPath:NSIndexPath) ->CGFloat {
        switch indexPath.row {
        case 0:
            return 49
        case 1:
            return 149
        default:
            return 59
        }
    }
    
    func tableViewCellOrderNumberTableViewCell(cell:OrderNumberTableViewCell, indexPath:NSIndexPath) {
        cell.setSellData(orderListModel.orderList[indexPath.section])
    }
    
    func tableViewCellOrderTicketInfoTableViewCell(cell:OrderTicketInfoTableViewCell, indexPath:NSIndexPath) {
        cell.setSellData(orderListModel.orderList[indexPath.section])
    }
    
    func tableViewCellMySellOrderMuchTableViewCell(cell:MySellOrderMuchTableViewCell, indexPath:NSIndexPath) {
        cell.setSellData(orderListModel.orderList[indexPath.section])
        cell.handerButton.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (action) in
            let model = self.orderListModel.orderList[indexPath.section]
            let url = "\(OrderChangeShatus)\(model.orderId)/"
            let parameters = ["status":"7"]
            BaseNetWorke.sharedInstance.postUrlWithString(url, parameters: parameters).subscribeNext { (resultDic) in
                let tempModel = OrderList.init(fromDictionary: resultDic as! NSDictionary)
                let controllerVC = OrderStatusViewController()
                model.status = tempModel.status
                model.statusDesc = tempModel.statusDesc
                controllerVC.viewModel.model = model
                NavigationPushView(self.controller, toConroller: controllerVC)
            }
        }
    }
    
    func requesrSellOrder(isNext:Bool){
        if !UserInfoModel.isLoggedIn() {
            MainThreadAlertShow("请登录后查看", view: KWINDOWDS())
            return;
        }
        var url = ""
        if isNext {
            if orderListModel.hasNext == false {
                self.mySellOrder.tableView.mj_footer.endRefreshing()
                return
            }
            url = "\(SupplierOrderList)?page=\(orderListModel.nextPage)"
        }else{
            url = SupplierOrderList
        }
        BaseNetWorke.sharedInstance.getUrlWithString(url, parameters: nil).subscribeNext { (resultDic) in
            if self.mySellOrder.tableView == nil{
                self.mySellOrder.setUpView()
            }
            
            if isNext {
                let tempModel =  OrderListModel.init(fromDictionary: resultDic as! NSDictionary)
                self.orderListModel.hasNext = tempModel.hasNext
                self.orderListModel.nextPage = tempModel.nextPage
                self.orderListModel.orderList.appendContentsOf(tempModel.orderList)
                self.mySellOrder.tableView.mj_footer.endRefreshing()
            }else{
                self.orderListModel =  OrderListModel.init(fromDictionary: resultDic as! NSDictionary)
                if self.orderListModel.hasNext != nil && self.orderListModel.hasNext == true {
                    if self.mySellOrder.tableView.mj_footer == nil {
                        self.mySellOrder.setUpLoadMoreData()
                    }
                }
                if self.mySellOrder.tableView.mj_header != nil {
                    self.mySellOrder.tableView.mj_header.endRefreshing()
                }
            }
            self.mySellOrder.tableView.reloadData()
        }
    }

    
    //MARK: MySellOrderMangerViewController
    func mySellOrderManagerTableViewDidSelect(indexPath:NSIndexPath, controller:MySellPagerViewController){
        let model = TicketShowModel.init(fromDictionary: ticketShowModel[indexPath.section] as! NSDictionary)
        let controllerVC = MyTicketPutUpViewController()
        controllerVC.viewModel.ticketShowModel = model
        controllerVC.viewModel.ticketSellCount = MySellViewModel.TicketShowModelSellCount(model)
        controllerVC.viewModel.ticketSoldCount = MySellViewModel.TicketShowModelSoldCount(model)
        let priceModel = MySellViewModel.sellManagerMinMaxPrice(model)
        var ticketMuch = ""
        if priceModel.minPrice != priceModel.maxPrice {
            ticketMuch = "\(priceModel.minPrice)-\(priceModel.maxPrice)"
        }else{
            ticketMuch = "\(priceModel.minPrice)"
        }
        controllerVC.viewModel.myTicketPutUpViewModelClouse = { ticketShow in
            self.ticketShowModel.replaceObjectAtIndex(indexPath.section, withObject: ticketShow.toDictionary())
        }
        controllerVC.viewModel.ticketSoldMuch = ticketMuch
        controllerVC.viewModel.ticketSession = MySellViewModel.TicketShowModelSession(model)
        controllerVC.viewModel.isSellTicketVC = false
        NavigationPushView(self.controller, toConroller: controllerVC)
    }
    
    func mySellOrderManagerNumberOfSection() -> Int{
        return ticketShowModel.count
    }
    
    func mySellOrderManagerNumbrOfRowInSection(section:Int) ->Int{
        return 2
    }
    
    func mySellOrderManagerTableViewHeightForRow(indexPath:NSIndexPath) ->CGFloat {
        switch indexPath.row {
        case 0:
            return 160
        case 1:
            return 59
        default:
            return 49
        }
    }
    
    func tableViewCellOrderManagerTableViewCell(cell:OrderManagerTableViewCell, indexPath:NSIndexPath) {
        let model = TicketShowModel.init(fromDictionary: ticketShowModel[indexPath.section] as! NSDictionary)
        cell.setData(MySellViewModel.TicketShowModelTitle(model), cover: MySellViewModel.TicketShowModelCover(model), session: MySellViewModel.TicketShowModelSession(model), much: MySellViewModel.TicketShowModelTicketName(model), remainCount: MySellViewModel.TicketShowModelSellCount(model), soldCount: MySellViewModel.TicketShowModelSoldCount(model), isMoreTicket: self.TicketShowModelIsMoreTicket(model))
    }
    
    func tableViewCellMySellManagerMuchTableViewCell(cell:MySellManagerMuchTableViewCell, indexPath:NSIndexPath) {
        if ticketShowModel.count != 0 {
            let model = TicketShowModel.init(fromDictionary: ticketShowModel[indexPath.section] as! NSDictionary)
            let priceModel = MySellViewModel.sellManagerMinMaxPrice(model)
            if priceModel.minPrice != priceModel.maxPrice {
                cell.setMuchLabelText("\(priceModel.minPrice)-\(priceModel.maxPrice)")
            }else{
                cell.setMuchLabelText("\(priceModel.minPrice)")
            }
        }
    }
    
    func tableViewCellMySellAttentionTableViewCell(cell:MySellAttentionTableViewCell, indexPath:NSIndexPath) {
//        let model = TicketShowModel.init(fromDictionary: ticketShowModel[indexPath.section] as! NSDictionary)
    }
    
    func requestOrderManager(){
        if !UserInfoModel.isLoggedIn() {
            MainThreadAlertShow("请登录后查看", view: KWINDOWDS())
            return;
        }
        self.ticketShowModel.removeAllObjects()
        BaseNetWorke.sharedInstance.getUrlWithString(SupplierTicketList, parameters: nil).subscribeNext { (resultDic) in
            if self.mySellManager.tableView == nil {
                self.mySellManager.setUpView()
            }
            self.ticketShowModel = NSMutableArray.mj_objectArrayWithKeyValuesArray(resultDic)
//            self.genderTicketShowModel(NSMutableArray.mj_objectArrayWithKeyValuesArray(resultDic))
            if self.mySellManager.tableView.mj_header != nil {
                self.mySellManager.tableView.mj_header.endRefreshing()
            }
            self.mySellManager.tableView.reloadData()
        }
    }
    
//    func genderTicketShowModel(ticketShows:NSMutableArray){
//        for model in ticketShows {
//            let model = TicketShowModel.init(fromDictionary: model as! NSDictionary)
//            for session in model.sessionList {
//                var ticketList:[TicketList] = []
//                for ticket in session.ticketList {
//                    soldCount = soldCount + ticket.soldCount
//                    if ticket.remainCount != 0 {
//                        ticketList.append(ticket)
//                    }
//                }
//                session.ticketList = ticketList
//            }
//            model.soldCount = 
//            self.ticketShowModel.addObject(model)
//        }
//    }
    
    class func TicketShowModelCover(model:TicketShowModel) -> String{
        return model.cover
    }
    
    class func TicketShowModelTitle(model:TicketShowModel) -> String{
        return model.title
    }
    
    class func TicketShowModelSession(model:TicketShowModel) -> String{
        var sessionStr = ""
        if model.sessionList.count != 1 {
            for session in model.sessionList {
                sessionStr = sessionStr.stringByAppendingString(session.name)
            }
            return sessionStr
        }else{
            sessionStr = "、\(model.sessionList[0].name)"
            return (sessionStr as NSString).substringFromIndex(1)
        }
    }
    
    class func TicketShowModelTicketName(model:TicketShowModel) -> String {
        var ticketName = ""
        if model.sessionCount != 1 {
            for session in model.sessionList {
                if session.ticketCount != 1 {
                    for ticke in session.ticketList {
                        ticketName = ticketName.stringByAppendingString("、\(ticke.originalTicket.name)")
                    }
                }else{
                    ticketName = ticketName.stringByAppendingString("、\(session.ticketList[0].originalTicket.name)")
                }
            }
        }else{
            if model.sessionList[0].ticketCount != 1 {
                for ticke in model.sessionList[0].ticketList {
                    ticketName = ticketName.stringByAppendingString("、\(ticke.originalTicket.name)")
                }
            }else{
                ticketName = ticketName.stringByAppendingString("、\(model.sessionList[0].ticketList[0].originalTicket.name)")
            }
        }
        if ticketName.length > 1 {
            ticketName = (ticketName as NSString).substringFromIndex(1)
        }
        return ticketName
    }
    
    class func TicketShowModelSellCount(model:TicketShowModel) -> String {
        var ticketCount:Int = 0
        if model.sessionList.count != 1 {
            for session in model.sessionList {
                for ticket in session.ticketList {
                    if ticket.status == 1 {
                        ticketCount = ticketCount + ticket.remainCount
                    }
                }
            }
        }else{
            for ticket in model.sessionList[0].ticketList {
                if ticket.status == 1 {
                    ticketCount = ticketCount + ticket.remainCount
                }
            }
        }
        return "\(ticketCount)"
    }
    
    func TicketShowModelIsMoreTicket(model:TicketShowModel) -> Bool {
        var ret = false
        if model.sessionList.count != 1 {
            ret = true
        }else{
            if model.sessionList[0].ticketList.count != 1 {
                ret = true
            }
        }
        return ret
    }
    
    class func TicketShowModelSoldCount(model:TicketShowModel) -> String {
        var ticketSoldCount:Int = 0
        if model.sessionList.count != 1 {
            for session in model.sessionList {
                if session.ticketCount != 1 {
                    for ticke in session.ticketList {
                        ticketSoldCount = ticketSoldCount + ticke.soldCount
                    }
                }else{
                    ticketSoldCount = ticketSoldCount + session.ticketList[0].soldCount
                }
            }
        }else{
            if model.sessionList[0].ticketCount != 1 {
                for ticke in model.sessionList[0].ticketList {
                    ticketSoldCount = ticketSoldCount + ticke.soldCount
                }
            }else{
                ticketSoldCount = ticketSoldCount + model.sessionList[0].ticketList[0].soldCount
            }
        }
        return "\(ticketSoldCount)"
    }
    
    func TicketShowModelTicketRow(model:TicketShowModel) -> String {
        var ticketRow = ""
        if model.sessionList.count == 1 && model.sessionList[0].ticketList.count == 1 {
            ticketRow = model.sessionList[0].ticketList[0].originalTicket.name
        }
        return ticketRow
    }
    
    class func sellManagerMinMaxPrice(model:TicketShowModel) -> PriceModel {
        let priceModel = PriceModel()
        if model.sessionList.count != 1 {
            priceModel.minPrice = model.sessionList[0].minPrice
            priceModel.maxPrice = model.sessionList[0].minPrice
            for session in model.sessionList {
                if session.ticketList.count != 1 {
                    for ticket in session.ticketList {
                        if ticket.price < priceModel.minPrice {
                            priceModel.minPrice = ticket.price
                        }
                        if ticket.price > priceModel.maxPrice {
                            priceModel.maxPrice = ticket.price
                        }
                    }
                }else{
                    if session.minPrice < priceModel.minPrice {
                        priceModel.minPrice = session.minPrice
                    }
                    if session.minPrice > priceModel.maxPrice {
                        priceModel.maxPrice = session.minPrice
                    }
                }
            }
        }else{
            priceModel.minPrice = model.minPrice
            priceModel.maxPrice = model.minPrice
            if model.sessionList[0].ticketList.count != 1 {
                for ticket in model.sessionList[0].ticketList {
                    if ticket.price < priceModel.minPrice {
                        priceModel.minPrice = ticket.price
                    }
                    if ticket.price > priceModel.maxPrice {
                        priceModel.maxPrice = ticket.price
                    }
                }
            }else{
                priceModel.minPrice = model.sessionList[0].ticketList[0].price
                priceModel.maxPrice = model.sessionList[0].ticketList[0].price
            }
        }
        return priceModel
    }
}
