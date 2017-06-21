
import Foundation
import Moya

public enum PunchyAPI {
    //创建验证码
    case Captchas(phoneNumber: String)

    //创建令牌
    case Tokens(phoneNumber: String, captcha: String)
    //创建访问令牌
    case TokensAccess(refreshToken: String)

    //获取雇主列表(S)
    case Employers(page: Int, perPage: Int, name: String)
    //创建合约(S)
    case EmployersIDContracts(employerID: String)

    //创建雇员
    case Employees(name: String, phoneNumber: String, captcha: String)
    //获取雇员本人(S)
    //修改雇员本人(S)
    case EmployeesInfo(
        employeeID: String,
        isSet: Bool,
        name: String!,
        phoneNumber: String!,
        captcha: String!
    )
    //获取当前生效合约(S)
    case EmployeesContract(employeeID: String)
    //获取雇员本人打卡信息列表(S)
    case EmployeesPunches(employeeID: String, page: Int, perPage: Int)

    //获取合约信息(S)
    //删除合约(S)
    case ContractsID(contractID: String, isDelete: Bool)
    //创建终止合约请求(S)
    //取消终止合约请求(S)
    case ContractsIDTermination(contractID: String, isDelete: Bool)

    //创建打卡(S)
    case EmployersPunches(
        imageHash: String,
        latitude: Double,
        longitude: Double,
        wirelessAp: String?,
        operatingSystem: String,
        phoneModel: String
    )
}

extension PunchyAPI: TargetType {
    public var baseURL: NSURL { return NSURL(string: "https://glove-test.herokuapp.com/api")! }
    //public var baseURL: NSURL { return NSURL(string: "http://192.168.1.223:8000/api")! }
    public var path: String {
        switch self {
        case .Captchas:
            return "/captchas"

        case .Tokens:
            return "/tokens"
        case .TokensAccess:
            return "/tokens/access"

        case .Employers:
            return "/employers"
        case .EmployersIDContracts(let employerID):
            return "/employers/\(employerID)/contracts"

        case .Employees:
            return "/employees"
        case .EmployeesInfo(let employeeID, _, _, _, _):
            return "/employees/\(employeeID)"
        case .EmployeesContract(let employeeID):
            return "/employees/\(employeeID)/contracts/effective"
        case .EmployeesPunches(let employeeID, _, _):
            return "/employees/\(employeeID)/punches"

        case .ContractsID(let contractID, _):
            return "/contracts/\(contractID)"
        case .ContractsIDTermination(let contractID, _):
            return "/contracts/\(contractID)/termination"

        case .EmployersPunches:
            return "/punches"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .Captchas:
            return .POST

        case .Tokens:
            return .POST
        case .TokensAccess:
            return .POST

        case .Employers:
            return .GET
        case .EmployersIDContracts:
            return .POST

        case .Employees:
            return .POST
        case .EmployeesInfo(_, let isSet, _, _, _):
            return isSet ? .PUT : .GET
        case .EmployeesContract:
            return .GET
        case .EmployeesPunches:
            return .GET

        case .ContractsID(_, let isDelete):
            return isDelete ? .DELETE : .GET
        case .ContractsIDTermination(_, let isDelete):
            return isDelete ? .DELETE : .PUT

        case .EmployersPunches:
            return .POST
        }
    }
    public var parameters: [String: AnyObject]? {
        switch self {
        case .Captchas(let phoneNumber):
            return ["phone_number": phoneNumber]

        case .Tokens(let phoneNumber, let captcha):
            return ["phone_number": phoneNumber, "captcha": captcha]
        case .TokensAccess(let refreshToken):
            return ["refresh_token": refreshToken]

        case .Employers(let page, let perPage, let name):
            var params: [String : AnyObject] = [:]
            params["page"] = page
            params["per_page"] = perPage
            params["name"] = name
            return params
        case .EmployersIDContracts(let employerID):
            return ["employer_id": employerID]

        case .Employees(let name, let phoneNumber, let captcha):
            return ["name": name, "phone_number": phoneNumber, "captcha": captcha]
        case .EmployeesInfo(_, let isSet, let name, let phoneNumber, let captcha):
            return isSet ? ["name": name, "phone_number": phoneNumber, "captcha": captcha] : nil
        case .EmployeesContract:
            return nil
        case .EmployeesPunches(_, let page, let perPage):
            var params: [String : AnyObject] = [:]
            params["page"] = page
            params["per_page"] = perPage
            return params

        case .ContractsID(let contractID, _):
            return ["contract_id": contractID]

        case .ContractsIDTermination(let contractID, _):
            return ["contract_id": contractID]

        case .EmployersPunches(let imageHash, let latitude, let longitude,
            let wirelessAp, let operatingSystem, let phoneModel):
            return [
                "image_hash": imageHash,
                "latitude": latitude,
                "longitude": longitude,
                "wireless_ap": wirelessAp ?? NSNull(),
                "operating_system": operatingSystem,
                "phone_model": phoneModel
            ]
        }
    }

    public var sampleData: NSData {
        switch self {
        case .Captchas:
            return "{}".dataUsingEncoding(NSUTF8StringEncoding)!

        case .Tokens:
            return "[{\"Tokens\": \"TokensInfo\"}]".dataUsingEncoding(NSUTF8StringEncoding)!
        case .TokensAccess:
            return "[{\"TokensAccess\": \"TokensAccessInfo\"}]".dataUsingEncoding(NSUTF8StringEncoding)!

        case .Employers:
            return "[{\"Employers\": \"EmployersInfo\"}]".dataUsingEncoding(NSUTF8StringEncoding)!
        case .EmployersIDContracts:
            return "[{\"EmployersIDContracts\": \"EmployersIDContractsInfo\"}]".dataUsingEncoding(NSUTF8StringEncoding)!

        case .Employees:
            return "[{\"Employees\": \"EmployeesInfo\"}]".dataUsingEncoding(NSUTF8StringEncoding)!
        case .EmployeesInfo:
            return "[{\"Employee\": \"EmployeeInfo\"}]".dataUsingEncoding(NSUTF8StringEncoding)!
        case .EmployeesContract:
            return "[{\"EmployeeContract\": \"EmployeeContractInfo\"}]".dataUsingEncoding(NSUTF8StringEncoding)!
        case .EmployeesPunches:
            return "[{\"EmployeesPunches\": \"EmployeesPunchesInfo\"}]".dataUsingEncoding(NSUTF8StringEncoding)!

        case .ContractsID:
            return "[{\"ContractsID\": \"ContractsIDInfo\"}]".dataUsingEncoding(NSUTF8StringEncoding)!
        case .ContractsIDTermination:
            return "[{\"ContractsIDTermination\": \"ContractsIDTerminationInfo\"}]".dataUsingEncoding(NSUTF8StringEncoding)!

        case .EmployersPunches:
            return "[{\"EmployersPunches\": \"EmployersPunchesInfo\"}]".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }

    public var parameterEncodingType: ParameterEncoding {
        switch self {
        case .Employers, .EmployeesPunches:
            return .URL
        default:
            return .JSON
        }
    }
}

public func url(route: TargetType) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}

// MARK: - Provider setup

private func JSONResponseDataFormatter(data: NSData) -> NSData {
    do {
        let dataAsJSON = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        let prettyData =  try NSJSONSerialization.dataWithJSONObject(dataAsJSON, options: .PrettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}

let PunchyAPIProvider = PunchyProvider<PunchyAPI>()

class PunchyProvider<Target where Target: TargetType> : MoyaProvider<Target> {

    override init(
        endpointClosure: Target -> Endpoint<Target> = PunchyProvider.EndpointMapping,
        requestClosure: (Endpoint<Target>, NSURLRequest -> Void) -> Void = MoyaProvider.DefaultRequestMapping,
        stubClosure: Target -> StubBehavior = MoyaProvider.NeverStub,
        manager: Manager = MoyaProvider<Target>.DefaultAlamofireManager(),
        plugins: [PluginType] = [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)]
        ) {
        super.init(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            stubClosure: stubClosure,
            manager: manager,
            plugins: plugins
        )
    }

    class func EndpointMapping(target: Target) -> Endpoint<Target> {
        let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
        return Endpoint(
            URL: url,
            sampleResponseClosure: {.NetworkResponse(200, target.sampleData)},
            method: target.method,
            parameters: target.parameters,
            parameterEncoding: (target as! PunchyAPI).parameterEncodingType,
            httpHeaderFields: ["Authorization": "Token " + (accessToken ?? "")]
        )
    }
}

// MARK: - Provider support

private extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}