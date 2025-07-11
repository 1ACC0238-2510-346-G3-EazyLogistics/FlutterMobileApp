import 'package:LogisticsMasters/features/bookings/domain/book_item.dart';

class BookItemDto {
  final String? id;
  final String hotelId;
  final String userId;
  final String hotelName;
  final String hotelImage;
  final String location;
  final String checkInDate;
  final String checkOutDate;
  final String adults;
  final String children;
  final String infants;
  final String pricePerNight;
  final String nights;
  final String discount;
  final String taxes;
  final String totalPrice;
  final String paymentMethod;
  final String isPaid;
  final String bookingDate;
  final String status;

  BookItemDto({
    this.id,
    required this.hotelId,
    required this.userId,
    required this.hotelName,
    required this.hotelImage,
    required this.location,
    required this.checkInDate,
    required this.checkOutDate,
    required this.adults,
    required this.children,
    required this.infants,
    required this.pricePerNight,
    required this.nights,
    required this.discount,
    required this.taxes,
    required this.totalPrice,
    required this.paymentMethod,
    required this.isPaid,
    required this.bookingDate,
    required this.status,
  });

  factory BookItemDto.fromJson(Map<String, dynamic> json) {
    // Helper function para convertir de manera segura a String
    String safeToString(dynamic value, [String defaultValue = '']) {
      if (value == null) return defaultValue;
      return value.toString();
    }

    return BookItemDto(
      id: safeToString(json['id']),
      hotelId: safeToString(json['hotelId']),
      userId: safeToString(json['userId']),
      hotelName: safeToString(json['hotelName']),
      hotelImage: safeToString(json['hotelImage']),
      location: safeToString(json['location']),
      checkInDate: safeToString(json['checkInDate']),
      checkOutDate: safeToString(json['checkOutDate']),
      adults: safeToString(json['adults'], '0'),
      children: safeToString(json['children'], '0'),
      infants: safeToString(json['infants'], '0'),
      pricePerNight: safeToString(json['pricePerNight'], '0'),
      nights: safeToString(json['nights'], '0'),
      discount: safeToString(json['discount'], '0'),
      taxes: safeToString(json['taxes'], '0'),
      totalPrice: safeToString(json['totalPrice'], '0'),
      paymentMethod: safeToString(json['paymentMethod']),
      isPaid: safeToString(json['isPaid'], 'false'),
      bookingDate: safeToString(json['bookingDate']),
      status: safeToString(json['status'], 'confirmed'),
    );
  }

  BookItem toDomain() {
    return BookItem(
      id: id,
      hotelId: hotelId,
      hotelName: hotelName.isNotEmpty ? hotelName : 'Unknown Hotel',
      hotelImage: hotelImage.isNotEmpty ? hotelImage : '',
      location: location.isNotEmpty ? location : 'Unknown Location',
      checkInDate: checkInDate.isNotEmpty
          ? DateTime.parse(checkInDate)
          : DateTime.now(),
      checkOutDate: checkOutDate.isNotEmpty
          ? DateTime.parse(checkOutDate)
          : DateTime.now().add(Duration(days: 1)),
      adults: int.tryParse(adults) ?? 1,
      children: int.tryParse(children) ?? 0,
      infants: int.tryParse(infants) ?? 0,
      pricePerNight: double.tryParse(pricePerNight) ?? 0.0,
      nights: int.tryParse(nights) ?? 1,
      discount: double.tryParse(discount) ?? 0.0,
      taxes: double.tryParse(taxes) ?? 0.0,
      totalPrice: double.tryParse(totalPrice) ?? 0.0,
      paymentMethod: paymentMethod.isNotEmpty ? paymentMethod : 'Unknown',
      isPaid: isPaid.toLowerCase() == 'true',
      bookingDate: bookingDate.isNotEmpty
          ? DateTime.parse(bookingDate)
          : DateTime.now(),
      status: status.isNotEmpty ? status : 'confirmed',
    );
  }
}
