from modules.user.user_schemas import UserRegister
from shared.token import serializer, MAIL_EMAIL, MAIL_PSW, SALT
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


def send_activation_token(user: UserRegister):
    """
    Sends an email with an activation link to the user to activate their account.

    This function generates an activation token by serializing the user's email address. 
    The token is embedded in a URL, which is then sent to the user's email address. 
    The email contains a message with the activation link, which the user can click to activate their account.

    Args:
        user (UserRegister): The user to whom the activation email will be sent, containing at least the user's email.

    Returns:
        None: This function does not return a value. It sends an email to the user.

    Example:
        To send an activation email to a user:
        
        user = UserRegister(email="user@example.com", password="securepassword")
        send_activation_token(user)

    Notes:
        - The activation URL is constructed using the local server's base URL (`http://localhost:8000/activate/`).
        - The token is generated using the user's email and a predefined salt (`SALT`).
        - This function assumes the existence of constants like `SALT`, `MAIL_EMAIL`, `MAIL_PSW`, and the `serializer` object.
        - The email is sent using Gmail's SMTP server with SSL encryption.
        - The email contains a link to activate the account, which is valid for a limited time (handled elsewhere in the application).
    """
    print("USAO U SEND ACTIVATION")
    activation_token = serializer.dumps(user.email, salt=SALT)
    activation_url = f"http://localhost:8000/activate/{activation_token}"

    sender_email = MAIL_EMAIL
    sender_password = MAIL_PSW
    recipient_email = user.email

    subject = "Activate your account"
    body = f"Click on the link to activate your account: {activation_url}"

    msg = MIMEMultipart()
    msg["From"] = sender_email
    msg["To"] = recipient_email
    msg["subject"] = subject    
    msg.attach(MIMEText(body))

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, recipient_email, msg.as_string())