import 'package:LogisticsMasters/features/discover/data/repositories/hotel_repository.dart';
import 'package:LogisticsMasters/features/discover/presentation/blocs/search_event.dart';
import 'package:LogisticsMasters/features/discover/presentation/blocs/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final HotelRepository repository;
  
  SearchBloc({required this.repository}) : super(InitialSearchState()) {
    on<SearchHotelsEvent>(_onSearchHotels);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchHotels(
      SearchHotelsEvent event, Emitter<SearchState> emit) async {
    emit(LoadingSearchState());
    
    try {
      final query = event.query.trim();
      
      if (query.isEmpty) {
        emit(InitialSearchState());
        return;
      }
      
      final results = await repository.searchHotels(query);
      
      if (results.isEmpty) {
        emit(NoResultsSearchState(query: query));
      } else {
        emit(LoadedSearchState(hotels: results, query: query));
      }
    } catch (e) {
      emit(ErrorSearchState(message: e.toString()));
    }
  }

  Future<void> _onClearSearch(
      ClearSearchEvent event, Emitter<SearchState> emit) async {
    emit(InitialSearchState());
  }
}