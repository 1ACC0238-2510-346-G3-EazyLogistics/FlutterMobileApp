
import 'package:LogisticsMasters/features/discover/data/datasources/hotel_service.dart';
import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';
import 'package:LogisticsMasters/features/discover/presentation/blocs/hotel_event.dart';
import 'package:LogisticsMasters/features/discover/presentation/blocs/hotel_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HotelBloc extends Bloc<HotelEvent, HotelState> {
  HotelBloc() : super(InitialHotelState()) {
    on<GetHotels>((event, emit) async {
      emit(LoadingHotelState());
      try {
        List<Hotel> hotels = await HotelService().fetchHotels();
        emit(LoadedHotelState(hotels: hotels));
      } catch (e) {
        emit(FailureHotelState(errorMessage: e.toString()));
      }
    });
  }
}