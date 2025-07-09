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
    return BookItemDto(
      id: json['id'] != null ? json['id'].toString() : null,
      hotelId: json['hotelId'],
      userId: json['userId'],
      hotelName: json['hotelName'],
      hotelImage: json['hotelImage'],
      location: json['location'],
      checkInDate: json['checkInDate'],
      checkOutDate: json['checkOutDate'],
      adults: json['adults'],
      children: json['children'],
      infants: json['infants'],
      pricePerNight: json['pricePerNight'],
      nights: json['nights'],
      discount: json['discount'] ?? '0',
      taxes: json['taxes'],
      totalPrice: json['totalPrice'],
      paymentMethod: json['paymentMethod'],
      isPaid: json['isPaid'],
      bookingDate: json['bookingDate'],
      status: json['status'],
    );
  }

  BookItem toDomain() {
    return BookItem(
      id: this.id,
      hotelId: this.hotelId,
      hotelName: this.hotelName,
      hotelImage: this.hotelImage,
      location: this.location,
      checkInDate: DateTime.parse(this.checkInDate),
      checkOutDate: DateTime.parse(this.checkOutDate),
      adults: int.parse(this.adults),
      children: int.parse(this.children),
      infants: int.parse(this.infants),
      pricePerNight: double.parse(this.pricePerNight),
      nights: int.parse(this.nights),
      discount: double.parse(this.discount),
      taxes: double.parse(this.taxes),
      totalPrice: double.parse(this.totalPrice),
      paymentMethod: this.paymentMethod,
      isPaid: this.isPaid.toLowerCase() == 'true',
      bookingDate: DateTime.parse(this.bookingDate),
      status: this.status,
    );
  }
}