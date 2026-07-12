/// Simple string localization. Access via: AppStrings.of(context).login
class AppStrings {
  final bool isArabic;
  const AppStrings._(this.isArabic);

  static AppStrings of(context) {
    // Will be called with locale from LocaleProvider
    return const AppStrings._(true); // default ظ¤ overridden in widgets
  }

  // ظ¤ظ¤ظ¤ Auth ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
  String get login          => isArabic ? '╪ز╪│╪ش┘è┘ ╪د┘╪»╪«┘ê┘'         : 'Login';
  String get register       => isArabic ? '╪ح┘╪┤╪د╪ة ╪ص╪│╪د╪ذ'           : 'Create Account';
  String get logout         => isArabic ? '╪ز╪│╪ش┘è┘ ╪د┘╪«╪▒┘ê╪ش'         : 'Logout';
  String get email          => isArabic ? '╪د┘╪ذ╪▒┘è╪» ╪د┘╪ح┘┘â╪ز╪▒┘ê┘┘è'    : 'Email';
  String get password       => isArabic ? '┘â┘┘à╪ر ╪د┘┘à╪▒┘ê╪▒'           : 'Password';
  String get confirmPass    => isArabic ? '╪ز╪ث┘â┘è╪» ┘â┘┘à╪ر ╪د┘┘à╪▒┘ê╪▒'    : 'Confirm Password';
  String get fullName       => isArabic ? '╪د┘╪د╪│┘à ╪د┘┘â╪د┘à┘'         : 'Full Name';
  String get phone          => isArabic ? '╪▒┘é┘à ╪د┘┘ç╪د╪ز┘'           : 'Phone Number';
  String get forgotPassword => isArabic ? '┘╪│┘è╪ز ┘â┘┘à╪ر ╪د┘╪│╪▒╪ا'      : 'Forgot Password?';
  String get haveAccount    => isArabic ? '┘╪»┘è┘â ╪ص╪│╪د╪ذ ╪ذ╪د┘┘╪╣┘╪ا '   : 'Already have an account? ';
  String get noAccount      => isArabic ? '┘┘è╪│ ┘╪»┘è┘â ╪ص╪│╪د╪ذ╪ا '      : 'Don\'t have an account? ';
  String get welcomeBack    => isArabic ? '┘à╪▒╪ص╪ذ╪د┘ï ╪ذ┘â ┘à╪ش╪»╪»╪د┘ï!'    : 'Welcome Back!';
  String get loginSubtitle  => isArabic ? '┘è╪▒╪ش┘ë ╪ح╪»╪«╪د┘ ╪ذ┘è╪د┘╪د╪ز┘â'   : 'Please enter your details';

  // ظ¤ظ¤ Home ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
  String get hello          => isArabic ? '┘à╪▒╪ص╪ذ╪د┘ï'                : 'Hello';
  String get howHelp        => isArabic ? '┘â┘è┘ ┘è┘à┘â┘┘╪د ┘à╪│╪د╪╣╪»╪ز┘â ╪د┘┘è┘ê┘à╪ا' : 'How can we help you today?';
  String get emergency      => isArabic ? '╪╡┘è╪د┘╪ر ╪╖╪د╪▒╪خ╪ر'           : 'Emergency Service';
  String get towing         => isArabic ? '╪╖┘╪ذ ┘ê┘╪┤'               : 'Towing';
  String get mainServices   => isArabic ? '╪د┘╪«╪»┘à╪د╪ز ╪د┘╪ث╪│╪د╪│┘è╪ر'      : 'Main Services';
  String get viewAll        => isArabic ? '╪╣╪▒╪╢ ╪د┘┘â┘'              : 'View All';
  String get all            => isArabic ? '╪د┘┘â┘'                  : 'All';
  String get battery        => isArabic ? '╪د┘╪ذ╪╖╪د╪▒┘è╪ر'              : 'Battery';
  String get oilChange      => isArabic ? '╪ز╪║┘è┘è╪▒ ╪د┘╪▓┘è╪ز'           : 'Oil Change';
  String get tires          => isArabic ? '╪د┘╪ح╪╖╪د╪▒╪د╪ز'              : 'Tires';
  String get carWash        => isArabic ? '╪║╪│┘è┘ ╪د┘╪│┘è╪د╪▒╪ر'          : 'Car Wash';
  String get menu           => isArabic ? '╪د┘┘é╪د╪خ┘à╪ر'               : 'Menu';
  String get services       => isArabic ? '╪د┘╪«╪»┘à╪د╪ز'               : 'Services';

  // Subtitles for services
  String get batterySub     => isArabic ? '╪┤╪ص┘ / ╪ز╪║┘è┘è╪▒ / ╪┤╪▒╪د╪ة ╪ذ╪╖╪د╪▒┘è╪ر ╪ش╪»┘è╪»╪ر' : 'Charge / Replace / Buy New Battery';
  String get oilChangeSub   => isArabic ? '╪ز╪║┘è┘è╪▒ ╪د┘╪▓┘è╪ز ┘ê╪د┘┘┘╪ز╪▒ - ╪╡┘è╪د┘╪ر ╪»┘ê╪▒┘è╪ر' : 'Oil & Filter Change - Regular Maintenance';
  String get tiresSub       => isArabic ? '┘┘╪« / ╪ز╪║┘è┘è╪▒ / ┘╪ص╪╡ ╪د┘╪ح╪╖╪د╪▒╪د╪ز' : 'Inflate / Replace / Inspect Tires';
  String get carWashSub     => isArabic ? '╪ز┘╪╕┘è┘ ╪┤╪د┘à┘ ┘à┘ ╪د┘╪»╪د╪«┘ ┘ê╪د┘╪«╪د╪▒╪ش' : 'Comprehensive Interior & Exterior Cleaning';
  String get emergencySub   => isArabic ? '╪╣╪╖┘ ┘à┘╪د╪ش╪خ╪ا ┘╪╡┘ ╪ح┘┘è┘â ┘┘è ╪ث╪│╪▒╪╣ ┘ê┘é╪ز' : 'Sudden Breakdown? We reach you ASAP';
  String get towingSub      => isArabic ? '╪│╪ص╪ذ ╪د┘╪│┘è╪د╪▒╪ر ┘à┘ ┘ê╪ح┘┘ë ╪ث┘è ┘à┘â╪د┘' : 'Tow your car to and from anywhere';

  // Prices
  String get priceEGP       => isArabic ? '╪ش┘┘è┘ç' : 'EGP';
  String get priceStarts    => isArabic ? '┘è╪ذ╪»╪ث ┘à┘' : 'Starts from';

  // ظ¤ظ¤ظ¤ Orders ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
  String get orderPending      => isArabic ? '╪╖┘╪ذ┘â ┘é┘è╪» ╪د┘┘à╪▒╪د╪ش╪╣╪ر ┘à┘ ╪د┘╪ح╪»╪د╪▒╪ر' : 'Your order is being reviewed';
  String get orderPendingSub   => isArabic ? '╪│┘┘é┘ê┘à ╪ذ╪د┘╪▒╪» ╪╣┘┘è┘â ┘┘è ╪ث┘é╪▒╪ذ ┘ê┘é╪ز' : 'We will get back to you soon';
  String get orderOnTheWay     => isArabic ? '╪ز┘à ╪ز╪╣┘è┘è┘ ┘┘┘è ╪╡┘è╪د┘╪ر'   : 'Technician Assigned';
  String get orderOnTheWaySub  => isArabic ? '╪د┘┘┘┘è ┘┘è ╪د┘╪╖╪▒┘è┘é ╪ح┘┘è┘â ╪د┘╪ت┘' : 'Technician is on the way';
  String get orderUnderProcess => isArabic ? '╪د┘┘┘┘è ┘è╪╣┘à┘ ╪╣┘┘ë ╪│┘è╪د╪▒╪ز┘â' : 'Technician working on your car';
  String get orderUnderProcessSub => isArabic ? '╪ش╪د╪▒┘ ╪ح╪╡┘╪د╪ص ╪د┘╪│┘è╪د╪▒╪ر ╪د┘╪ت┘' : 'Repair in progress';
  String get orderCompleted    => isArabic ? '╪╖┘╪ذ ┘à┘â╪ز┘à┘'             : 'Order Completed';
  String get orderCompletedSub => isArabic ? '╪ز┘à ╪د┘╪د┘╪ز┘ç╪د╪ة ┘à┘ ╪د┘╪╡┘è╪د┘╪ر ╪ذ┘╪ش╪د╪ص' : 'Service completed successfully';
  String get viewDetails       => isArabic ? '╪╣╪▒╪╢ ╪د┘╪ز┘╪د╪╡┘è┘'          : 'View Details';
  String get orderNow          => isArabic ? '╪د╪╖┘╪ذ ╪د┘╪ت┘'             : 'Order Now';
  // Legacy aliases
  String get orderInProgress    => orderOnTheWay;
  String get orderInProgressSub => orderOnTheWaySub;

  // ظ¤ظ¤ظ¤ Drawer ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
  String get myOrders     => isArabic ? '╪╖┘╪ذ╪د╪ز┘è'           : 'My Orders';
  String get myVehicles   => isArabic ? '╪│┘è╪د╪▒╪د╪ز┘è'          : 'My Vehicles';
  String get help         => isArabic ? '╪د┘┘à╪│╪د╪╣╪»╪ر'         : 'Help';
  String get logoutConfirm => isArabic ? '╪ز╪│╪ش┘è┘ ╪د┘╪«╪▒┘ê╪ش'   : 'Logout';

  // ظ¤ظ¤ظ¤ Profile ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
  String get profile        => isArabic ? '╪د┘┘à┘┘ ╪د┘╪┤╪«╪╡┘è'          : 'Profile';
  String get personalInfo   => isArabic ? '╪د┘┘à╪╣┘┘ê┘à╪د╪ز ╪د┘╪┤╪«╪╡┘è╪ر'     : 'Personal Information';
  String get stats          => isArabic ? '╪د┘╪ح╪ص╪╡╪د╪خ┘è╪د╪ز'            : 'Statistics';
  String get rating         => isArabic ? '╪د┘╪ز┘é┘è┘è┘à'               : 'Rating';
  String get orders         => isArabic ? '╪د┘╪╖┘╪ذ╪د╪ز'               : 'Orders';
  String get editProfile    => isArabic ? '╪ز╪╣╪»┘è┘ ╪د┘╪ذ┘è╪د┘╪د╪ز'        : 'Edit Profile';
  String get saveChanges    => isArabic ? '╪ص┘╪╕ ╪د┘╪ز╪╣╪»┘è┘╪د╪ز'         : 'Save Changes';
  String get memberSince    => isArabic ? '╪╣╪╢┘ê ┘à┘╪░'               : 'Member since';
  String get address        => isArabic ? '╪د┘╪╣┘┘ê╪د┘'               : 'Address';
  String get vehicle        => isArabic ? '╪د┘┘à╪▒┘â╪ذ╪ر'               : 'Vehicle';

  // ظ¤ظ¤ظ¤ Settings ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
  String get settings       => isArabic ? '╪د┘╪د╪╣╪»╪د╪»╪د╪ز'             : 'Settings';
  String get generalSettings => isArabic ? '╪د┘╪ح╪╣╪»╪د╪»╪د╪ز ╪د┘╪╣╪د┘à╪ر'     : 'General Settings';
  String get notifications  => isArabic ? '╪د┘╪ح╪┤╪╣╪د╪▒╪د╪ز'             : 'Notifications';
  String get notifHint      => isArabic ? '╪ز┘┘é┘è ╪ح╪┤╪╣╪د╪▒╪د╪ز ╪د┘╪╖┘╪ذ╪د╪ز'  : 'Receive order notifications';
  String get darkMode       => isArabic ? '╪د┘┘ê╪╢╪╣ ╪د┘┘┘è┘┘è'          : 'Dark Mode';
  String get darkModeHint   => isArabic ? '┘à╪╕┘ç╪▒ ╪»╪د┘â┘ ┘┘╪ز╪╖╪ذ┘è┘é'    : 'Dark app appearance';
  String get language       => isArabic ? '╪د┘┘╪║╪ر'                 : 'Language';
  String get privacy        => isArabic ? '╪د┘╪«╪╡┘ê╪╡┘è╪ر ┘ê╪د┘╪ث┘à╪د┘'      : 'Privacy & Security';
  String get privacyPolicy  => isArabic ? '╪│┘è╪د╪│╪ر ╪د┘╪«╪╡┘ê╪╡┘è╪ر'       : 'Privacy Policy';
  String get terms          => isArabic ? '╪د┘╪┤╪▒┘ê╪╖ ┘ê╪د┘╪د╪ص┘â╪د┘à'       : 'Terms & Conditions';
  String get helpSupport    => isArabic ? '╪د┘╪»╪╣┘à ┘ê╪د┘┘à╪│╪د╪╣╪»╪ر'       : 'Help & Support';
  String get helpCenter     => isArabic ? '┘à╪▒┘â╪▓ ╪د┘┘à╪│╪د╪╣╪»╪ر'         : 'Help Center';
  String get contactUs      => isArabic ? '╪د╪ز╪╡┘ ╪ذ┘╪د'              : 'Contact Us';
  String get appVersion     => isArabic ? '╪د╪╡╪»╪د╪▒ ╪د┘╪ز╪╖╪ذ┘è┘é'         : 'App Version';
  String get allRights      => isArabic ? '┬ر 2024 ╪«╪»┘à╪ر ╪╡┘è╪د┘╪ر ╪د┘╪│┘è╪د╪▒╪د╪ز. ╪ش┘à┘è╪╣ ╪د┘╪ص┘é┘ê┘é ┘à╪ص┘┘ê╪╕╪ر.' : '┬ر 2024 Car Maintenance Service. All rights reserved.';
  String get chooseLanguage => isArabic ? '╪د╪«╪ز╪▒ ╪د┘┘╪║╪ر'            : 'Choose Language';
  String get arabic         => isArabic ? '╪د┘╪╣╪▒╪ذ┘è╪ر'               : 'Arabic';
  String get english        => isArabic ? '╪د┘╪ح┘╪ش┘┘è╪▓┘è╪ر'            : 'English';

  // ظ¤ظ¤ظ¤ Onboarding ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
  String get onboardingNext => isArabic ? '╪د┘╪ز╪د┘┘è' : 'Next';

  // Screen 1
  String get ob1Feature1Title    => isArabic ? '╪ش┘ê╪»╪ر ┘à┘ê╪س┘ê┘é╪ر'       : 'Reliable Quality';
  String get ob1Feature1Sub      => isArabic ? '╪«╪»┘à╪ر ╪د╪ص╪ز╪▒╪د┘┘è╪ر'     : 'Professional Service';
  String get ob1Feature2Title    => isArabic ? '╪▒╪د╪ص╪ر ┘ê╪│┘ç┘ê┘╪ر'       : 'Comfort & Ease';
  String get ob1Feature2Sub      => isArabic ? '╪د╪ص╪ش╪▓ ┘┘è ╪س┘ê╪د┘┘è'     : 'Book in Seconds';
  String get ob1Feature3Title    => isArabic ? '┘┘è ╪ث┘è ┘à┘â╪د┘'        : 'Anywhere';
  String get ob1Feature3Sub      => isArabic ? '┘╪╡┘ ╪ح┘┘è┘â'          : 'We Come to You';

  // Screen 2
  String get ob2Feature1Title    => isArabic ? '╪ز╪ز╪ذ╪╣ ┘à╪ذ╪د╪┤╪▒'        : 'Live Location';
  String get ob2Feature1Sub      => isArabic ? '╪ز╪د╪ذ╪╣ ┘ê╪╡┘ê┘┘╪د ┘╪ص╪╕┘è╪د┘ï' : 'Track our arrival in real-time';
  String get ob2Feature2Title    => isArabic ? '┘ê┘é╪ز ┘à╪▒┘'           : 'Flexible Time';
  String get ob2Feature2Sub      => isArabic ? '╪د╪«╪ز╪▒ ┘ê┘é╪ز┘â ╪د┘┘à┘╪د╪│╪ذ' : 'Choose the time that suits you';
  String get ob2Feature3Title    => isArabic ? '╪«╪»┘à╪ر ┘à╪ز┘┘é┘╪ر'       : 'Mobile Service';
  String get ob2Feature3Sub      => isArabic ? '┘╪ث╪ز┘è ╪ح┘┘è┘â ┘à╪ش┘ç╪▓┘è┘'  : 'We come fully equipped to you';

  // Screen 3
  String get ob3Feature1Title    => isArabic ? '╪ز┘é┘è┘è┘à ╪╣╪د┘┘è'         : 'Top Rated';
  String get ob3Feature1Sub      => isArabic ? '╪س┘é╪ر ╪╣┘à┘╪د╪خ┘╪د ╪ز┘à┘è╪▓┘╪د' : 'Highly rated by\nour customers';
  String get ob3Feature2Title    => isArabic ? '╪╢┘à╪د┘ ╪د┘╪«╪»┘à╪ر'        : 'Warranty';
  String get ob3Feature2Sub      => isArabic ? '╪«╪»┘à╪ر ╪ز╪س┘é ╪ذ┘ç╪د'      : 'Service you can\nrely on';
  String get ob3Feature3Title    => isArabic ? '╪»┘╪╣ ╪│┘ç┘'            : 'Easy Payment';
  String get ob3Feature3Sub      => isArabic ? '╪«┘è╪د╪▒╪د╪ز ╪»┘╪╣ ┘à╪ز╪╣╪»╪»╪ر'  : 'Secure & multiple\npayment options';
}

/// Extension to get localized strings easily from any widget
extension AppStringsExt on bool {
  AppStrings get s => AppStrings._(this);
}

/// Create from isArabic flag
AppStrings appStrings(bool isArabic) => AppStrings._(isArabic);
