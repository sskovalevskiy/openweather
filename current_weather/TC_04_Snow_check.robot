*** Settings ***
Documentation   It's snowing now
Resource  resource.robot
Library  RequestsLibrary
Library  Collections
Library  DateTime

*** Test Cases ***
TC_04_Snow
    :FOR  ${city}  IN  @{CITIES}
    \   ${response}=  Get Request  Get_Weather  data/2.5/weather?q=${city}&appid=${APP_ID}
    \   ${weather}=  Get From Dictionary  ${response.json()}  weather
#    В возвращенном JSON weather - массив с одним элементом, берем нулевой элемент и конвертируем в словарь
    \   ${dict}=  Convert To Dictionary  ${weather}[0]
    \   ${main}=  Get From Dictionary    ${dict}  main
#    Если есть хотя бы один город, удовлетворяющий условию - выводим лог в консоль, тест считаем пройденным
    \   Pass Execution If  '${main}'=='Snow'  City - ${city}. Snow.
    Fail  There are NO cities that meet the requirements

