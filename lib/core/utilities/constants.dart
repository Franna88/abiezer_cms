class AppConstants {
  // App information
  static const String appName = 'Abiezer Construction CMS';
  static const String appVersion = '1.0.0';

  // Authentication
  static const int sessionTimeoutMinutes = 30;
  static const int minPasswordLength = 8;

  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;

  // File uploads
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const int maxFilesPerUpload = 5;

  // Material categories
  static const List<String> materialCategories = [
    'Boards & Sheets',
    'Adhesives & Chemicals',
    'Fasteners & Fixings',
    'Tools & Accessories',
    'Electrical & Conduit',
    'Paint & Finishing',
    'Cement & Aggregates',
    'Miscellaneous',
  ];

  // Units of measure
  static const List<String> unitsOfMeasure = [
    'Each',
    'Pack',
    'Box',
    'Roll',
    'Meter',
    'Liter',
    'Kilogram',
    'Bag',
    'Sheet',
    'Pair',
  ];

  // Payment methods
  static const List<String> paymentMethods = ['Card', 'Account', 'Cash'];

  // User roles
  static const String roleAdmin = 'admin';
  static const String roleProjectManager = 'project_manager';

  // Stock thresholds
  static const double lowStockThreshold = 0.2; // 20% of original quantity

  // Transaction types
  static const String transactionPurchase = 'purchase';
  static const String transactionUsage = 'usage';
  static const String transactionTransfer = 'transfer';
  static const String transactionReturn = 'return';

  // Approval statuses
  static const String statusPending = 'pending';
  static const String statusApproved = 'approved';
  static const String statusRejected = 'rejected';

  // Project statuses
  static const String projectStatusActive = 'active';
  static const String projectStatusCompleted = 'completed';
  static const String projectStatusPending = 'pending';
  static const String projectStatusCanceled = 'canceled';

  // Material statuses
  static const String materialStatusNew = 'new';
  static const String materialStatusLeftover = 'leftover';

  // Error messages
  static const String errorNoInternet =
      'No internet connection. Please check your network settings.';
  static const String errorGeneric =
      'Something went wrong. Please try again later.';
  static const String errorInvalidCredentials =
      'Invalid email or password. Please try again.';
  static const String errorNoPermission =
      'You do not have permission to perform this action.';
  static const String errorNoProject = 'Please select a project to continue.';

  // Route names
  static const String routeHome = '/home';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeDashboard = '/dashboard';
  static const String routeProjects = '/projects';
  static const String routeProjectDetails = '/projects/details';
  static const String routeBoM = '/bom';
  static const String routeCreateBoM = '/bom/create';
  static const String routeEditBoM = '/bom/edit';
  static const String routePurchases = '/purchases';
  static const String routeInventory = '/inventory';
  static const String routeReports = '/reports';
  static const String routeSettings = '/settings';
  static const String routeProfile = '/profile';
}
