//
//  MainViewModel.swift
//  GSPASS
//
//  Created by 김수완 on 2021/05/25.
//

import Foundation
import RxCocoa
import RxSwift

class MainViewModel: ViewModel {

    private let disposeBag = DisposeBag()

    private var meals = [(dateString: String, meal: MealModel)]()
    private var todayIndex = 0
    private var roadedDateIndex = (alpha: 0, omega: 0)

    struct Input {
        let getMeal: Driver<Int>
        let getUserInfo: Driver<Void>
    }

    struct Output {
        let mealList: PublishRelay<[(dateString: String, meal: MealModel)]>
        let userInfo: PublishRelay<UserInfoModel>
    }

    func transform(_ input: Input) -> Output {
        let mealList = PublishRelay<[(dateString: String, meal: MealModel)]>()
        let userInfo = PublishRelay<UserInfoModel>()

        input.getMeal.asObservable().subscribe(onNext: { index in
            switch self.roadOption(index) {
            case .firstTime:
                self.getMeal(dateIndex: 0) {
                    self.getMeal(dateIndex: 1) {
                        self.getMeal(dateIndex: -1) {
                            self.roadedDateIndex.alpha -= 1
                            self.roadedDateIndex.omega += 1
                            mealList.accept(self.meals)
                        }
                    }
                }
            case .nextDay:
                self.getMeal(dateIndex: self.roadedDateIndex.omega + 1) {
                    self.roadedDateIndex.omega += 1
                    mealList.accept(self.meals)
                }
            case .previousDay:
                self.getMeal(dateIndex: self.roadedDateIndex.alpha - 1) {
                    self.roadedDateIndex.alpha -= 1
                    mealList.accept(self.meals)
                }
            case .unneeded:
                break
            }
        })
        .disposed(by: disposeBag)

        input.getUserInfo.asObservable().subscribe(onNext: {
            HTTPClient.shared.networking(.userInfo, UserInfoModel.self).subscribe(onSuccess: { info in
                userInfo.accept(info)
            })
            .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)

        return Output(mealList: mealList, userInfo: userInfo)
    }

}

extension MainViewModel {
    private func thatDateString(_ index: Int) -> String {
        let dateDifference = index - todayIndex
        let date = dateDifference > 0 ? Date().dayAfter(day: dateDifference) : Date().dayBefore(day: -dateDifference)
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일의 급식"
        return dateDifference == 0 ? "오늘의 급식" : formatter.string(from: date)
    }

    private func roadOption(_ index: Int) -> RoadMoreMealOption {
        return meals.count == 0 ? .firstTime :
               index == meals.count - 1 ? .nextDay :
               index == 0 ? .previousDay : .unneeded
    }

    private func getMeal(dateIndex: Int, completionHandler: @escaping () -> Void) {
        HTTPClient.shared.networking(.getMeal(dateIndex), MealModel.self).subscribe(onSuccess: { meal in
            dateIndex < 0 ? self.meals.insert((self.thatDateString(dateIndex), meal), at: 0) :
                            self.meals.append((self.thatDateString(dateIndex), meal))
            completionHandler()
        }, onFailure: { _ in
            let emptyMeal: MealModel = MealModel(breakfast: nil, lunch: nil, dinner: nil)
            dateIndex < 0 ? self.meals.insert((self.thatDateString(dateIndex), emptyMeal), at: 0) :
                            self.meals.append((self.thatDateString(dateIndex), emptyMeal))
            completionHandler()
        }).disposed(by: disposeBag)
    }

    private enum RoadMoreMealOption {
    case firstTime
    case nextDay
    case previousDay
    case unneeded
    }
}
