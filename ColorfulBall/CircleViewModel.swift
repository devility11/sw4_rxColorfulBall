//
//  CircleViewModel.swift
//  ColorfulBall
//
//  Created by Norbert Czirjak on 2017. 10. 24..
//  Copyright © 2017. Norbert Czirjak. All rights reserved.
//
import ChameleonFramework
import Foundation
import RxSwift
import RxCocoa

class CircleViewModel {
    
    var centerVariable = Variable<CGPoint?>(.zero) // Create one variable that will be changed and observed
    var backgroundColorObservable: Observable<UIColor>! //create observable that will change backgroundColor based on center
    
    init() {
        setup()
    }
    
    func setup() {
        //when we get new center, emit new UIColor
        backgroundColorObservable = centerVariable.asObservable()
            .map { center in
                guard let center = center else { return UIColor.flatten(.black)()}
                
                let red: CGFloat = ((center.x + center.y) .truncatingRemainder(dividingBy: 255.0)) / 255.0
                let green: CGFloat = 0.0
                let blue: CGFloat = 0.0
                
                return UIColor.flatten(UIColor(red: red, green: green, blue:blue, alpha: 1.0))()
        }
    }
}
