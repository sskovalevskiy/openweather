*** Settings ***
Documentation   Day length is more than 12 hours
Resource  resource.robot
Library  RequestsLibrary
Library  Collections
Library  DateTime

*** Test Cases ***
TC_02_Day_Length
    :FOR  ${city}  IN  @{CITIES}
    \   ${response}=  Get Request  Get_Weather  data/2.5/weather?q=${city}&appid=${APP_ID}
    \   ${sys}=  Get From Dictionary  ${response.json()}  sys
    \   ${dict}=  Convert To Dictionary  ${sys}
    \   ${sunrise}=  Get From Dictionary    ${dict}  sunrise
    \   ${sunset}=  Get From Dictionary    ${dict}  sunset
#    Вычисляем длину дня в часах как десятичное число
    \   ${day}=   Evaluate  (${sunset}-${sunrise})/3600.0
#    Уменьшаем точность до двух знаков после запятой
    \   ${day}=   Convert to Number  ${day}  2
#    Если есть хотя бы один город, удовлетворяющий условию - выводим лог в консоль, тест считаем пройденным
    \   Pass Execution If  ${day}>12  City - ${city}. Day Length - ${day}
    Fail  There are NO cities that meet the requirements
