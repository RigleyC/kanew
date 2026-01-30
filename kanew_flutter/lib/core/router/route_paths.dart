class RoutePaths {
  // AUTH ROUTES
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verification = '/auth/verification';
  static const String setPassword = '/auth/set-password';

  // WORKSPACE ROUTES
  static String workspace(String slug) => '/w/$slug';
  static String workspaceBoards(String slug) => '/w/$slug/boards';
  static String workspaceMembers(String slug) => '/w/$slug/members';
  static String workspaceSettings(String slug) => '/w/$slug/settings';

  // BOARD ROUTES
  static String boardView(String workspaceSlug, String boardSlug) =>
      '/w/$workspaceSlug/boards/$boardSlug';

  static String cardDetail(
    String workspaceSlug,
    String boardSlug,
    String cardUuid,
  ) => '/w/$workspaceSlug/boards/$boardSlug/c/$cardUuid';
}
