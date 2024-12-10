import 'dart:convert';

import 'package:flagsmith/flagsmith.dart';
import 'package:fraze_pocket/models/config.dart';


class FlagSmithService {
  static const _apikey = '8SAAghmDsZuDj5AEskueN5';

  late final FlagsmithClient _flagsmithClient;

  late final Config _config;

  Future<FlagSmithService> init() async {
    _flagsmithClient = await FlagsmithClient.init(
      apiKey: _apikey,
      config: const FlagsmithConfig(
        caches: true,
      ),
    );
    await _flagsmithClient.getFeatureFlags(reload: true);

    final json = jsonDecode(
        await _flagsmithClient.getFeatureFlagValue(ConfigKey.config.name) ??
            '') as Map<String, dynamic>;
    _config = Config.fromJson(json);
    return this;
  }

  void closeClient() => _flagsmithClient.close();

  Config get config => _config;
}
