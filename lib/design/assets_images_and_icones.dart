class AppAssets {
  static const String _imgPath = 'assets/images/';
  static const String _svgPath = 'assets/svg/';

  ///IMAGES
  static String get deliveryInfo => '${_imgPath}delivery-info.png';

  static String get emptyCart => '${_imgPath}empty-cart.png';

  static String get empty => '${_imgPath}empty.png';

  static String get noConnection => '${_imgPath}no-connection.png';

  static String get orderDelivery => '${_imgPath}order-delivery.png';

  static String get internalServerError =>
      '${_imgPath}internal-server-error.png';

  static String get logo => '${_imgPath}logo.png';

  static List<String> get avatarList => [
        deliveryInfo,
        emptyCart,
        empty,
        noConnection,
        orderDelivery,
        internalServerError,
        logo
      ];

  ///SVG
  static String get calendar => '${_svgPath}calendar.svg';

  static String get home => '${_svgPath}home.svg';

  static String get dashboard => '${_svgPath}dashboard.svg';

  static String get filter => '${_svgPath}filter.svg';

  static String get mail => '${_svgPath}mail.svg';

  static String get notification => '${_svgPath}notification.svg';

  static String get projectTask => '${_svgPath}project_task.svg';

  static String get sales => '${_svgPath}sales.svg';

  static String get slack => '${_svgPath}slack.svg';

  static String get intercom => '${_svgPath}intercom.svg';

  static String get jira => '${_svgPath}jira.svg';

  static String get chat => '${_svgPath}chat.svg';

  static String get graph => '${_svgPath}graph.svg';

  static String get settings => '${_svgPath}setting.svg';

  static String get document => '${_svgPath}document.svg';

  static String get profile => '${_svgPath}profile.svg';

  static String get swap => '${_svgPath}swap.svg';

  static String get logout => '${_svgPath}logout.svg';

  static String get order => '${_svgPath}order.svg';

  static String get paiement => '${_svgPath}paiement.svg';

  static String get caisse => '${_svgPath}caisse.svg';
}
