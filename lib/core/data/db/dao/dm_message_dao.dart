import 'package:chat_wave/core/data/db/entity/dm_message.dart';
import 'package:floor/floor.dart';

@dao
abstract class DmMessageDao {
  @insert
  Future<void> insertDmMessage(DmMessageEntity message);

  @update
  Future<void> updateDmMessage(DmMessageEntity message);

  @Query('DELETE FROM DmMessageEntity WHERE id = :id')
  Future<void> deleteById(String id);

  @transaction
  Future<void> completeReplace(
    String provisionalId,
    DmMessageEntity message,
  ) async {
    await deleteById(provisionalId);
    insertDmMessage(message);
  }

  @Query(
      'SELECT * FROM DmMessageEntity WHERE sender_id = :friendId OR receiver_id = :friendId ORDER BY timestamp DESC')
  Stream<List<DmMessageEntity>> watchDmsFrom(int friendId);
}