extension ReplaceHost on String {
  String replaceHostIP() {
    return replaceAll('http://127.0.0.1', 'http://172.29.112.1');
  }
}