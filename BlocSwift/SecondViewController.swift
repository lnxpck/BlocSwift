//
//  SecondViewController.swift
//  BlocSwift
//
//  Created by PATRICK LESAINT on 23/04/2020.
//  Copyright © 2020 PATRICK LESAINT. All rights reserved.
//

import UIKit
import RxSwift

/* Declare as global */
let counterManager = CounterManager()

class SecondViewController: UIViewController {

    let bag = DisposeBag()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        counterManager.output.subscribe(onNext: { counter in
            self.label.text = "\(counter)"
        }).disposed(by: bag)
        
        counterManager.error.subscribe(onNext: { error in
            self.alertError(error: error)
        }).disposed(by: bag)
    }
    
    private func alertError(error: CounterError) {
        var message = ""
        
        switch error {
        case .counterIsNegative:
            message = "Tsss.... Counter must be positive..."
            break
        case .counterIsGreaterThanTen:
            message = "Tssss... Counter must be smaller than 10..."
            break
        }
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok man", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .purple
        view.addSubview(label)
        
        label.font = UIFont.systemFont(ofSize: 48)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        let incBtn = UIButton()
        view.addSubview(incBtn)
        
        incBtn.setTitle("Incrementer", for: .normal)
        incBtn.setTitleColor(.purple, for: .normal)
        incBtn.backgroundColor = .white
        incBtn.translatesAutoresizingMaskIntoConstraints = false
        incBtn.widthAnchor.constraint(equalToConstant: 110).isActive = true
        incBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        incBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        incBtn.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 100).isActive = true
        incBtn.addTarget(self, action: #selector(onIncrementer), for: .touchUpInside)
        
        let resetBtn = UIButton()
        view.addSubview(resetBtn)
        
        resetBtn.setTitle("reset to 5", for: .normal)
        resetBtn.setTitleColor(.purple, for: .normal)
        resetBtn.backgroundColor = .white
        resetBtn.translatesAutoresizingMaskIntoConstraints = false
        resetBtn.widthAnchor.constraint(equalToConstant: 110).isActive = true
        resetBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        resetBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetBtn.topAnchor.constraint(equalTo: incBtn.bottomAnchor, constant: 40).isActive = true
        resetBtn.addTarget(self, action: #selector(onReset), for: .touchUpInside)
        
        let closeBtn = UIButton()
        view.addSubview(closeBtn)

        closeBtn.setTitle("Close", for: .normal)
        closeBtn.setTitleColor(.purple, for: .normal)
        closeBtn.backgroundColor = .white
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.widthAnchor.constraint(equalToConstant: 110).isActive = true
        closeBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        closeBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        closeBtn.topAnchor.constraint(equalTo: resetBtn.bottomAnchor, constant: 40).isActive = true
        closeBtn.addTarget(self, action: #selector(onClose), for: .touchUpInside)
    }

    @objc func onIncrementer() {
        counterManager.input.onNext(.IncrementEvent)
    }

    @objc func onReset() {
        counterManager.input.onNext(.resetEvent(value: 5))
    }
    
    @objc func onClose() {
        self.dismiss(animated: true, completion: nil)
    }
}
