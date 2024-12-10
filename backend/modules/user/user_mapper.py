from modules.user.user_schemas import User, UserDTO



def user_to_DTO(user: User) -> UserDTO:
    return UserDTO(
            id=user.id,
            email=user.email,
            isActive=user.isActive,
            creationDate=user.creationDate
        )

def userList_to_DTOList(users: list[User]) -> list[UserDTO]:
    result: list[UserDTO] = []
    for u in users:
        result.append(user_to_DTO(u))
    return result