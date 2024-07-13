class SplashState {
  bool isLoading = true;
  String tip = "初始化中...";

  appendTip(String tip) {
    this.tip = "${this.tip}\n$tip";
  }
}
