//
//  ViewController.swift
//  DateFormatterTest
//
//  Created by Jaron Lowe on 3/30/21.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

let appCalendar: Calendar = {
    var cal = Calendar(identifier: .gregorian);
    cal.locale = Locale.autoupdatingCurrent;
    cal.firstWeekday = 1;
    return cal;
}();

class ViewController: UIViewController {

    // =================================================================================
    // MARK: - Properties
    // =================================================================================
    
    // IBOutlets
    @IBOutlet weak var loadingLabel: UILabel!;
    @IBOutlet weak var testALabel: UILabel!
    @IBOutlet weak var testBLabel: UILabel!
    @IBOutlet weak var testCLabel: UILabel!
    @IBOutlet weak var testDLabel: UILabel!
    @IBOutlet weak var runABButton: UIButton!
    @IBOutlet weak var runAllButton: UIButton!
    @IBOutlet weak var runCDButton: UIButton!
    @IBOutlet weak var indicatorA: UIActivityIndicatorView!;
    @IBOutlet weak var indicatorB: UIActivityIndicatorView!;
    @IBOutlet weak var indicatorC: UIActivityIndicatorView!;
    @IBOutlet weak var indicatorD: UIActivityIndicatorView!;
    
    
    // Variables
    let testsQueue = DispatchQueue(label: "tests-queue");
    let dispatchGroup = DispatchGroup();
    var isCalculating = BehaviorRelay(value: false);
    let dateStrings: [String] = [Int](0...10000)
        .map({ x in
            let dateComponents = appCalendar.dateComponents([.year], from: Date());
            guard let year = dateComponents.year else { return nil; }
            
            let date = appCalendar.date(from: DateComponents(
                year: year,
                month: Int.random(in: 1...12),
                day: Int.random(in: 1...28),
                hour: Int.random(in: 6...20),
                minute: Int.random(in: 0...59),
                second: Int.random(in: 0...59),
                nanosecond: Int.random(in: 0...700)
            )) ?? Date();
            return DateFormatter.shared.string(from: date);
        })
        .compactMap({ $0 });
    
    let disposeBag = DisposeBag();
     
    
    // =================================================================================
    // MARK: - Lifecycle
    // =================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view.;
        

        self.setupObservers();
    }
    
    func setupObservers() {
        self.isCalculating
            .subscribe(onNext: {[weak self] isCalculating in
                self?.loadingLabel.text = (isCalculating) ? "Is Loading..." : "Not Loading";
                self?.runABButton.isEnabled = !isCalculating;
                self?.runAllButton.isEnabled = !isCalculating;
                self?.runCDButton.isEnabled = !isCalculating;
            })
            .disposed(by: self.disposeBag);
        
        self.runABButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.runABTests();
            })
            .disposed(by: self.disposeBag);
        
        self.runAllButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.runAllTests();
            })
            .disposed(by: self.disposeBag);
        
        self.runCDButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.runCDTests();
            })
            .disposed(by: self.disposeBag);
        
    }

    
    // =================================================================================
    // MARK: - Control Actions
    // =================================================================================
    
    func createDateModels(useShared: Bool) -> [DateModel] {
        return self.dateStrings.map({ x in DateModel(dateString: x, useShared: useShared); });
    }
    
    func runAllTests() {
        self.isCalculating.accept(true);
        self.testsQueue.async(group: self.dispatchGroup) {[unowned self] in
            self.dispatchGroup.enter();
            self.runTest(label: self.testDLabel, indicator: self.indicatorD, useStored: true, useSharedFormatter: true);
        }
        self.testsQueue.async(group: self.dispatchGroup) {[unowned self] in
            self.dispatchGroup.enter();
            self.runTest(label: self.testCLabel, indicator: self.indicatorC, useStored: true, useSharedFormatter: false);
        }
        self.testsQueue.async(group: self.dispatchGroup) {[unowned self] in
            self.dispatchGroup.enter();
            self.runTest(label: self.testBLabel, indicator: self.indicatorB, useStored: false, useSharedFormatter: true);
        }
        self.testsQueue.async(group: self.dispatchGroup) {[unowned self] in
            self.dispatchGroup.enter();
            self.runTest(label: self.testALabel, indicator: self.indicatorA, useStored: false, useSharedFormatter: false);
        }
        
        self.dispatchGroup.notify(queue: DispatchQueue.main) {[unowned self] in
            self.isCalculating.accept(false);
        }
    }
    
    func runABTests() {
        self.isCalculating.accept(true);
        self.testsQueue.async(group: self.dispatchGroup) {[unowned self] in
            self.dispatchGroup.enter();
            self.runTest(label: self.testBLabel, indicator: self.indicatorB, useStored: false, useSharedFormatter: true);
        }
        self.testsQueue.async(group: self.dispatchGroup) {[unowned self] in
            self.dispatchGroup.enter();
            self.runTest(label: self.testALabel, indicator: self.indicatorA, useStored: false, useSharedFormatter: false);
        }
        
        self.dispatchGroup.notify(queue: DispatchQueue.main) {[unowned self] in
            self.isCalculating.accept(false);
        }
    }
    
    func runCDTests() {
        self.isCalculating.accept(true);
        self.testsQueue.async(group: self.dispatchGroup) {[unowned self] in
            self.dispatchGroup.enter();
            self.runTest(label: self.testDLabel, indicator: self.indicatorD, useStored: true, useSharedFormatter: true);
        }
        self.testsQueue.async(group: self.dispatchGroup) {[unowned self] in
            self.dispatchGroup.enter();
            self.runTest(label: self.testCLabel, indicator: self.indicatorC, useStored: true, useSharedFormatter: false);
        }
        
        self.dispatchGroup.notify(queue: DispatchQueue.main) {[unowned self] in
            self.isCalculating.accept(false);
        }
    }
    
    func runTest(label: UILabel, indicator: UIActivityIndicatorView, useStored: Bool, useSharedFormatter: Bool) {
        DispatchQueue.main.async {
            indicator.alpha = 1.0;
        }
        
        let start = Date().timeIntervalSince1970;
        let dates = self.createDateModels(useShared: useSharedFormatter);
        var sorted: [DateModel] = [];
        if (useStored) { sorted = dates.sorted(by: {(a, b) in return (a.storedDate < b.storedDate); }); }
        else { sorted = dates.sorted(by: {(a, b) in return (a.computedDate < b.computedDate); }); }
        let end = Date().timeIntervalSince1970;
        print(sorted);
        
        self.dispatchGroup.leave();
        
        DispatchQueue.main.async {
            label.text = String(format: "%.4f secs", (end - start));
            indicator.alpha = 0.0;
        }
    }
    
    
}
