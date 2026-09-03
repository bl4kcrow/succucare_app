enum Routes {
  alerts('/alerts'),
  home('/home'),
  login('/login'),
  createAccount('create-account'),
  settings('/settings'),
  scanPlant('/scan-plant'),
  scanResult('/scan-result'),
  splash('/splash');

  const Routes(this.value);
  final String value;
}
