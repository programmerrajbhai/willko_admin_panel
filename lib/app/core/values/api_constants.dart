class ApiConstants {
  // TODO: আপনার লোকাল IP বা লাইভ ডোমেইন দিয়ে এটি পরিবর্তন করুন
  static const String baseUrl = 'http://192.168.1.110/WillkoServiceApi/api';

  // Image Base URL (ছবি দেখানোর জন্য)
  static const String imageBaseUrl = '$baseUrl/uploads/';

  // === Auth (লগিন ও প্রোফাইল) ===
  static const String login = '/auth/login.php';
  static const String logout = '/auth/logout.php';
  static const String profile = '/auth/profile.php';
  static const String updatePassword = '/auth/update_password.php';

  // === Dashboard (হোম পেজ) ===
  static const String dashboardStats = '/admin/dashboard_stats.php';

  // === Orders (অর্ডার ম্যানেজমেন্ট) ===
  static const String ordersList = '/admin/orders/list.php';
  static const String orderView = '/admin/orders/view.php';
  static const String orderAssign = '/admin/orders/assign.php';
  static const String orderStatus = '/admin/orders/status.php';
  static const String orderDelete = '/admin/orders/delete.php';

  // === Providers (প্রোভাইডার ম্যানেজমেন্ট) ===
  static const String providersList = '/admin/providers/list.php';
  static const String providerAdd = '/admin/providers/add.php';
  static const String providerUpdate = '/admin/providers/update.php';
  static const String providerDelete = '/admin/providers/delete.php';
  static const String providerHistory = '/admin/providers/history.php';

  // === Services (সার্ভিস ম্যানেজমেন্ট) ===
  static const String servicesList = '/admin/services/list.php';
  static const String serviceAdd = '/admin/services/add.php';
  static const String serviceUpdate = '/admin/services/update.php';
  static const String serviceDelete = '/admin/services/delete.php';
  static const String serviceStatus = '/admin/services/status.php';

  // === Categories (ক্যাটাগরি) ===
  static const String categoriesList = '/admin/categories/list.php';
  static const String categoryAdd = '/admin/categories/add.php';
  static const String categoryUpdate = '/admin/categories/update.php';
  static const String categoryDelete = '/admin/categories/delete.php';

  // === Users (কাস্টমার ম্যানেজমেন্ট) ===
  static const String usersList = '/admin/user/list.php';
  static const String userView = '/admin/user/view.php';
  static const String userStatus = '/admin/user/status.php';

  // === Marketing (ব্যানার, কুপন ও নোটিফিকেশন) ===
  static const String bannersList = '/admin/marketing/banners_list.php';
  static const String bannerAdd = '/admin/marketing/banners_add.php';
  static const String bannerDelete = '/admin/marketing/banners_delete.php';

  static const String couponsList = '/admin/marketing/coupons_list.php';
  static const String couponAdd = '/admin/marketing/coupons_add.php';
  static const String couponDelete = '/admin/marketing/coupons_delete.php';

  static const String sendNotification = '/admin/marketing/send_notification.php';

  // === Finance (হিসাব নিকাশ) ===
  static const String dueList = '/admin/finance/due_list.php';
  static const String collectMoney = '/admin/finance/collect.php';
  static const String transactions = '/admin/finance/transactions.php';

  // === Reviews (রিভিউ) ===
  static const String reviewsList = '/admin/reviews/list.php';
  static const String reviewDelete = '/admin/reviews/delete.php';

  // === Settings (সেটিংস) ===
  static const String settingsView = '/admin/settings/view.php';
  static const String settingsUpdate = '/admin/settings/update.php';

  // === Reports (রিপোর্ট) ===
  static const String reportView = '/admin/reports/report_view.php'; // এটি মূলত ওয়েব ভিউতে দেখানোর জন্য
  static const String exportOrders = '/admin/reports/export_orders.php';
}