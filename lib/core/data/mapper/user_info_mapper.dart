import 'package:chat_wave/core/data/db/entity/friend.dart';
import 'package:chat_wave/core/data/network/dto/user_info_dto.dart';
import 'package:chat_wave/core/domain/model/user_info.dart';

extension Mapper on UserInfoDto {
  UserInfo toUserInfo() {
    return UserInfo(
      name: name,
      username: username,
      profilePicUrl: profilePicUrl,
      id: id,
    );
  }

  FriendEntity toFriendEntity() {
    return FriendEntity(
      id: id,
      name: name,
      username: username,
      profilePicUrl: profilePicUrl,
    );
  }
}
