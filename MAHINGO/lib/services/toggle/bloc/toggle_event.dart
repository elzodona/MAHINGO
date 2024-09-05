part of 'toggle_bloc.dart';


abstract class ToggleEvent extends Equatable {
  const ToggleEvent();

  @override
  List<Object?> get props => [];
}

class ToggleFirstPasswordVisibility extends ToggleEvent {}

class ToggleSecondPasswordVisibility extends ToggleEvent {}


// abstract class ToggleEvent extends Equatable {
//   const ToggleEvent();

//   @override
//   List<Object> get props => [];
// }

// class ToggleSubmitEvent extends ToggleEvent { 

// }

