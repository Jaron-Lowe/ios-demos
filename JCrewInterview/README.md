# J.Crew iOS Tech Lead Interview
This is the result of my interview with J.Crew. The main technical interview was very short given the amount of work they wanted done. The interview ended up being me explaining what I would do further if given more time. Because it was a decent programming interview I ended up completing it later that night. I used my networking package [SimpleApiClient](https://github.com/Jaron-Lowe/SimpleApiClient) in the final project to simplify networking code that I've already written previously.

Because The interview did not provide any real api endpoint the final project inserts a fake, non-existant one. In order to show diferent network conditions I wrote a `PreviewLoginService` implementing the `LoginServicing` protocol in order to simulate varying network results.

The final project has no dependency injection solution as I thought it would be overkill to spend any more time implmenting one.

## Prompt
- Implement a login use case following the MVVM pattern and using Swift/SwiftUI
- 20 minute time limit
- Focus most on networking layer structure, get to view layer last
- Parse a success and failure response based on the following and display them to the user as an alert:
```
Endpoint ->
POST /login
{ 
  "username": "johndoe"
  "password": "123"
}

Success response -> 200...299
{
  jwt_value: "1234566"
}

Failure response -> 400...499 / 500+
{
  error_code: 403,
  error_message: "Some error"
}
```

## Original Interview Result
```swift
// Network Models
// ============================================================================

struct LoginSuccess: Decodable {
  let jwtValue: String
}

struct ApiFailure: Decodable, Error {
  let errorCode: Int
  let errorMessage: String
}


// Network Client
// ============================================================================

typealias DecodableError = (Decodable & Error)

open class HttpClient {
  
  private let baseURL: URL
  private let invalidErrorType: DecodableError.Type?
  
  // TODO: Add custom Decoder
  init(baseURL: URL, invalidErrorType: DecodableError.Type?) {
    self.baseURL = baseURL
    self.invalidErrorType = invalidErrorType
  }
  
  func makeRequest<Api: HttpRequest>(api: Api) async throws -> Api.ResponseType {
    // TODO: Utilize URLSession
    // TODO: Validate 2xx status errorCode
    // TODO: Parse success or failure model based on status code.
  }
}

// Usage
final class MyHttpClient: HttpClient {
  init() {
    super.init(baseURL: URL(string: "my/baseUrl/")!)
  }
}


// Network API Request Definition
// ============================================================================

public protocol HTTPApiRequest {
  associatedType ResponseType: Decodable
  
  var endpointPath: String { get }
  var method: String { get }
  var parameters: HttpParameters { get }
  var timeOutInterval: TimeInterval { get }
}

public enum HttpParameters {
  case queryString(String)
  case body(Encodable)
}

// Usage
public struct LoginRequest: HTTPApiRequest {
  var endpointPath: String {
    "/my/endpoint/login"
  }
  
  var method: String { 
  	"POST"
  }
  
  var parameters: HttpParameters {
    .body(requestBody)
  }
  
  let requestBody: LoginRequestBody
  
  public init(requestBody: LoginCredentials) {
    self.requestBody = requestBody
  }
}
  
struct LoginCredentials: Encodable {
    let username: String
    let password: String

    public init(username: String, password: String) {
      self.username = username
      self.password = password
    }
}
  
  
// Service Layer
// ============================================================================

protocol LoginServicing {
  func login(body: LoginCredentials) async throws
}

// Usage
final LoginService: LoginServicing {
  init(httpClient: HttpClient) {
    self.client = httpClient
  }
  
  func login(body: LoginCredentials) async throws -> LoginSuccess {
    try await client.makeRequest(api: LoginRequest(requestBody: body))
  }
}
  
  
// View Model Layer
// ============================================================================

@MainActor  
final class LoginViewModel: ObservableObject {
  
  @Published var username: String
  @Published var password: String
  @Published var successResult: LoginSuccess?
  @Published var errorResult: ApiFailure? 
  
  private loginService: LoginServicing
  
  init(loginService: LoginServicing) {
    self.loginService = loginService
  }
  
  func loginAction() {
    do {
      try await let result loginService.login(.init(username, password))
      successResult = result
    } catch let error as ApiFailure {
      errorResult = error
    }
    
  } 
}


// View Layer
// ============================================================================

struct LoginView: View {
  let viewModel: LoginViewModel

  init(viewModel: LoginViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    VStack(spacing: 8) {
      Text("Login")
      TextField("Username", $viewModel.username)
      SecureField("Password", $viewModel.password)
      Button("Login") {
        viewModel.loginAction
      }
    }
    .padding()
    .alert(
      // TODO: Implement alert display
    )
  }
}
```

## Final Result
| Empty | Validation |
| ----- | ---------- |
| ![Empty_Login](https://github.com/Jaron-Lowe/ios-demos/assets/10712389/607a4f30-2533-4559-8432-4584965c8261) | ![Input_Validation](https://github.com/Jaron-Lowe/ios-demos/assets/10712389/5fddfcba-bc28-41ce-be75-9c43e6f34640) 

| Success | Server Error | Other Error |
| ------- | ------------ | ----------- |
| ![Success](https://github.com/Jaron-Lowe/ios-demos/assets/10712389/fe481c41-bfe2-4d58-89fe-96a963a4791d) | ![Server_Error](https://github.com/Jaron-Lowe/ios-demos/assets/10712389/961a758c-1ff4-4a16-a998-8da9b3213519) | ![Unexpected_Error](https://github.com/Jaron-Lowe/ios-demos/assets/10712389/c6cc0af2-7abf-4fc3-8b38-673244ae09ac) |



