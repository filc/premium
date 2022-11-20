class PremiumResult {
  final String accessToken;
  final List<String> scopes;

  PremiumResult({
    required this.accessToken,
    required this.scopes,
  });

  factory PremiumResult.fromJson(Map json) {
    return PremiumResult(
      accessToken: json["access_token"] ?? "",
      scopes: (json["scopes"] ?? []).cast<String>(),
    );
  }
}
