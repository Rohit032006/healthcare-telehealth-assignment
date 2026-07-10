import '../../environment_config/environment_config.dart';

class EndPoint {
  EndPoint._();
  // dev appId
  static const int appId = 3498234234233;
  static const String currentAppVersion = '3.0.8';
  //document base Url
  // S3 bucket URL for file storage
  static const String s3BucketUrl =
      'https://baap-app-images.s3.ap-south-1.amazonaws.com';
  static var appBaseUrl = EnvironmentConfiguration.baseUrlApi!;
  static var faceBaseUrl = EnvironmentConfiguration.faceUrlApi!;
  static var taskBaseUrl = EnvironmentConfiguration.taskUrlApi!;
  static var faceMatchingBaseUrl=EnvironmentConfiguration.faceMatchingUrl;
  static const String loginUrl = '/auth/api/auth/login';
  static const String getDocumentsUrl = "/auth/api/documents/client/";
  static const String groupUrl = '/auth/api/clients';
  static const String attendanceInOut = '/auth/api/attendance/';
  static const String getUserRolePermission = '/auth/api/permissions/client/';
  static const String leaveUrl = '/auth/api/leave-management/';
  static const String compOffUrl = '/auth/api/compensatory-off';
  static const String refreshTokenUrl = '/auth/api/auth/refresh-token';
  static const String leaveMasterUrl = '/auth/api/leave-config';
  static const String attendanceGetUrl = '/auth/api/attendance';

  static const String createTask='/auth/api/task/client';
  static const String bookAppoinment='/auth/api/appointment/client/';
  static const String getAllTask= '/auth/api/task/client/';
  static const String getAllClinetUser= '/auth/api/users/client/';
  static const String leaveApproveRejectRequestsUrl =
      '/auth/api/leave-management/client/';
  static const String leaveApproveRejectUrl =
      '/auth/api/leave-management/status';
  static const String getManagerResponseUrl = '/auth/api/users/client/';
  static const String regulizationRequestUrl = '/auth/api/regularizations';
  static const String regulizationPendingRequestBase =
      '/auth/api/regularizations/client/';
  static const String updateLeave = 'auth/api/leave-management/';
  static const String regulizationPendingRequestUrl =
      '/auth/api/regularizations/pending/regularization';
  static const String regulizationApproveRejectUrl =
      '/auth/api/regularizations/client/';
  static const String profileUserUrl = '/auth/api/users/';
  static const String checkUserUrl = '/auth/api/users/check-user';
  static const String sendOtpUrl = '/auth/api/auth/request-otp';
  static const String verifyOtpUrl = '/auth/api/auth/verify-otp';
  static const String createVisitorUrl = '/auth/api/visitors/';
  static const String leaveCountUrl = '/auth/api/leave-management/client/';
  static const String saveFirebaseToken = '/auth/api/firebase-tokens';
  static const String admissionDetailsUrl =
      '/auth/api/fees-installment/getaddmissionbyuserid';
        static const String hrmsConfigurationUrl = '/auth/api/hrms-configuration/client/';

  static const String getAppVersionCheckUrl = '/auth/api/app/version';
  static const String getAvailabilityUrl =
      '/auth/api/user-availability/client/';
  static const String comoffRequestUrl = '/auth/api/compensatory-off/client/';
  static const String deleteLeaveUrl = '/auth/api/leave-management/';
  static const String getDeviceUrl = '/auth/api/clients/';
  static const String regularizationConfigUrl =
      '/auth/api/regularization-configuration/';
  static const String shiftGetUrl = 'auth/api/shifts/client/';
  static const String compOffApproveRejectUrl =
      '/auth/api/compensatory-off/client/';
   static const String weeklyOffRequestUrl = 'auth/api/weekly-off-requests/client/';


  static const String userByRole = "/auth/api/users/client/";

  static const String getAllDepartment= '/auth/api/departments/client/';
  static const String getAllLocations = '/auth/api/locations/client/';
  static const String getAllClassrooms = '/auth/api/classes/client/';
  static const String getDivisions = '/auth/api/divisions/client/';
  static const String getTaskCount="/auth/api/task/task_statistics/client/";
  static const String updateTask='/auth/api/task/client';
  static const String getAppointmentsByUserurl='/auth/api/appointment/client/';
  static const String getAppointmentByIdBase='/auth/api/appointment/client/';
  static const String getappointmentcount='/auth/api/appointment/client/';
   static const String createAvailabilityUrl='/auth/api/user-availability/';
  static const String payrollUsersUrl = '/auth/api/users/client/';

  static const String getConfigurationUrl = '/auth/api/configuration/client/';
  static const String updateTaskFile = '/auth/api/task/client/';
  static const String getTaskStatuses = '/auth/api/task-status/client/';
  static const String getTaskTypesBase = '/auth/api/task-types/client/';
  static const String getTaskLogs = '/auth/api/task/client/';
static const String appointmentApprove = '/auth/api/appointment/client/';

  static const String dateFormatDeviceCheck = 'auth/api/auth/device/';
  static const String forgotPasswordVerfityOtpUrl =
      '/auth/api/auth/verify-password-reset-otp';
  static const String forgotPasswordResetUrl = '/auth/api/auth/reset-password';
  static const String passwordCheckpasswordUrl =
      '/auth/api/auth/check-password';

  static const String getAllProjects = '/auth/api/project/client/';
  static const String createProject = '/auth/api/project/client/';
  static const String updateProject = '/auth/api/project/client/';
  static const String deleteProject = '/auth/api/project/';
  static const String getProjectByClient = '/auth/api/project/client/';
  static const String createMilestone = '/auth/api/project-milestone';
  static const String deleteMilestone = '/auth/api/project-milestone/';
  static const String getMilestonesByProject =
      '/auth/api/project-milestone/client/';
  static const String projectMilestoneUploadAttachments =
      '/auth/api/project-milestone/client/';
  static const String generateMilestoneKey =
      '/auth/api/project-milestone/generate-key';

  static const String getProjectAssignees = '/auth/api/project/client/';

  static const String getProjectTypes = '/auth/api/project-types/client/';
  static const String getProjectStatistics = '/auth/api/project/client/';

  static const String getProjectStatuses = '/auth/api/project-status/client/';
  static const String assetCheckoutBase = '/auth/api/asset-checkout/client/';
  static const String assetMappingBase = '/auth/api/asset/client/';

  /// Notifications
  static const String getNotificationsUrl = '/auth/api/user-task-count/client/';

  static const String getNotificationDetailUrl = '/auth/api/user-task-count/';

  static const String leaveBulkApproveBase =
      '/auth/api/leave-management/client/';
  
  static const String taskUpdates = '/auth/api/task-updates/';
  static const String payrollPayslipUrl = '/auth/api/payslip/client/';
  static const String getTaskUsersProject = '/auth/api/users/client/';

  static const String searchRequestBase = '/auth/api/search-request/client/';
  static const String filterBaseUrl = 'platform-development-dev.157.20.214.214.nip.io';
  static const String getFilterTypes = '/auth/api/filter-types/filter-types';
  static const String workflowTriggerUrl = '/auth/api/workflow-trigger/client/'; // Added: workflow trigger URL
  static const String assetRequestUrl = '/auth/api/asset-request/client/';
  static const String assetApprovedUrl = '/auth/api/asset-request-approver/client/';

  // Asset Management
  static const String assetCategories = '/auth/api/asset-categories/client/';
  static const String assetRequests = '/auth/api/asset-request/client/';
  static const String assetRequestdetail = '/auth/api/asset-request-detail/client/';
  static const String deleteCertificate = '/auth/api/certificate_requests/client/';
  static const String uploadAdjustmentFileUrl = '/auth/api/attendance-adjustment/client/';

  static const String breakAttachmentUrl='/auth/api/attendance-adjustment/client/';
  static const String breakAdjustmentApprovalUrl = '/auth/api/attendance-adjustment/client/';

  static const String outdoorDutyRequestUrl = '/auth/api/outdoor-duty-requests/client/';
  static const String outdoorDutyRequestDetailsUrl = '/auth/api/outdoor-duty-requests/client/'; 

  static String get registerFaceUrl => '$faceMatchingBaseUrl/users/register';
  static const String nodeFaceRegistrationUrl = 'auth/api/users/client/';

    static const String invalidAttendanceRequestUrl = '/auth/api/invalid-attendance-request/client/';
    static const String hybridWorkRequestUrl =
      '/auth/api/hybrid-overide-request/client/';

}
