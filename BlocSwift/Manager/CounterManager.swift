//
//  Bloc.swift
//  BlocSwift
//
//  Created by PATRICK LESAINT on 23/04/2020.
//  Copyright © 2020 PATRICK LESAINT. All rights reserved.
//

import Foundation
import RxSwift

enum CounterEvent {
    case IncrementEvent
    case DecrementEvent
    case resetEvent(value: Int)
}

enum CounterError: Error {
    case counterIsNegative
    case counterIsGreaterThanTen
}

class CounterManager {

    private var counter: Int = 0;
    
    let bag = DisposeBag()
    var output = BehaviorSubject<Int>(value: 0)
    var input = PublishSubject<CounterEvent>()
    var error = PublishSubject<CounterError>()

    init() {
        input.subscribe(onNext:{
            self.mapEventToState(event: $0)
        }).disposed(by: bag)
        
    }
    
    private func mapEventToState(event: CounterEvent) {
        
        switch event {
        case .IncrementEvent:
            counter = counter + 1
        case .DecrementEvent:
            counter = counter - 1
        case .resetEvent(let value):
            counter = value
        }
        
        if counter >= 0 && counter <= 10 {
            output.onNext(counter)
        } else if counter < 0 {
            counter = 0
            error.onNext(CounterError.counterIsNegative)
        } else {
            counter = 10
            error.onNext(CounterError.counterIsGreaterThanTen)
        }
    }
    
}
