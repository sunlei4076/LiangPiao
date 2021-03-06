//
//  GlobalSearchTableView.swift
//  LiangPiao
//
//  Created by Zhang on 11/11/2016.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
typealias SearchDidSelectClouse = (indexPath:NSIndexPath) ->Void
class GlobalSearchTableView: UIView {

    var tableView:UITableView!
    var searchDidSelectClouse:SearchDidSelectClouse!
    var viewModel = SearchViewModel.shareInstance
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    func setUpView(){
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView.backgroundColor = UIColor.init(hexString: App_Theme_E9EBF2_Color)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .None
        tableView.keyboardDismissMode = .OnDrag
        tableView.registerClass(RecommendTableViewCell.self, forCellReuseIdentifier: "RecommendTableViewCell")
        tableView.registerClass(SellRecommondTableViewCell.self, forCellReuseIdentifier: "SellRecommondTableViewCell")
        self.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension GlobalSearchTableView : UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.searchTableNumberOfSectionsInTableView()
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return viewModel.searchTableTableViewHeightForRowAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if self.searchDidSelectClouse != nil {
//            self.searchDidSelectClouse(indexPath:indexPath)
//        }
        return viewModel.searchTablaTableViewDidSelectRowAtIndexPath(indexPath)
    }
}
extension GlobalSearchTableView : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchTableNumberOfRowsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if viewModel.searchType == .TicketShowModel {
            let cell = tableView.dequeueReusableCellWithIdentifier("RecommendTableViewCell", forIndexPath: indexPath) as! RecommendTableViewCell
            viewModel.searchTableCellData(cell, indexPath: indexPath)
            cell.selectionStyle = .None
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("SellRecommondTableViewCell", forIndexPath: indexPath) as! SellRecommondTableViewCell
            viewModel.searchTableCellDatas(cell, indexPath: indexPath)
            cell.selectionStyle = .None
            return cell
        }
    }
}

extension GlobalSearchTableView : DZNEmptyDataSetDelegate {

}

extension GlobalSearchTableView :DZNEmptyDataSetSource {
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor {
        return UIColor.init(hexString: App_Theme_F6F7FA_Color)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = viewModel.emptyPlachTextTitle()
        let attribute = NSMutableAttributedString(string: str)
        attribute.addAttributes([NSForegroundColorAttributeName:UIColor.init(hexString: App_Theme_DDE0E5_Color)], range: NSRange(location: 0, length: str.length))
        attribute.addAttributes([NSFontAttributeName:App_Theme_PinFan_R_16_Font!], range: NSRange.init(location: 0, length: str.length))
        return attribute
    }
    
    func offsetForEmptyDataSet(scrollView: UIScrollView!) -> CGPoint {
        return CGPointMake(0, 64)
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -130
    }
    
    func spaceHeightForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return 30
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "Icon_Search_Empty")
    }
}

