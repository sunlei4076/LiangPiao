//
//  BuyTicketsViewController.swift
//  LiangPiao
//
//  Created by Zhang on 28/10/2016.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
import ReactiveCocoa
import DZNEmptyDataSet

class SellTicketsViewController: BaseViewController {

    var tableView:UITableView!
    var searchTableView:GlobalSearchTableView!
    var searchViewModel = SearchViewModel.shareInstance
    var viewModel = SellViewModel()
    var searchNavigationBar = HomeSearchNavigationBar(frame: CGRectMake(0,-64,SCREENWIDTH, 64),font:App_Theme_PinFan_L_12_Font)
    var searchBarView:GloableSearchNavigationBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSearchNavigatioBarClouse()
        self.setUpView()
        self.setUpNavigationItem()
        self.talKingDataPageName = "卖票"
        self.bindViewModel()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.fd_prefersNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if searchTableView == nil || searchTableView.hidden {
            self.tabBarController?.tabBar.hidden = false
        }else{
            self.tabBarController?.tabBar.hidden = true
        }
        
    }
    
    func setUpView() {
        searchBarView = GloableSearchNavigationBarView(frame: CGRectMake(0,0,SCREENWIDTH, 64), title:"卖票", searchClouse:{ _ in
            self.searchButtonPress()
        })
        self.view.addSubview(searchBarView)
        
        tableView = UITableView(frame: CGRect.zero, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .OnDrag
        tableView.backgroundColor = UIColor.init(hexString: App_Theme_E9EBF2_Color)
        tableView.registerClass(SellRecommondTableViewCell.self, forCellReuseIdentifier: "SellRecommondTableViewCell")
        tableView.separatorStyle = .None
        self.view.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(64, 0, -44, 0))
        }
        self.setUpRefreshData()
    }
    
    func setUpRefreshData(){
        self.tableView.mj_header = LiangNomalRefreshHeader(refreshingBlock: {
            self.viewModel.requestHotTicket()
        })
    }
    
    func setUpNavigationItem(){
        searchNavigationBar.searchField.placeholder = "搜索想转卖的演出..."
        self.view.addSubview(searchNavigationBar)
    }
    
    func searchButtonPress(){
        UIView.animateWithDuration(AnimationTime, animations: {
            self.searchBarView.frame = CGRect.init(x: 0, y: -64, width: SCREENWIDTH, height: 64)
            self.searchNavigationBar.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 64)
            }, completion: { completion in
                self.searchNavigationBar.searchField.becomeFirstResponder()
        })
    }
    
    func cancelButtonPress(){
        UIView.animateWithDuration(AnimationTime, animations: {
            self.searchBarView.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 64)
            self.searchNavigationBar.frame = CGRect.init(x: 0, y: -64, width: SCREENWIDTH, height: 64)
            }, completion: { completion in
                self.searchNavigationBar.searchField.resignFirstResponder()
        })
    }
    
    func bindViewModel(){
        searchViewModel.controllerS = self
        viewModel.controller = self
        viewModel.requestHotTicket()
        RACSignal.interval(1, onScheduler: RACScheduler.currentScheduler()).subscribeNext { (str) in
            
        }
        let single = searchNavigationBar.searchField
            .rac_textSignal()
            .distinctUntilChanged()
        single.throttle(0.1).subscribeNext { (str) in
            if self.searchTableView != nil {
                self.searchViewModel.requestSearchTicket(str as! String, searchTable: self.searchTableView)
            }
        }
        searchViewModel.searchViewModelClouse = { _ in
            self.view.endEditing(true)
        }
    }
    
    func cancelSearchTable() {
        self.cancelButtonPress()
        self.searchNavigationBar.searchField.frame = CGRectMake(20, 27,SCREENWIDTH - 40, 30)
        self.searchNavigationBar.cancelButton.hidden = true
        searchNavigationBar.searchField.hidden = false
        searchNavigationBar.searchField.resignFirstResponder()
        searchTableView.hidden = true
        self.tabBarController?.tabBar.hidden = false
    }
    
    func setSearchNavigatioBarClouse(){
        searchNavigationBar.searchTextFieldBecomFirstRespoder = { _ in
            self.searchViewModel.searchType = .TicketSell
            if self.searchTableView == nil {
                self.searchTableView = GlobalSearchTableView(frame: CGRectMake(0, CGRectGetMaxY(self.searchNavigationBar.frame), SCREENWIDTH, SCREENHEIGHT - CGRectGetMaxY(self.searchNavigationBar.frame)))
                self.view.addSubview(self.searchTableView)
            }else{
                self.searchTableView.hidden = false
            }
            self.tabBarController?.tabBar.hidden = true
        }
        searchNavigationBar.searchNavigationBarCancelClouse = { _ in
            self.cancelSearchTable()
        }
    }
    
    func searchViewController() {
        searchNavigationBar.backgroundColor = UIColor.init(red: 75.0/255.0, green: 212.0/255.0, blue: 197.0/255.0, alpha: 1)
        searchNavigationBar.hidden = false
        searchNavigationBar.searchField.hidden = false
        searchNavigationBar.searchField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SellTicketsViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return viewModel.tableViewHeightForRowAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        viewModel.tableViewDidSelectRowAtIndexPath(indexPath)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
    }
}

extension SellTicketsViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.numberOfSectionsInTableView()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SellRecommondTableViewCell", forIndexPath: indexPath) as! SellRecommondTableViewCell
        cell.selectionStyle = .None
        viewModel.tableViewtableViewSellRecommondTableViewCell(cell, indexPath: indexPath)
        return cell
    }
}

extension SellTicketsViewController : DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldAllowTouch(scrollView: UIScrollView!) -> Bool {
        return true
    }
    func emptyDataSetDidTapView(scrollView: UIScrollView!) {
        self.viewModel.requestHotTicket()
    }
}

extension SellTicketsViewController :DZNEmptyDataSetSource {
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor {
        return UIColor.init(hexString: App_Theme_F6F7FA_Color)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "点击屏幕，重新加载"
        let attribute = NSMutableAttributedString(string: str)
        attribute.addAttributes([NSForegroundColorAttributeName:UIColor.init(hexString: App_Theme_DDE0E5_Color)], range: NSRange(location: 0, length: str.length))
        attribute.addAttributes([NSFontAttributeName:App_Theme_PinFan_R_16_Font!], range: NSRange.init(location: 0, length: str.length))
        return attribute
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -70
    }
    
    func spaceHeightForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return 27
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "empty_order")?.imageWithRenderingMode(.AlwaysOriginal)
    }
}

