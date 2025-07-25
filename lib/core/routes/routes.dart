enum Routes {
  home('/'),
  login('/login'),
  createAccount('create-account'),
  splash('/splash');

  const Routes(this.value);
  final String value;
}
