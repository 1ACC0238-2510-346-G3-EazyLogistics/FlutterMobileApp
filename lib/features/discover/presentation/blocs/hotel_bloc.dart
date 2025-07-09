import 'package:LogisticsMasters/features/discover/data/repositories/hotel_repository.dart';
import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';
import 'package:LogisticsMasters/features/discover/presentation/blocs/hotel_event.dart';
import 'package:LogisticsMasters/features/discover/presentation/blocs/hotel_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HotelBloc extends Bloc<HotelEvent, HotelState> {
  final HotelRepository repository;

  HotelBloc({required this.repository}) : super(InitialHotelState()) {
    on<GetHotels>((event, emit) async {
      emit(LoadingHotelState());
      try {
        List<Hotel> hotels = await repository.getHotels();
        emit(LoadedHotelState(hotels: hotels));
      } catch (e) {
        emit(FailureHotelState(errorMessage: e.toString()));
      }
    });
  }
}