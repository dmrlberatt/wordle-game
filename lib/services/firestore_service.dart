import '../core/models.dart';

class FirestoreService {
  // TODO: İleride FirebaseFirestore.instance.collection('rooms') ile değiştirilecek.
  
  Future<String> createRoom(String hostId, String hostName, Language lang) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Network delay simülasyonu
    return "123456"; // Rastgele 6 haneli kod üretilecek
  }

  Future<bool> joinRoom(String code, String playerId, String playerName) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Kod doğruysa true
  }

  Future<void> updatePlayerGuesses(String roomCode, String playerId, List<List<LetterStatus>> guesses) async {
    // Firestore'a pushlanacak: doc(roomCode).update({'players.$playerId.guesses': guesses})
  }

  Stream<Room?> listenToRoom(String code) {
    // Firestore snapshot stream'i buraya gelecek
    return Stream.empty(); 
  }
}
