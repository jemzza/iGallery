//
//  AuthService.swift
//  iGallery
//
//  Created by Alexander Litvinov on 09.08.2021.
//

import Foundation
import VK_ios_sdk

protocol AuthServiceDelegate: AnyObject {
    func authServiceShouldShow(for: UIViewController)
    func authServiceSignIn()
    func authServiceSignInDidFail(error: Error?)
    func authServiceLogoutlogOutFromVK()
}

protocol AuthService {
    func wakeUpSession()
    func isUserAuthorized() -> Bool
}

class AuthServiceRealization: NSObject, AuthService, VKSdkUIDelegate,VKSdkDelegate {
    
    //MARK: - Private Properties
    private let appId = "7921111"
    private let vkSdk: VKSdk
    
    //MARK: - Public Properties
    weak var delegate: AuthServiceDelegate?
    
    //MARK: - Init
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    //MARK: - Public Methods
    func wakeUpSession() {
        let scope = [""]
        VKSdk.wakeUpSession(scope) { [delegate] authState, error in
            switch authState {
            case .initialized:
                print("initialized")
                VKSdk.authorize(scope)
            case .authorized:
                print("authorized")
                delegate?.authServiceSignIn()
            case .error:
                print("error")
                delegate?.authServiceSignInDidFail(error: error)
            default:
                delegate?.authServiceSignInDidFail(error: nil)
            }
        }
    }
    
    func isUserAuthorized() -> Bool {
        return VKSdk.isLoggedIn()
    }
    
    func vkSdkOutFromVK() {
        
        if isUserAuthorized() {
            VKSdk.forceLogout()
        }
        
        delegate?.authServiceLogoutlogOutFromVK()
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print("vkSdkShouldPresent")
        delegate?.authServiceShouldShow(for: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print("vkSdkNeedCaptchaEnter")
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            delegate?.authServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        delegate?.authServiceSignInDidFail(error: nil)
    }
    
}
