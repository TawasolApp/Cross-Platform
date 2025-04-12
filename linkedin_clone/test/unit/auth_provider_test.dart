import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/register_usecase.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/resend_email_usecase.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/register_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/authentication/Domain/Entities/user_entity.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/login_usecase.dart';
import 'package:linkedin_clone/features/authentication/Domain/UseCases/forgot_password_usecase.dart';
import 'package:linkedin_clone/features/authentication/Presentation/Provider/auth_provider.dart';

/// ✅ Mock classes
class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockForgotPassUseCase extends Mock implements ForgotPassUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockResendEmailUsecase extends Mock implements ResendEmailUsecase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockForgotPassUseCase mockForgotPassUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockResendEmailUsecase mockResendEmailUsecase;
  late AuthProvider authProvider;
  late RegisterProvider registerProvider;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockForgotPassUseCase = MockForgotPassUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockResendEmailUsecase = MockResendEmailUsecase();
    authProvider = AuthProvider(mockLoginUseCase, mockForgotPassUseCase);
    registerProvider = RegisterProvider(
      registerUsecase: mockRegisterUseCase,
      resendEmailUsecase: mockResendEmailUsecase,
    );
  });

  setUpAll(() {
    registerFallbackValue('fallback@example.com');
  });

  group('AuthProvider login tests', () {
    test('✅ should log in successfully and return true', () async {
      final email = 'test@example.com';
      final password = '123456';
      final user = UserEntity(token: 'mock_token_xyz');

      when(
        () => mockLoginUseCase.call(email, password),
      ).thenAnswer((_) async => Right(user));

      final result = await authProvider.login(email, password);

      expect(result, true);
      expect(authProvider.userEntity?.token, user.token);
      expect(authProvider.isLoading, false);
      expect(authProvider.errorMessage, isNull);

      print('✅ Login success test passed!');
    });

    test('✅ should fail login and return false', () async {
      final email = 'wrong@example.com';
      final password = 'wrongpassword';

      when(
        () => mockLoginUseCase.call(email, password),
      ).thenAnswer((_) async => Left(ServerFailure()));

      final result = await authProvider.login(email, password);

      expect(result, false);
      expect(authProvider.userEntity, isNull);
      expect(authProvider.isLoading, false);

      print('✅ Login failure test passed!');
    });

    test(
      '✅ should send forgot password link successfully and return true',
      () async {
        final email = 'test@example.com';

        when(
          () => mockForgotPassUseCase.call(email),
        ).thenAnswer((_) async => const Right(unit));

        final result = await authProvider.forgotPassword(email);

        expect(result, true);
        expect(authProvider.errorMessage, isNull);

        print('✅ Forgot password success test passed!');
      },
    );

    test('✅ should fail forgot password and return false', () async {
      final email = 'notfound@example.com';

      when(
        () => mockForgotPassUseCase.call(email),
      ).thenAnswer((_) async => Left(ServerFailure()));

      final result = await authProvider.forgotPassword(email);

      expect(result, false);
      expect(authProvider.errorMessage, 'A server error occurred');

      print('✅ Forgot password failure test passed!');
    });

    test('✅ should register successfully and return true', () async {
      final firstName = 'Omar';
      final lastName = 'Kaddah';
      final email = 'newuser@example.com';
      final password = 'password123';
      final token = 'mock_token_xyz';

      when(
        () => mockRegisterUseCase.call(
          firstName,
          lastName,
          email,
          password,
          'mock-captcha',
        ),
      ).thenAnswer((_) async => Right(UserEntity(token: token)));

      final result = await registerProvider.register(
        firstName,
        lastName,
        email,
        password,
        'mock-captcha',
      );

      expect(result, true);

      print('✅ Register success test passed!');
    });

    test('✅ should resend verification email successfully', () async {
      final email = 'test@example.com';
      final type = 'verifyEmail';
      when(
        () => mockResendEmailUsecase.call(email, type),
      ).thenAnswer((_) async => const Right(unit));

      final result = await registerProvider.resendVerificationEmail(
        email,
        type,
      );

      expect(result, true);

      print('✅ Resend verification email test passed!');
    });

    test('✅ should fail to resend verification email', () async {
      final email = 'notfound@example.com';
      final type = 'verifyEmail';
      when(
        () => mockResendEmailUsecase.call(email, type),
      ).thenAnswer((_) async => Left(ServerFailure()));

      final result = await registerProvider.resendVerificationEmail(
        email,
        type,
      );

      expect(result, false);

      print('✅ Resend verification email failure test passed!');
    });
  });
}
