*** Settings ***
Documentation   Current temperature is above 25C
Resource  resource.robot
Library  RequestsLibrary
Library  Collections
Library  DateTime

*** Test Cases ***
TC_01_Temperature
#    В цикле для каждого города получаем JSON с текущей погодой
    :FOR  ${city}  IN  @{CITIES}
    \   ${response}=  Get Request  Get_Weather  data/2.5/weather?q=${city}&appid=${APP_ID}&units=metric
#    Парсим JSON, берем значение температуры в данном городе
    \   ${main}=  Get From Dictionary  ${response.json()}  main
    \   ${dict}=  Convert To Dictionary  ${main}
    \   ${temp}=  Get From Dictionary    ${dict}  temp
#    Если есть хотя бы один город, удовлетворяющий условию - выводим лог в консоль, тест считаем пройденным
    \   Pass Execution If  ${temp}>25  City - ${city}. Temperature - ${temp}
#    Если цикл завершен и тест не пройден - Fail
    Fail  There are NO cities that meet the requirements