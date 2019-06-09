*** Settings ***
Documentation   Visibility is above 300m & wind speed is less than 20m/s
Resource  resource.robot
Library  RequestsLibrary
Library  Collections
Library  DateTime

*** Test Cases ***
TC_03_Good_Conditions
    :FOR  ${city}  IN  @{CITIES}
    \   ${response}=  Get Request  Get_Weather  data/2.5/weather?q=${city}&appid=${APP_ID}
    \   ${visibility}=  Get From Dictionary  ${response.json()}  visibility
    \   ${wind}=  Get From Dictionary  ${response.json()}  wind
    \   ${dict}=  Convert To Dictionary  ${wind}
    \   ${speed}=  Get From Dictionary    ${dict}  speed
#    Если есть хотя бы один город, удовлетворяющий условию - выводим лог в консоль, тест считаем пройденным
    \   Pass Execution If  (${visibility}>300) & (${speed}<20)  City - ${city}. Good Conditions.
    Fail  There are NO cities that meet the requirements