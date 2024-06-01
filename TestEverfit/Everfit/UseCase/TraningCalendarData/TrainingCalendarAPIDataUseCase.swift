import RxCocoa
import RxSwift
import Alamofire

// MARK: - Usecaseable
protocol TrainingCalendarAPIDataUseCaseable {
    func getTrainingAPIData() -> Observable<Result<TrainingCalendarResponse?, Error>>
}

// MARK: - Usecase Implementation
class TrainingCalendarAPIDataUseCase: TrainingCalendarAPIDataUseCaseable {

    func getTrainingAPIData() -> Observable<Result<TrainingCalendarResponse?, Error>> {
        return Observable.create({ observer -> Disposable in
            let apiToCall = "http://demo6732818.mockable.io/workouts"
            AF.request(apiToCall,
                       method: .get)
            .responseDecodable(of: TrainingCalendarResponse.self) { response in
                switch response.result {
                case .success(let response): observer.onNext(.success(response))
                case .failure(let error): observer.onNext(.failure(error))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        })
    }
}

// MARK: - Usecase Mock for Test
class TrainingCalendarMockAPIDataUseCase: TrainingCalendarAPIDataUseCaseable {

    func getTrainingAPIData() -> Observable<Result<TrainingCalendarResponse?, Error>> {
        return Observable.create({ observer -> Disposable in
            guard let path = Bundle.main.path(forResource: "training_day_data", ofType: "json") else { return Disposables.create() }
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let response = try? JSONDecoder().decode(TrainingCalendarResponse.self, from: data)

                observer.onNext(.success(response))
                observer.on(.completed)
            } catch let error {
                observer.onNext(.failure(error))
                observer.on(.completed)
            }
            return Disposables.create()
        })
    }
}
