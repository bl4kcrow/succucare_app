enum Routes {
  alerts('/alerts'),
  addPlant('/add-plant'),
  editPlant('/edit-plant'),
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
