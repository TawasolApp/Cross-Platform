import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/premium/domain/usecases/cancel_use_case.dart';
import 'package:linkedin_clone/features/premium/domain/usecases/subscribe_to_premium_plan_usecase.dart';
import 'package:linkedin_clone/features/premium/presentations/provider/premium_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'premium_provider_test.mocks.dart';

@GenerateMocks([SubscribeToPremiumPlanUseCase, CancelUseCase])
void main() {
  late PremiumProvider provider;
  late MockSubscribeToPremiumPlanUseCase mockSubscribe;
  late MockCancelUseCase mockCancel;

  const testPaymentUrl = 'https://payment.example.com/checkout';

  setUp(() {
    mockSubscribe = MockSubscribeToPremiumPlanUseCase();
    mockCancel = MockCancelUseCase();

    provider = PremiumProvider(
      subscribeToPremiumPlanUseCase: mockSubscribe,
      cancelUseCase: mockCancel,
    );
  });

  test('initial values are correct', () {
    expect(provider.optionSelected, false);
  });

  group('Subscription', () {
    test('optionSelected updates correctly', () {
      provider.optionSelected = true;
      expect(provider.optionSelected, true);
    });

    test('subscribeToPremiumPlan returns URL on success', () async {
      when(
        mockSubscribe.call(any, any),
      ).thenAnswer((_) async => testPaymentUrl);

      final result = await provider.subscribeToPremiumPlan(true, true);
      expect(result, testPaymentUrl);
      verify(mockSubscribe.call(true, true)).called(1);
    });

    test('subscribeToPremiumPlan returns null on error', () async {
      when(mockSubscribe.call(any, any)).thenThrow(Exception('Payment failed'));

      final result = await provider.subscribeToPremiumPlan(false, false);
      expect(result, null);
    });

    test('subscribeToPremiumPlan handles all parameter combinations', () async {
      when(
        mockSubscribe.call(any, any),
      ).thenAnswer((_) async => testPaymentUrl);

      // Test all combinations of isYearly and autoRenewal
      await provider.subscribeToPremiumPlan(true, true);
      await provider.subscribeToPremiumPlan(true, false);
      await provider.subscribeToPremiumPlan(false, true);
      await provider.subscribeToPremiumPlan(false, false);

      verify(mockSubscribe.call(true, true)).called(1);
      verify(mockSubscribe.call(true, false)).called(1);
      verify(mockSubscribe.call(false, true)).called(1);
      verify(mockSubscribe.call(false, false)).called(1);
    });
  });

  group('Cancellation', () {
    test('cancelSubscription returns true on success', () async {
      when(mockCancel.call()).thenAnswer((_) async => true);

      final result = await provider.cancelSubscription();
      expect(result, true);
    });

    test('cancelSubscription returns false on error', () async {
      when(mockCancel.call()).thenThrow(Exception('Cancellation failed'));

      final result = await provider.cancelSubscription();
      expect(result, false);
    });
  });
}
