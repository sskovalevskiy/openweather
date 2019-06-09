*** Settings ***
Documentation   Humidity is above 75% and pressure above 770 mm Hg
Resource  resource.robot
Library  RequestsLibrary
Library  Collections
Library  DateTime

*** Test Cases ***
TC_05_Humidity_and_Pressure
    :FOR  ${city}  IN  @{CITIES}
    \   ${response}=  Get Request  Get_Weather  data/2.5/weather?q=${city}&appid=${APP_ID}
    \   ${main}=      Get From Dictionary  ${response.json()}  main
    \   ${dict}=      Convert To Dictionary  ${main}
    \   ${humidity}=  Get From Dictionary    ${dict}  humidity
    \   ${pressure}=  Get From Dictionary    ${dict}  pressure
#    Конвертируем значение в hPa в мм.рт.ст.
    \   ${pressure}=  Evaluate  ${pressure}*100/133.321995
#    Если есть хотя бы один город, удовлетворяющий условию - выводим лог в консоль, тест считаем пройденным
    \   Pass Execution If  (${humidity}>75) & (${pressure}>770)  City - ${city}. Humidity - ${humidity}, pressure - ${pressure}.
    Fail  There are NO cities that meet the requirements