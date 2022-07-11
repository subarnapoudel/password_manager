import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:password_manager/data/models/pass_model.dart';
import 'package:password_manager/data/repositories/pass_repository.dart';

part 'pass_event.dart';
part 'pass_state.dart';

class PassBloc extends Bloc<PassEvent, PassState> {
  final PassRepository _passRepo;
  PassBloc(this._passRepo) : super(PassInitial()) {
    on<PassLoadEvent>(_passLoadEvent);
    on<PassAddEvent>(_passAddEvent);
    on<PassUpdateEvent>(_passUpdateEvent);
    on<PassDeleteEvent>(_passDeleteEvent);
  }

  Future<void> _passLoadEvent(
      PassLoadEvent event, Emitter<PassState> emit) async {
    print("Pass load event called");
    await _passRepo.init();
    emit(PassLoadedState(await _passRepo.getData()));
  }

  Future<void> _passAddEvent(
      PassAddEvent event, Emitter<PassState> emit) async {
    print("Pass add event called");
    emit(PassInitial());
    _passRepo.saveData(event.pass);
    emit(PassLoadedState(await _passRepo.getData()));
  }

  void _passUpdateEvent(PassUpdateEvent event, Emitter<PassState> emit) async {
    print("Pass update event called");
    emit(PassInitial());
    _passRepo.updateData(event.id, event.pass);
    emit(PassLoadedState(await _passRepo.getData()));
  }

  void _passDeleteEvent(PassDeleteEvent event, Emitter<PassState> emit) async {
    print("Pass delete event called");
    emit(PassInitial());
    _passRepo.deleteData(event.id);
    emit(PassLoadedState(await _passRepo.getData()));
  }
}