import 'package:app/cubits/profile/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> fetchUserProfile() async {
    emit(ProfileLoading());
    try {
      await Future.delayed(const Duration(seconds: 2), () {});
      const name = 'John Doe';
      const email = 'john.doe@example.com';
      emit(ProfileLoaded(name: name, email: email));
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> logout() async {
    emit(ProfileInitial());
  }
}
