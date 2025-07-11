import 'package:LogisticsMasters/features/bookings/domain/book_item.dart';

class BookItemRequestDto {
  final String? id;
  final int hotelId;
  final int userId;
  final String? hotelName;
  final String? hotelImage;
  final String? location;
  final String checkInDate;
  final String checkOutDate;
  final int adults;
  final int children;
  final int infants;
  final double? pricePerNight;
  final int nights;
  final double? discount;
  final double? taxes;
  final double? totalPrice;
  final String? paymentMethod;
  final bool isPaid;
  final String? bookingDate;
  final String? status;

  BookItemRequestDto({
    this.id,
    required this.hotelId,
    required this.userId,
    this.hotelName,
    this.hotelImage,
    this.location,
    required this.checkInDate,
    required this.checkOutDate,
    required this.adults,
    required this.children,
    required this.infants,
    this.pricePerNight,
    required this.nights,
    this.discount,
    this.taxes,
    this.totalPrice,
    this.paymentMethod,
    required this.isPaid,
    this.bookingDate,
    this.status,
  });

  // Convertir a JSON para API
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': int.tryParse(id!) ?? id,
      'hotelId': hotelId,
      'userId': userId,
      if (hotelName != null) 'hotelName': hotelName,
      if (hotelImage != null) 'hotelImage': hotelImage,
      if (location != null) 'location': location,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'adults': adults,
      'children': children,
      'infants': infants,
      if (pricePerNight != null) 'pricePerNight': pricePerNight,
      'nights': nights,
      if (discount != null) 'discount': discount,
      if (taxes != null) 'taxes': taxes,
      if (totalPrice != null) 'totalPrice': totalPrice,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      'isPaid': isPaid,
      if (bookingDate != null) 'bookingDate': bookingDate,
      if (status != null) 'status': status,
    };
  }

  // Crear desde un BookItem
  factory BookItemRequestDto.fromDomain(BookItem booking, String userId) {
    return BookItemRequestDto(
      id: booking.id,
      hotelId:
          int.tryParse(booking.hotelId) ??
          (throw Exception('Invalid hotelId: ${booking.hotelId}')),
      userId:
          int.tryParse(userId) ?? (throw Exception('Invalid userId: $userId')),
      hotelName: booking.hotelName,
      hotelImage: booking.hotelImage,
      location: booking.location,
      checkInDate: booking.checkInDate.toIso8601String(),
      checkOutDate: booking.checkOutDate.toIso8601String(),
      adults: booking.adults,
      children: booking.children,
      infants: booking.infants,
      pricePerNight: booking.pricePerNight,
      nights: booking.nights,
      discount: booking.discount,
      taxes: booking.taxes,
      totalPrice: booking.totalPrice,
      paymentMethod: booking.paymentMethod,
      isPaid: booking.isPaid,
      bookingDate: booking.bookingDate.toIso8601String(),
      status: "confirmed",
    );
  }
}
