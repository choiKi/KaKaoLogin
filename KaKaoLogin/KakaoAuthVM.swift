//
//  KakaoAuthVM.swift
//  KaKaoLogin
//
//  Created by 최기훈 on 2022/09/29.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

class KakaoAuthVM: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()
    
    @Published var isLoggedIn: Bool = false
    
    init() {
        print("kakakoAuth - good")
    }
    // 카카오톡 앱으로 로그인 인증
    func kakaoLoginWithApp() async -> Bool {
        
        await withCheckedContinuation{ continuation in
            
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        }
        
    }
    
    func kakaoLoginWithAccount() async -> Bool {
        // 키키오 계정으로 로그인
        
        await withCheckedContinuation{ contination in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                        contination.resume(returning: false)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        //do something
                        _ = oauthToken
                        contination.resume(returning: true)
                    }
                }
        }
        
    }
    
    @MainActor
    func kakaoLogin() {
        print("KakaoAuthVM - handleKakoLogin() called")
        Task{
            // 카카오톡 설치 여부 확인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                
             isLoggedIn = await kakaoLoginWithApp()
                
            } else { // 카톡 미 설치 시
                isLoggedIn = await kakaoLoginWithAccount()
            }
        }

    }// login
    
    @MainActor
    func kakaoLogout() {
        Task {
            if await handleKakaoLogout() {
                self.isLoggedIn = false
            }
        }
    }
    
    func handleKakaoLogout() async -> Bool {
        
        await withCheckedContinuation{ continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
        }
       
    }
    
}
