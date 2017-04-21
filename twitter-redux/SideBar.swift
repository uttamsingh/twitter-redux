//
//  SideBar.swift
//  
//
//  Created by Singh, Uttam on 4/19/17.
//
//

import UIKit

@objc protocol SideBarDelegate {
    func sideBarDidSelectButtonAtIndex(index:Int)
    @objc optional func sideBarWillClose()
    @objc optional func sideBarWillOpen()
}


class SideBar: NSObject, SideBarTableViewControllerDelegate {

    
    let barWidth:CGFloat = 150.0
    let sideBarTableViewTopInsert:CGFloat = 64.0
    let sideBarContainerView:UIView = UIView()
    let sideBarTableViewController:SideBarTableViewController = SideBarTableViewController ()
    var originView:UIView!
    
    var animator:UIDynamicAnimator!
    var delegate:SideBarDelegate?
    var isSideBarOpen:Bool = false
    
    override init() {
        super.init()
    }

    init(sourceView:UIView, menuItems: Array<String>) {
        super.init()
        originView = sourceView
        sideBarTableViewController.tableData = menuItems
        
        setupSideBar()
        
        animator = UIDynamicAnimator(referenceView: originView)
        
        let showGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SideBar.handleSwipe(_:)))
        originView.addGestureRecognizer(showGestureRecognizer)
        
//        let hideGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SideBar.handleSwipe(_:)))
//        originView.addGestureRecognizer(hideGestureRecognizer)
    }
    
    
    func setupSideBar() {
    
        sideBarContainerView.frame = CGRect(x: -1, y: (originView?.frame.origin.y)!, width: barWidth, height: (originView?.frame.size.height)!)
        sideBarContainerView.backgroundColor = UIColor.clear
        sideBarContainerView.clipsToBounds = false
        
        originView?.addSubview(sideBarContainerView)
        
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
        blurView.frame = sideBarContainerView.bounds
        sideBarContainerView.addSubview(blurView)
        
        sideBarTableViewController.delegate = self
        sideBarTableViewController.tableView.frame = sideBarContainerView.bounds
        sideBarTableViewController.tableView.clipsToBounds = false
        sideBarTableViewController.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        sideBarTableViewController.tableView.backgroundColor = UIColor.clear
        sideBarTableViewController.tableView.scrollsToTop = false
        sideBarTableViewController.tableView.contentInset = UIEdgeInsetsMake(sideBarTableViewTopInsert, 0, 0, 0)

        sideBarTableViewController.tableView.reloadData()
        sideBarContainerView.addSubview(sideBarTableViewController.tableView)
    }
    

    
    func handleSwipe(_ sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .ended:
            if sender.velocity(in: self.originView).x > 0 {
                showSideBar(shouldOpen: false)
                delegate?.sideBarWillClose!()
            } else {
                showSideBar(shouldOpen: true)
                delegate?.sideBarWillOpen!()
            }
        default :
            print("default")
        }
        
        
        
//        if recognizer.direction == UISwipeGestureRecognizerDirection.left {
//            showSideBar(shouldOpen: false)
//            delegate?.sideBarWillClose!()
//        } else {
//            showSideBar(shouldOpen: true)
//            delegate?.sideBarWillOpen!()
//        }
    }
    
    func showSideBar(shouldOpen: Bool) {
        animator.removeAllBehaviors()
        isSideBarOpen = shouldOpen
        
        let gravityX:CGFloat = (shouldOpen) ? 0.5 : -0.5
        let magnitude: CGFloat = (shouldOpen) ? 20 : -20
        let boundaryX:CGFloat = (shouldOpen) ? barWidth : barWidth - 1
        
        let gravityBehaviour: UIGravityBehavior  = UIGravityBehavior(items: [sideBarContainerView])
        gravityBehaviour.gravityDirection = CGVector(dx: gravityX, dy: 0)
        animator.addBehavior(gravityBehaviour)
        
        let collisionBehaviour: UICollisionBehavior = UICollisionBehavior(items: [sideBarContainerView])
        collisionBehaviour.addBoundary(withIdentifier: "sideBarBoundary" as NSCopying, from: CGPoint.init(x: boundaryX, y: 20), to: CGPoint.init(x: boundaryX, y: (originView?.frame.size.height)!))
        animator.addBehavior(collisionBehaviour)
        
        let pushBehaiour: UIPushBehavior = UIPushBehavior(items: [sideBarContainerView], mode: UIPushBehaviorMode.instantaneous)
        pushBehaiour.magnitude = magnitude
        animator.addBehavior(pushBehaiour)
        
        let sideBarBehaviour: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [sideBarContainerView])
        sideBarBehaviour.elasticity = 0.3
        animator.addBehavior(sideBarBehaviour)
    }
    
    func sideBarControlDidSelectRow(indexPath: NSIndexPath) {
        delegate?.sideBarDidSelectButtonAtIndex(index: indexPath.row)
    }
}
