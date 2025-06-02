
import 'session_details_ui_state.dart';

class UpdateSessionActivitiesState {}

class UpdateSessionActivitiesStateLoading extends UpdateSessionActivitiesState{}
class UpdateSessionActivitiesStateSuccess extends UpdateSessionActivitiesState{
}
class UpdateSessionActivitiesStateError extends UpdateSessionActivitiesState{
  final Exception? exception;
  UpdateSessionActivitiesStateError(this.exception);
}
