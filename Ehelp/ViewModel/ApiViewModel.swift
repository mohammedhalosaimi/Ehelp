import Foundation

class ApiViewModel{
    private var api = TwilioApi.sharedInstance
    
    var delegate: ViewModelDelegate?{
        get{
            return api.delegate
        }
        set (value)
        {
            api.delegate = value
        }
    }
    
    func sendSMS(reqBody: String) {
        api.sendReport(with: reqBody)
    }
}
