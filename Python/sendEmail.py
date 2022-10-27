# function to call & send email from within python script 
import smtplib 
from email.message import EmailMessage 

def emailSend(Host=None, From=None, To=None, Subject=None, Message=None, Signature=None):
    """
    Function to send an email from within a python script, to a list of provided emails

    params:
        host - host to push the email through 
        from - the sender email address
        to - list of email addresses to be sent the mail
        subject - subject header you would like email to have 
        message - the body of text to be in the email 
        signature - the sign off for the email 

    returns:
        an output email to designated addresses within 'to' list 
    """
    msg = EmailMessage() 
    msg['Subject'] = Subject 
    msg['From'] = From 
    msg['To'] = To 
    msg.set_content(Message + "\n" + Signature) 

    # push email
    smtplib.SMTP(Host).send_message(msg) 
    smtplib.SMTP(Host).quit() 

