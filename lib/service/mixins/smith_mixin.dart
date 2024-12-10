import 'package:fraze_pocket/service/flagsmith_service.dart';
import 'package:get_it/get_it.dart';


mixin SmithMixin {
  final _smith = GetIt.instance<FlagSmithService>();

  String get privacyLink => _smith.config.privacyLink;

  String get termsLink => _smith.config.termsLink;
}
