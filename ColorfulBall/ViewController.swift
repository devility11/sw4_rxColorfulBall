//
//  ViewController.swift
//  ColorfulBall
//
//  Created by Norbert Czirjak on 2017. 10. 24..
//  Copyright © 2017. Norbert Czirjak. All rights reserved.
//
import ChameleonFramework
import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    var circleView: UIView!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        //add circle view
        circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100.0, height: 100.0)))
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        circleView.center = view.center
        circleView.backgroundColor = .green
        view.addSubview(circleView)
        
        var circleViewModel = CircleViewModel()
        // bind the center point of the circleview to the centerObservable
        circleView
        .rx.observe(CGPoint.self, "center")
        .bind(to: circleViewModel.centerVariable)
        .disposed(by: disposeBag)
        
        //subscribe to backgroundObservable to get new colors from the viewmodel
        circleViewModel.backgroundColorObservable
            .subscribe(onNext: { [weak self] backgroundColor in
                UIView.animate(withDuration: 0.1) {
                    self?.circleView.backgroundColor = backgroundColor
                    // try to get complementary color for given background color
                    let viewBackgroundColor = UIColor(complementaryFlatColorOf: backgroundColor)
                    // If it is different that the color
                    if viewBackgroundColor != backgroundColor {
                        // Assign it as a background color of the view
                        // We only want different color to be able to see that circle in a view
                        self?.view.backgroundColor = viewBackgroundColor
                    }
                }
            })
            .disposed(by: disposeBag)
        
        // add gesture recognizer
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circleMoved(_:)))
        circleView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func circleMoved(_ recognizer: UIPanGestureRecognizer){
        let location = recognizer.location(in: view)
        UIView.animate(withDuration: 0.1) {
            self.circleView.center = location
        }
    }


}

