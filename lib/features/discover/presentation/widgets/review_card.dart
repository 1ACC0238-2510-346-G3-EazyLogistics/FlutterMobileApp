import 'package:LogisticsMasters/features/discover/domain/entities/hotel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewCard extends StatelessWidget {
  final HotelReview review;
  
  const ReviewCard({
    super.key,
    required this.review,
  });

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto de perfil
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(review.profilePicture),
                ),
                const SizedBox(width: 12),
                
                // Columna con username, estrellas y fecha
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username
                      Text(
                        review.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Estrellas
                      Row(
                        children: [
                          ...List.generate(
                            review.rating,
                            (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
                          ),
                          ...List.generate(
                            5 - review.rating,
                            (index) => const Icon(Icons.star_border, color: Colors.amber, size: 16),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Fecha
                      Text(
                        _formatDate(review.ratingDate),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Comentario
            const SizedBox(height: 12),
            Text(
              review.comment,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}