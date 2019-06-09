*** Settings ***
Documentation   Current Weather Data API Testcases
Resource        resource.robot
Library  DateTime
Library  Collections
# Для отправки REST запросов используется библиотека RequestsLibrary (https://github.com/bulkan/robotframework-requests)
Library  RequestsLibrary

Test Timeout    2 minutes

#    Создаем сессию
Suite Setup      Create Session  Get_Weather  ${BASE_URL}
Suite Teardown   Delete All Sessions