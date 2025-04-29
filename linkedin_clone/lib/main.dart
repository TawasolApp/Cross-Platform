import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linkedin_clone/core/Navigation/app_router.dart';
import 'package:linkedin_clone/features/authentication/Data/Data_Sources/auth_remote_data_source.dart';
import 'package:linkedin_clone/features/authentication/Data/Data_Sources/auth_remote_data_source_interface.dart';
import 'package:linkedin_clone/features/authentication/Data/Data_Sources/mock_auth_remote_data_source.dart';
import 'package:linkedin_clone/features/authentication/Data/Repository/auth_repository_impl.dart';
import 'package:linkedin_clone/features/authentication/Domain/Repository/auth_repository.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/forgot_password_usecase.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/login_usecase.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/register_usecase.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/resend_email_usecase.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/auth_provider.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/register_provider.dart';
import 'package:linkedin_clone/features/company/data/datasources/company_remote_data_source.dart';
import 'package:linkedin_clone/features/company/data/datasources/job_remote_data_source.dart';
import 'package:linkedin_clone/features/company/data/datasources/media_remote_data_source.dart.dart';
import 'package:linkedin_clone/features/company/data/datasources/user_remote_data_source.dart';
import 'package:linkedin_clone/features/company/data/repositories/company_repository_impl.dart';
import 'package:linkedin_clone/features/company/data/repositories/job_repository_impl.dart';
import 'package:linkedin_clone/features/company/data/repositories/user_repository_impl.dart';
import 'package:linkedin_clone/features/company/domain/repositories/media_repository.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_related_companies_usecase.dart';
import 'package:linkedin_clone/features/company/domain/usecases/geta_all_company_admins.dart';
import 'package:linkedin_clone/features/company/domain/usecases/search_users_use_case.dart';
import 'package:linkedin_clone/features/company/domain/usecases/upload_image_use_case.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_admins_provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_create_provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_edit_provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_list_companies_provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/related_companies_provider.dart';
import 'package:linkedin_clone/features/connections/data/datasources/connections_remote_data_source.dart';
import 'package:linkedin_clone/features/connections/data/repository/connections_repository_impl.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/block/block_user_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/block/get_blocked_list_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/block/unblock_user_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/get_connections_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/get_following_list_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/get_followers_list_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/unfollow_user_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/follow_user_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/remove_connection_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/get_received_connection_requests_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/get_sent_connection_requests_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/accept_ignore_connection_request_usecase.dart';

import 'package:linkedin_clone/features/connections/domain/usecases/connect/send_connection_request_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/connect/withdraw_connection_request_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/get_people_you_may_know_usecase.dart';
import 'package:linkedin_clone/features/connections/presentations/pages/invitations_page.dart';
import 'package:linkedin_clone/features/connections/presentations/pages/list_page.dart';
import 'package:linkedin_clone/features/connections/presentations/pages/my_network_page.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/connections_provider.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/test_page.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_post_by_id_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_post_reactions_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_saved_posts_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/react_to_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/save_post_usecase.dart';
import 'package:linkedin_clone/features/main_layout/domain/UseCases/change_password_usecase.dart';
import 'package:linkedin_clone/features/main_layout/domain/UseCases/delete_account_usecase.dart';
import 'package:linkedin_clone/features/main_layout/domain/UseCases/update_email_usecase.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_all_companies.dart';
import 'package:linkedin_clone/features/main_layout/presentation/provider/settings_provider.dart';
import 'package:linkedin_clone/features/messaging/data/data_sources/conversation_remote_data_source.dart';
import 'package:linkedin_clone/features/messaging/data/data_sources/mock_conversation_remote_data_source.dart';
import 'package:linkedin_clone/features/messaging/domain/usecases/get_conversations_usecase.dart';
import 'package:linkedin_clone/features/messaging/presentation/provider/conversation_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../features/feed/data/data_sources/feed_remote_data_source.dart';
import '../features/feed/data/repositories/feed_repository_impl.dart';
import '../features/feed/domain/usecases/create_post_usecase.dart';
import '../features/feed/domain/usecases/delete_post_usecase.dart';
import '../features/feed/domain/usecases/get_posts_usecase.dart';
import '../features/feed/domain/usecases/edit_post_usecase.dart';
import '../features/feed/presentation/provider/feed_provider.dart';
import 'core/themes/app_theme.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/get_profile.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_bio.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart';
import 'package:linkedin_clone/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:linkedin_clone/features/profile/data/repository/profile_repository_impl.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/add_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/delete_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/certifications/update_certification.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/add_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/delete_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/education/update_education.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/add_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/delete_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/experience/update_experience.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/add_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/update_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/delete_skill.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_cover_photo.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_profile_picture.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_cover_picture.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_headline.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_industry.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_location.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_first_name.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_last_name.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_profile_picture.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/update_resume.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_headline.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_industry.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_location.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_bio.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/delete_resume.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/skills/get_skill_endorsements.dart';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:linkedin_clone/core/network/connection_checker.dart';
import 'package:linkedin_clone/features/profile/data/data_sources/mock_profile_remote_data_source.dart';
import 'package:linkedin_clone/features/company/domain/usecases/update_company_details_use_case.dart';
import 'package:linkedin_clone/features/company/domain/usecases/add_admin_use_case.dart'; // Ensure this is the correct path
import 'package:linkedin_clone/features/connections/presentations/pages/invitations_page.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/comment_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/fetch_comments_usecase.dart';
import 'package:linkedin_clone/features/company/domain/entities/company_update_entity.dart';
import 'package:linkedin_clone/features/company/domain/usecases/add_admin_use_case.dart';
import 'package:linkedin_clone/features/company/domain/usecases/update_company_details_use_case.dart';
import 'features/connections/presentations/widgets/page_type_enum.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/edit_comment_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/unsave_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_user_posts_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/delete_comment_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_post_by_id_usecase.dart';

import 'package:linkedin_clone/features/admin_panel/presentation/provider/admin_provider.dart';
import 'package:linkedin_clone/features/admin_panel/domain/usecases/get_reports_usecase.dart';
import 'package:linkedin_clone/features/admin_panel/domain/usecases/resolve_report_usecase.dart';
import 'package:linkedin_clone/features/admin_panel/domain/usecases/get_job_listings_usecase.dart';
import 'package:linkedin_clone/features/admin_panel/domain/usecases/delete_job_listing_usecase.dart';
import 'package:linkedin_clone/features/admin_panel/domain/usecases/get_analytics_usecase.dart';
import 'package:linkedin_clone/features/admin_panel/data/repositories/admin_repository_impl.dart';
import 'package:linkedin_clone/features/admin_panel/data/data_sources/admin_remote_data_source.dart';
import 'package:linkedin_clone/features/notifications/data/data_sources/notifications_remote_data_source.dart';
import 'package:linkedin_clone/features/notifications/data/repository/notifications_repository_impl.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_unseen_notifications_count_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/get_fcm_token_usecase.dart';
import 'package:linkedin_clone/features/notifications/domain/usecases/initialize_fcm_usecase.dart';
import 'package:linkedin_clone/features/notifications/presentation/provider/notifications_provider.dart';

// core Flutter primitives
import 'package:flutter/foundation.dart';
// core FlutterFire dependency
import 'package:firebase_core/firebase_core.dart';
// generated by 
import 'firebase_options.dart';
// FlutterFire's Firebase Cloud Messaging plugin
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  // Initialize InternetConnectionCheckerPlus instance
  // final internetConnection = InternetConnection();

  // Initialize data source and repository
  // final ProfileRemoteDataSourceImpl dataSource = ProfileRemoteDataSourceImpl(
  //   client: http.Client(),
  //   baseUrl: 'https://your-api-url.com',
  // );
  final companyRemoteDataSource = CompanyRemoteDataSource();
  final jobRemoteDataSource = JobRemoteDataSource();
  final userRemoteDataSource = UserRemoteDataSource();
  final companyrepos = CompanyRepositoryImpl(
    remoteDataSource: companyRemoteDataSource,
  );
  final jobrepos = JobRepositoryImpl(remoteDataSource: jobRemoteDataSource);
  final userRepos = UserRepositoryImpl(remoteDataSource: userRemoteDataSource);

  // Initialize data source and repository
  final ProfileRemoteDataSourceImpl dataSourceProfile =
      ProfileRemoteDataSourceImpl(baseUrl: 'https://tawasolapp.me/api');

// Initialize notifications components
  final notificationsRemoteDataSource = NotificationsRemoteDataSourceImpl(baseUrl: 'https://tawasolapp.me/api');
  final notificationsRepository = NotificationRepositoryImpl(notificationDataSource: notificationsRemoteDataSource);
  final getNotificationsUseCase = GetNotificationsUseCase(notificationsRepository);
  final markNotificationAsReadUseCase = MarkNotificationAsReadUseCase(notificationsRepository);
  final getUnseenNotificationsCountUseCase = GetUnseenNotificationsCountUseCase(notificationsRepository);
  final getFcmTokenUseCase = GetFcmTokenUseCase(notificationsRepository);
  final initializeFcmUseCase = InitializeFcmUseCase(notificationsRepository);

  final profileRepository = ProfileRepositoryImpl(
    profileRemoteDataSource: dataSourceProfile,
    // connectionChecker: ConnectionCheckerImpl(internetConnection),
  );
  final useMock = false;
  // ignore: dead_code

  final AuthRemoteDataSource dataSource =
      useMock ? MockAuthRemoteDataSource() : AuthRemoteDataSourceImpl();

  final AuthRepository authRepository = AuthRepositoryImpl(
    dataSource,
    dataSourceProfile,
  );
  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);
  final forgotPassUseCase = ForgotPassUseCase(authRepository);
  final resendEmailUsecase = ResendEmailUsecase(authRepository);
  final updateEmailUsecase = UpdateEmailUsecase(authRepository);
  final deleteAccountUsecase = DeleteAccountUsecase(authRepository);
  final changePasswordUseCase = ChangePasswordUseCase(authRepository);
  final dio = Dio();
  final remoteDataSource = FeedRemoteDataSourceImpl(dio);
  final repository = FeedRepositoryImpl(remoteDataSource: remoteDataSource);

  final getPostsUseCase = GetPostsUseCase(repository);
  final createPostUseCase = CreatePostUseCase(repository);
  final deletePostUseCase = DeletePostUseCase(repository);
  final savePostUseCase = SavePostUseCase(repository);
  final editPostUseCase = EditPostUseCase(repository);
  final commentPostUseCase = CommentPostUseCase(repository);
  final fetchCommentsUseCase = FetchCommentsUseCase(repository);
  final reactToPostUseCase = ReactToPostUseCase(repository);
  final editCommentUseCase = EditCommentUseCase(repository);
  final getPostReactionsUseCase = GetPostReactionsUseCase(repository);
  final unsavePostUseCase = UnsavePostUseCase(repository);
  final getUserPostsUseCase = GetUserPostsUseCase(repository);
  final deleteCommentUseCase = DeleteCommentUseCase(repository);
  final getSavedPostsUsecase = GetSavedPostsUseCase(repository);
  final getPostbyIdUseCase = FetchPostByIdUseCase(repository);
  WebViewPlatform.instance = AndroidWebViewPlatform();

  //////admin
  final adminRemoteDataSource = AdminRemoteDataSource(dio);
  final adminRepository = AdminRepositoryImpl(adminRemoteDataSource);

  runApp(
    MultiProvider(
      providers: [
          ChangeNotifierProvider(
            create: (_) => ConversationListProvider(
             GetConversationsUseCase(MockConversationDataSource())
            )..fetchConversations(), 
          ),

        ChangeNotifierProvider(
          create: (_) => AuthProvider(loginUseCase, forgotPassUseCase),
        ),
        ChangeNotifierProvider(
          create:
              (_) => SettingsProvider(
                changePasswordUseCase,
                updateEmailUsecase,
                deleteAccountUsecase,
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => RegisterProvider(
                registerUsecase: registerUseCase,
                resendEmailUsecase: resendEmailUsecase,
              ),
        ),
ChangeNotifierProvider(
          create: (_) => NotificationsProvider(
            getNotificationsUseCase: getNotificationsUseCase,
            markNotificationAsReadUseCase: markNotificationAsReadUseCase,
            getUnseenNotificationsCountUseCase: getUnseenNotificationsCountUseCase,
            getFcmTokenUseCase: getFcmTokenUseCase,
            initializeFcmUseCase: initializeFcmUseCase,
          )..initialize(),
        ),
        ChangeNotifierProvider(
          create:
              (_) => FeedProvider(
                getPostsUseCase: getPostsUseCase,
                createPostUseCase: createPostUseCase,
                deletePostUseCase: deletePostUseCase,
                savePostUseCase: savePostUseCase,
                editPostUseCase: editPostUseCase,
                commentPostUseCase: commentPostUseCase,
                fetchCommentsUseCase: fetchCommentsUseCase,
                reactToPostUseCase: reactToPostUseCase,
                editCommentUseCase: editCommentUseCase,
                getPostReactionsUseCase: getPostReactionsUseCase,
                unsavePostUseCase: unsavePostUseCase,
                getUserPostsUseCase: getUserPostsUseCase,
                deleteCommentUseCase: deleteCommentUseCase,
                getSavedPostsUseCase: getSavedPostsUsecase,
                fetchPostByIdUseCase: getPostbyIdUseCase,
              ),
        ),

        ChangeNotifierProvider(
          create:
              (_) => ConnectionsProvider(
                GetConnectionsUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                RemoveConnectionUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                GetReceivedConnectionRequestsUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                GetSentConnectionRequestsUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                AcceptIgnoreConnectionRequestUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                SendConnectionRequestUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                WithdrawConnectionRequestUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => NetworksProvider(
                GetFollowingListUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                UnfollowUserUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                GetFollowersListUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                FollowUserUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                GetBlockedListUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                BlockUserUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                UnblockUserUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
                GetPeopleYouMayKnowUseCase(
                  ConnectionsRepositoryImpl(
                    remoteDataSource: ConnectionsRemoteDataSource(
                      client: http.Client(),
                    ),
                  ),
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => ProfileProvider(
                getProfileUseCase: GetProfileUseCase(profileRepository),
                updateProfilePictureUseCase: UpdateProfilePictureUseCase(
                  profileRepository,
                ),
                deleteProfilePictureUseCase: DeleteProfilePictureUseCase(
                  profileRepository,
                ),
                updateCoverPictureUseCase: UpdateCoverPictureUseCase(
                  profileRepository,
                ),
                deleteCoverPhotoUseCase: DeleteCoverPhotoUseCase(
                  profileRepository,
                ),
                updateHeadlineUseCase: UpdateHeadlineUseCase(profileRepository),
                deleteHeadlineUseCase: DeleteHeadlineUseCase(profileRepository),
                updateIndustryUseCase: UpdateIndustryUseCase(profileRepository),
                deleteIndustryUseCase: DeleteIndustryUseCase(profileRepository),
                updateLocationUseCase: UpdateLocationUseCase(profileRepository),
                deleteLocationUseCase: DeleteLocationUseCase(profileRepository),
                updateFirstNameUseCase: UpdateFirstNameUseCase(
                  profileRepository,
                ),
                updateLastNameUseCase: UpdateLastNameUseCase(profileRepository),
                updateResumeUseCase: UpdateResumeUseCase(profileRepository),
                deleteResumeUseCase: DeleteResumeUseCase(profileRepository),
                updateBioUseCase: UpdateBioUseCase(profileRepository),
                deleteBioUseCase: DeleteBioUseCase(profileRepository),
                addExperienceUseCase: AddExperienceUseCase(profileRepository),
                updateExperienceUseCase: UpdateExperienceUseCase(
                  profileRepository,
                ),
                deleteExperienceUseCase: DeleteExperienceUseCase(
                  profileRepository,
                ),
                addEducationUseCase: AddEducationUseCase(profileRepository),
                updateEducationUseCase: UpdateEducationUseCase(
                  profileRepository,
                ),
                deleteEducationUseCase: DeleteEducationUseCase(
                  profileRepository,
                ),
                addCertificationUseCase: AddCertificationUseCase(
                  profileRepository,
                ),
                updateCertificationUseCase: UpdateCertificationUseCase(
                  profileRepository,
                ),
                deleteCertificationUseCase: DeleteCertificationUseCase(
                  profileRepository,
                ),
                addSkillUseCase: AddSkillUseCase(profileRepository),
                updateSkillUseCase: UpdateSkillUseCase(profileRepository),
                deleteSkillUseCase: DeleteSkillUseCase(profileRepository),
                getSkillEndorsementsUseCase: GetSkillEndorsements(
                  profileRepository,
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => EditCompanyDetailsProvider(
                updateCompanyDetails: UpdateCompanyDetails(
                  companyRepository:
                      companyrepos, // Using the existing repository here
                ),
                uploadImageUseCase: UploadImageUseCase(
                  mediaRepository: MediaRepository(
                    mediaRemoteDataSource: MediaRemoteDataSource(),
                  ),
                ),
              ),
        ),
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
        ChangeNotifierProvider(
          create:
              (_) => CompanyAdminsProvider(
                fetchAdminsUseCase: FetchCompanyAdminsUseCase(
                  companyRepository: companyrepos,
                ),
                addAdminUseCase: AddAdminUseCase(repository: userRepos),
                searchUsersUseCase: SearchUsersUseCase(
                  userRemoteDataSource: userRemoteDataSource,
                ),
              ),
        ),

        ChangeNotifierProvider(
          create:
              (_) => CompanyListProvider(
                getAllCompaniesUseCase: GetAllCompaniesUseCase(
                  repository: companyrepos,
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => RelatedCompaniesProvider(
                getRelatedCompaniesUseCase: GetRelatedCompanies(
                  repository: companyrepos,
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => CompanyCreateProvider(
                companyRepository: CompanyRepositoryImpl(
                  remoteDataSource: CompanyRemoteDataSource(),
                ),
                uploadImageUseCase: UploadImageUseCase(
                  mediaRepository: MediaRepository(
                    mediaRemoteDataSource: MediaRemoteDataSource(),
                  ),
                ),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => AdminProvider(
                getReportsUseCase: GetReportsUseCase(adminRepository),
                resolveReportUseCase: ResolveReportUseCase(adminRepository),
                getJobListingsUseCase: GetJobListingsUseCase(adminRepository),
                deleteJobListingUseCase: DeleteJobListingUseCase(
                  adminRepository,
                ),
                getUserAnalyticsUseCase: GetUserAnalyticsUseCase(
                  adminRepository,
                ),
                getPostAnalyticsUseCase: GetPostAnalyticsUseCase(
                  adminRepository,
                ),
                getJobAnalyticsUseCase: GetJobAnalyticsUseCase(adminRepository),
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListPage(type: type)
//   }
// }