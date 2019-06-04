*** Settings ***
Documentation   Current Weather Data Testcases
Library         Collections
# Для отправки REST запросов используется библиотека RequestsLibrary (https://github.com/bulkan/robotframework-requests)
Library         RequestsLibrary

*** Variables ***
${BASE_URL}  http://api.openweathermap.org
${APP_ID}    5b323e4eb997b071cadf67df05d2f4e7
@{CITIES}    London  Moscow  #Baku  Yerevan  Brussels  Budapest  Odessa  Osaka  Ottawa  Oslo  Potsdam  Sydney  Kugaaruk  Plymouth

*** Test Cases ***
TC_01_Temperature
#    Создаем сессию
    Create Session  Get_Weather  ${BASE_URL}
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
    Fail  "There are NO cities that meet the requirements"

TC_02_Day_Length
    Create Session  Get_Weather  ${BASE_URL}
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
    Fail  "There are NO cities that meet the requirements"

TC_03_Good_Conditions
    Create Session  Get_Weather  ${BASE_URL}
    :FOR  ${city}  IN  @{CITIES}
    \   ${response}=  Get Request  Get_Weather  data/2.5/weather?q=${city}&appid=${APP_ID}
    \   ${visibility}=  Get From Dictionary  ${response.json()}  visibility
    \   ${wind}=  Get From Dictionary  ${response.json()}  wind
    \   ${dict}=  Convert To Dictionary  ${wind}
    \   ${speed}=  Get From Dictionary    ${dict}  speed
#    Если есть хотя бы один город, удовлетворяющий условию - выводим лог в консоль, тест считаем пройденным
    \   Pass Execution If  (${visibility}>300) & (${speed}<20)  City - ${city}. Good Conditions.
    Fail  "There are NO cities that meet the requirements"

TC_04_Snow
    Create Session  Get_Weather  ${BASE_URL}
    :FOR  ${city}  IN  @{CITIES}
    \   ${response}=  Get Request  Get_Weather  data/2.5/weather?q=${city}&appid=${APP_ID}
    \   ${weather}=  Get From Dictionary  ${response.json()}  weather
#    В возвращенном JSON weather - массив с одним элементом, берем нулевой элемент и конвертируем в словарь
    \   ${dict}=  Convert To Dictionary  ${weather}[0]
    \   ${main}=  Get From Dictionary    ${dict}  main
#    Если есть хотя бы один город, удовлетворяющий условию - выводим лог в консоль, тест считаем пройденным
    \   Pass Execution If  '${main}'=='Snow'  City - ${city}. Snow.
    Fail  "There are NO cities that meet the requirements"

TC_05_Humidity_and_Pressure
    Create Session  Get_Weather  ${BASE_URL}
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
    Fail  "There are NO cities that meet the requirements"