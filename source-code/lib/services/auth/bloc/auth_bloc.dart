import 'package:fatiel/enum/user_role.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fatiel/services/auth/auth_provider.dart';
import 'package:fatiel/services/auth/bloc/auth_event.dart';
import 'package:fatiel/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    on<AuthEventShouldRegister>(((event, emit) {
      emit(const AuthStateRegistering(exception: null, isLoading: false));
    }));
    on<AuthEventVisitorRegister>(((event, emit) {
      emit(
          const AuthStateVisitorRegistering(exception: null, isLoading: false));
    }));
    on<AuthEventHotelRegister>(((event, emit) {
      emit(const AuthStateHotelRegistering(exception: null, isLoading: false));
    }));

    on<AuthEventHotelRegistering>((event, emit) async {
      emit(const AuthStateHotelRegistering(exception: null, isLoading: false));
      final email = event.email;
      final password = event.password;
      final hotelName = event.hotelName;

      emit(const AuthStateHotelRegistering(
        exception: null,
        isLoading: true,
      ));

      try {
        await provider.createHotel(
          email: email,
          password: password,
          hotelName: hotelName,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthStateHotelRegistering(
          exception: e,
          isLoading: false,
        ));
      }
    });
    on<AuthEventVisitorRegistering>((event, emit) async {
      emit(
          const AuthStateVisitorRegistering(exception: null, isLoading: false));
      final email = event.email;
      final password = event.password;
      final firstName = event.firstName;
      final lastName = event.lastName;

      emit(const AuthStateVisitorRegistering(
        exception: null,
        isLoading: true,
      ));

      try {
        await provider.createVisitor(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthStateVisitorRegistering(
          exception: e,
          isLoading: false,
        ));
      }
    });

    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: false,
      ));
      final email = event.email;
      if (email == null) {
        return;
      } else {
        emit(const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: true,
        ));
        bool didSendEmail;
        Exception? exception;
        try {
          await provider.sendPasswordReset(email: email);
          didSendEmail = true;
          exception = null;
        } on Exception catch (e) {
          didSendEmail = false;
          exception = e;
        }
        emit(AuthStateForgotPassword(
          exception: exception,
          hasSentEmail: didSendEmail,
          isLoading: false,
        ));
      }
    });
    on<AuthEventInitialize>(((event, emit) async {
      await provider.firebaseIntialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else {
        if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          if (user.role == UserRole.hotel) {
            emit(AuthStateHotelLoggedIn(
              user: user,
              isLoading: false,
            ));
          } else {
            emit(AuthStateVisitorLoggedIn(
              user: user,
              isLoading: false,
            ));
          }
        }
      }
    }));
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(
        exception: null,
        isLoading: true,
        loadingText: 'Please wait while i log you in',
      ));
      //  emit(const AuthStateLoading());
      final email = event.email;
      final password = event.password;

      try {
        // Very good idea
        // await Future.delayed(const Duration(seconds: 3));
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        if (!user!.isEmailVerified) {
          emit(const AuthStateNeedsVerification(
            isLoading: false,
          ));
        } else {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ));

          if (user.role == UserRole.hotel) {
            emit(AuthStateHotelLoggedIn(
              user: user,
              isLoading: false,
            ));
          } else {
            emit(AuthStateVisitorLoggedIn(
              user: user,
              isLoading: false,
            ));
          }
        }
      } on Exception catch (exception) {
        emit(
          AuthStateLoggedOut(
            exception: exception,
            isLoading: false,
          ),
        );
      }
    });
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (exception) {
        emit(
          AuthStateLoggedOut(
            exception: exception,
            isLoading: false,
          ),
        );
      }
    });
  }
}
