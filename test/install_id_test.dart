import 'package:appcockpit/src/install_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    resetInstallIdCache();
  });

  test('creates one install ID and keeps it', () async {
    final id = await getInstallId();
    expect(id, matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')));
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('ac_install_id'), id);
    resetInstallIdCache();
    expect(await getInstallId(), id); // read back after a restart
  });

  test('headers include the install ID', () async {
    final headers = await sdkHeaders('tok', '1.1.0');
    expect(headers['x-api-token'], 'tok');
    expect(headers['x-install-id'], isNotNull);
  });
}
