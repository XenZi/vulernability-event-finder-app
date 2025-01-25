from modules.user.user_schemas import User, UserDTO

def user_to_DTO(user: User) -> UserDTO:
    return UserDTO(
            id=user.id or 0,
            email=user.email,
            is_active=user.is_active,
            creation_date=user.creation_date,
            fcm_token=user.fcm_token
        )

def userList_to_DTOList(users: list[User]) -> list[UserDTO]:
    result: list[UserDTO] = []
    for u in users:
        result.append(user_to_DTO(u))
    return result