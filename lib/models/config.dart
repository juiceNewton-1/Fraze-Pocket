class Config {
  final String privacyLink;
  final String termsLink;


  const Config({

    required this.privacyLink,
    required this.termsLink,
  });

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        privacyLink: json[ConfigKey.privacyLink.name],
        termsLink: json[ConfigKey.termsLink.name],

      );
}

enum ConfigKey {
  config,
  data,
  useMock,
  privacyLink,
  termsLink,
  netApiKey,
}
