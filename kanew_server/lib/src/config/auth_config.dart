/// Auth configuration for development/production
class AuthConfig {
  /// Set to false to skip email verification during signup (dev mode)
  /// Set to true in production to require email confirmation
  static const bool requireEmailVerification = false;
}
