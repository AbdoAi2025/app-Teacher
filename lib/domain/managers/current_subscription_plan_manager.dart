import 'package:get/get.dart';
import 'package:teacher_app/base/AppResult.dart';
import 'package:teacher_app/data/responses/current_subscription_plan_response.dart';
import 'package:teacher_app/domain/usecases/get_current_subscription_plan_use_case.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import '../states/current_subscription_plan_state.dart';

/// Singleton manager for handling current subscription plan state
/// Provides observable access to the current subscription plan and manages API calls
class CurrentSubscriptionPlanManager {

  static CurrentSubscriptionPlanManager? _instance;
  static CurrentSubscriptionPlanManager get instance => _instance ??= CurrentSubscriptionPlanManager._internal();

  CurrentSubscriptionPlanManager._internal();

  // Use case for fetching subscription plan
  final GetCurrentSubscriptionPlanUseCase _useCase = GetCurrentSubscriptionPlanUseCase();

  // Observable subscription plan state
  final Rx<CurrentSubscriptionPlanState> _state = Rx<CurrentSubscriptionPlanState>(CurrentSubscriptionPlanInitial());

  // Getters for reactive access
  CurrentSubscriptionPlanState get state => _state.value;
  Rx<CurrentSubscriptionPlanState> get stateRx => _state;

  // Convenience getters for backward compatibility
  CurrentSubscriptionPlanResponse? get currentSubscriptionPlan {
    final currentState = _state.value;
    return currentState is CurrentSubscriptionPlanSuccess ? currentState.data : null;
  }

  Rx<CurrentSubscriptionPlanResponse?> get currentSubscriptionPlanRx {
    final result = Rx<CurrentSubscriptionPlanResponse?>(currentSubscriptionPlan);
    ever(_state, (state) {
      result.value = state is CurrentSubscriptionPlanSuccess ? state.data : null;
    });
    return result;
  }

  bool get isLoading => _state.value is CurrentSubscriptionPlanLoading;

  RxBool get isLoadingRx {
    final result = RxBool(isLoading);
    ever(_state, (state) {
      result.value = state is CurrentSubscriptionPlanLoading;
    });
    return result;
  }

  String? get error {
    final currentState = _state.value;
    return currentState is CurrentSubscriptionPlanError ? currentState.message : null;
  }

  Rx<String?> get errorRx {
    final result = Rx<String?>(error);
    ever(_state, (state) {
      result.value = state is CurrentSubscriptionPlanError ? state.message : null;
    });
    return result;
  }

  /// Convenience getters for common subscription properties
  bool get isSubscribed => currentSubscriptionPlan?.isSubscribed ?? false;
  bool get isExpired => currentSubscriptionPlan?.isExpired ?? false;
  String? get planCode => currentSubscriptionPlan?.planCode;
  String? get planName => currentSubscriptionPlan?.planName;
  int? get studentLimit => currentSubscriptionPlan?.studentLimit;
  int? get totalStudentCount => currentSubscriptionPlan?.totalStudentCount;

  /// Reactive getters for convenience properties
  RxBool get isSubscribedRx {
    final result = RxBool(isSubscribed);
    ever(_state, (state) {
      result.value = state is CurrentSubscriptionPlanSuccess ? state.data.isSubscribed : false;
    });
    return result;
  }

  RxBool get isExpiredRx {
    final result = RxBool(isExpired);
    ever(_state, (state) {
      result.value = state is CurrentSubscriptionPlanSuccess ? state.data.isExpired : false;
    });
    return result;
  }

  /// Fetch the current subscription plan from API
  Future<void> fetchCurrentSubscriptionPlan({bool forceRefresh = false}) async {
    // Skip if already loading (prevent multiple simultaneous calls)
    if (isLoading && !forceRefresh) {
      appLog("CurrentSubscriptionPlanManager: Already loading, skipping fetch");
      return;
    }

    try {
      _state.value = CurrentSubscriptionPlanLoading();
      appLog("CurrentSubscriptionPlanManager: Fetching current subscription plan");

      AppResult<CurrentSubscriptionPlanResponse> result = await _useCase.execute();

      if (result.isSuccess && result.data != null) {
        _state.value = CurrentSubscriptionPlanSuccess(result.data!);
        appLog("CurrentSubscriptionPlanManager: Successfully fetched subscription plan - ${result.data!.planName}");
      } else {
        final errorMessage = result.error?.toString() ?? "Failed to fetch subscription plan".tr;
        _state.value = CurrentSubscriptionPlanError(errorMessage);
        appLog("CurrentSubscriptionPlanManager: Failed to fetch subscription plan - $errorMessage");
      }

    } catch (e) {
      final errorMessage = "Unexpected error: $e";
      _state.value = CurrentSubscriptionPlanError(errorMessage);
      appLog("CurrentSubscriptionPlanManager: Exception occurred - $e");
    }
  }

  /// Refresh the subscription plan data
  Future<void> refresh() async {
    await fetchCurrentSubscriptionPlan(forceRefresh: true);
  }

  /// Clear the current subscription plan data
  void clear() {
    _state.value = CurrentSubscriptionPlanInitial();
    appLog("CurrentSubscriptionPlanManager: Cleared subscription plan data");
  }

  /// Initialize the manager (fetch data on first use)
  Future<void> initialize() async {
    if (currentSubscriptionPlan == null) {
      await fetchCurrentSubscriptionPlan();
    }
  }

  /// Check if the user has reached their student limit
  bool hasReachedStudentLimit() {
    final limit = studentLimit;
    final count = totalStudentCount;

    if (limit == null || count == null) return false;

    return count >= limit;
  }

  /// Get remaining student slots
  int getRemainingStudentSlots() {
    final limit = studentLimit;
    final count = totalStudentCount;

    if (limit == null || count == null) return 0;

    return (limit - count).clamp(0, limit);
  }

  /// Check if subscription is active (subscribed and not expired)
  bool get isActive => isSubscribed && !isExpired;


  /// Update subscription plan data locally (useful after successful payment)
  void updateSubscriptionPlan(CurrentSubscriptionPlanResponse newPlan) {
    _state.value = CurrentSubscriptionPlanSuccess(newPlan);
    appLog("CurrentSubscriptionPlanManager: Updated subscription plan locally - ${newPlan.planName}");
  }

  /// Get current subscription state, fetch if not loaded or in error state
  Future<CurrentSubscriptionPlanState> getCurrentSubscriptionState() async {
    final currentState = _state.value;

    // If data is already successfully loaded, return it
    if (currentState is CurrentSubscriptionPlanSuccess) {
      appLog("CurrentSubscriptionPlanManager: Subscription data already loaded - ${currentState.data.planName}");
      return currentState;
    }

    // If currently loading, wait for completion
    if (currentState is CurrentSubscriptionPlanLoading) {
      appLog("CurrentSubscriptionPlanManager: Currently loading, waiting for completion");
      // Wait for state to change from loading
      await for (final state in stateRx.stream) {
        if (state is! CurrentSubscriptionPlanLoading) {
          appLog("CurrentSubscriptionPlanManager: Loading completed with state: ${state.runtimeType}");
          return state;
        }
      }
    }

    // If initial state or error state, fetch data
    if (currentState is CurrentSubscriptionPlanInitial || currentState is CurrentSubscriptionPlanError) {
      appLog("CurrentSubscriptionPlanManager: State is ${currentState.runtimeType}, fetching data");

      try {
        await fetchCurrentSubscriptionPlan();
        final newState = _state.value;
        appLog("CurrentSubscriptionPlanManager: Fetch completed with state: ${newState.runtimeType}");
        return newState;
      } catch (e) {
        appLog("CurrentSubscriptionPlanManager: Fetch failed with error: $e");
        return CurrentSubscriptionPlanError("Failed to fetch subscription: $e");
      }
    }

    // Fallback - return current state
    return currentState;
  }
}