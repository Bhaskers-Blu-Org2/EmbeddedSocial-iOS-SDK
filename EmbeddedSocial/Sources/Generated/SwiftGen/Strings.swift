// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {

  enum Common {
    /// Cancel
    static let cancel = L10n.tr("Localizable", "common.cancel")
    /// OK
    static let ok = L10n.tr("Localizable", "common.ok")
  }

  enum CreatePost {
    /// Add new post
    static let addPost = L10n.tr("Localizable", "create_post.add_post")
    /// Choose existing
    static let chooseExisting = L10n.tr("Localizable", "create_post.choose_existing")
    /// Leave post
    static let leavePost = L10n.tr("Localizable", "create_post.leave_post")
    /// Post
    static let post = L10n.tr("Localizable", "create_post.post")
  }

  enum Error {
    /// The operation has been cancelled by user.
    static let cancelledByUser = L10n.tr("Localizable", "error.cancelled_by_user")
    /// The request has failed.
    static let failedRequest = L10n.tr("Localizable", "error.failed_request")
    /// Image compression has failed.
    static let imageCompressionFailed = L10n.tr("Localizable", "error.image_compression_failed")
    /// User credentials are missing.
    static let missingCredentials = L10n.tr("Localizable", "error.missing_credentials")
    /// User data is missing.
    static let missingUserData = L10n.tr("Localizable", "error.missing_user_data")
    /// Unknown error occurred.
    static let unknown = L10n.tr("Localizable", "error.unknown")
  }

  enum ImagePicker {
    /// Take photo
    static let takePhoto = L10n.tr("Localizable", "image_picker.take_photo")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
