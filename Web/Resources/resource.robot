*** Settings ***
Library    SeleniumLibrary
Library    ImapLibrary2
Library    String

*** Variables ***
${Browser}   Chrome
${BASE URL}    https://www.ralali.com/
${button_login}   //a[@href='/login']
${text_register}   //a[text()="Daftar"]
${card_individu}   //div[@data-testid='card-Individu']
${input_fullname}   //input[@id='fullname']
${input_username}   //input[@id='username']
${input_password}   //input[@data-testid='input-password']
${input_password_confirm}   //input[@data-testid='input-password-confirmation']
${checkbox_register}   //span[@class='RegisterForm__Checkbox-sc-1ofjgrt-5 mgNsT']//span
${button_register}   //button[@data-testid='button-submit']
${verif_email}   //div[@data-testid='channel-email']
${IMAP_HOST}          imap.gmail.com
${IMAP_PORT}          993
${to_EMAIL}              henafrozen@gmail.com
${from_EMAIL}     noreply@ralali.com
${PASSWORD}   yfkg qpqq kcll hdha
${OTP_PATTERN}        \\d{6}
${OTP_SUBJECT}   Kode OTP Ralali untuk Anda

*** Keywords ***
User Open Browser To Ralali
    Set Selenium Timeout    25s
    Open Browser    ${BASE URL}   ${Browser}
    Maximize Browser Window

User Click Button Login
    Wait Until Element Is Enabled    ${button_login}
    Click Element    ${button_login}
    Click Element    ${text_register}  

User Complete Form Register
    Wait Until Element Is Enabled    ${card_individu}
    Click Element    ${card_individu}
    Input Text    ${input_fullname}    QA Engineer
    Input Text    ${input_username}    henafrozen@gmail.com
    Page Should Contain Textfield   ${input_fullname}
    Page Should Contain Textfield    ${input_username}
    Input Text    ${input_password}    Aabnshsf12^
    Input Text    ${input_password_confirm}    Aabnshsf12^
    Scroll Element Into View   ${checkbox_register}
    Click Element   ${checkbox_register}
    Scroll Element Into View    ${button_register}
    Click Element    ${button_register}

Fetch OTP from Email
    Wait Until Element Is Visible    ${verif_email}
    Click Element    ${verif_email}
    Set Selenium Timeout    50s
    Open Mailbox    host=imap.gmail.com    user=${to_EMAIL}  password=${PASSWORD}    is_secure=True    ssl=993   folder=Inbox
    Log    Successfully opened mailbox.

Get OTP From Email
    Open Mailbox    server=imap.gmail.com    user=henafrozen@gmail.com    password=${PASSWORD}
    ${LATEST}=    Wait For Email    fromEmail=${from_EMAIL}    toEmail=${to_EMAIL}    subject=${OTP_SUBJECT}
    ${email_body} =    Get Email Body    ${LATEST}
    ${otp} =    Run Keyword If    'text/plain' in ${email_body}    or    'text/html' in ${email_body}    Extract OTP from Text    ${email_body}
    Input Text    //div[@class='Flex__StyledFlex-sc-1gmkxa6-0 kfGXIa']/input[@data-testid='otp-input-1']    ${otp}

Extract OTP from Text
    [Arguments]    ${text}
    ${matches} =    Get Regexp Matches    ${text}    ${OTP_PATTERN}
    [Return]    ${matches[0][0]}
