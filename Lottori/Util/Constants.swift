

import UIKit

enum Constants {

    static let IsRelease = false
    static let VersionCode = 1

    enum Url {
        static let Base = IsRelease ? "https://wizschool.io:3000/" : "https://dev.wizschool.io:3000/"
    }

    enum Color {
        static let Main: UIColor = #colorLiteral(red: 0.137254902, green: 0.8470588235, blue: 0.6862745098, alpha: 1)
    }

    static let DEFAULT_PROFILE_IMAGES = [
        "https://s3.ap-northeast-2.amazonaws.com/wizschool-images/profile-image-00.png",
        "https://s3.ap-northeast-2.amazonaws.com/wizschool-images/profile-image-01.png",
        "https://s3.ap-northeast-2.amazonaws.com/wizschool-images/profile-image-02.png",
        "https://s3.ap-northeast-2.amazonaws.com/wizschool-images/profile-image-03.png",
        "https://s3.ap-northeast-2.amazonaws.com/wizschool-images/profile-image-04.png",
        "https://s3.ap-northeast-2.amazonaws.com/wizschool-images/profile-image-05.png",
        "https://s3.ap-northeast-2.amazonaws.com/wizschool-images/profile-image-06.png",
        "https://s3.ap-northeast-2.amazonaws.com/wizschool-images/profile-image-07.png",
        "https://s3.ap-northeast-2.amazonaws.com/wizschool-images/profile-image-08.png",
        "https://s3.ap-northeast-2.amazonaws.com/wizschool-images/profile-image-09.png"
    ]
}
