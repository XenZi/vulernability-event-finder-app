from modules.user.user_schemas import UserRegister
from shared.token import serializer, MAIL_EMAIL, MAIL_PSW
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


def send_activation_token(user: UserRegister):
    print("USAO U SEND ACTIVATION")
    activation_token = serializer.dumps(user.email, salt="acc-activation")
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