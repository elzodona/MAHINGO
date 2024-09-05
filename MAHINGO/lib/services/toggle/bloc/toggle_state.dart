part of 'toggle_bloc.dart';


class ToggleState extends Equatable {
  final bool isFirstPasswordObscured;
  final bool isSecondPasswordObscured;

  const ToggleState({
    this.isFirstPasswordObscured = true,
    this.isSecondPasswordObscured = true,
  });

  ToggleState copyWith({
    bool? isFirstPasswordObscured,
    bool? isSecondPasswordObscured,
  }) {
    return ToggleState(
      isFirstPasswordObscured:
          isFirstPasswordObscured ?? this.isFirstPasswordObscured,
      isSecondPasswordObscured:
          isSecondPasswordObscured ?? this.isSecondPasswordObscured,
    );
  }

  @override
  List<Object?> get props =>
      [isFirstPasswordObscured, isSecondPasswordObscured];
}


// abstract class ToggleState extends Equatable {
//   const ToggleState();

//   @override
//   List<Object> get props => [];
// }

// class ToggleInitialState extends ToggleState {
//   final bool isOn;

//   const ToggleInitialState(this.isOn);

//   @override
//   List<Object> get props => [
//     isOn
//   ];
// }
