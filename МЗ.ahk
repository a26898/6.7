buildscr = 10_5 ;
downlurl := "https://github.com/a26898/7.7/blob/main/Demo_7_8.exe?raw=true"
downllen := "https://raw.githubusercontent.com/a26898/7.7/main/verlen.ini"

Utf8ToAnsi(ByRef Utf8String, CodePage = 1251)
{
    If (NumGet(Utf8String) & 0xFFFFFF) = 0xBFBBEF
        BOM = 3
    Else
        BOM = 0

    UniSize := DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
                    , "UInt", &Utf8String + BOM, "Int", -1
                    , "Int", 0, "Int", 0)
    VarSetCapacity(UniBuf, UniSize * 2)
    DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
                    , "UInt", &Utf8String + BOM, "Int", -1
                    , "UInt", &UniBuf, "Int", UniSize)

    AnsiSize := DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
                    , "UInt", &UniBuf, "Int", -1
                    , "Int", 0, "Int", 0
                    , "Int", 0, "Int", 0)
    VarSetCapacity(AnsiString, AnsiSize)
    DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
                    , "UInt", &UniBuf, "Int", -1
                    , "Str", AnsiString, "Int", AnsiSize
                    , "Int", 0, "Int", 0)
    Return AnsiString
}
WM_HELP(){
    IniRead, vupd, %a_temp%/verlen.ini, UPD, v
    IniRead, desupd, %a_temp%/verlen.ini, UPD, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/verlen.ini, UPD, upd
    updupd := Utf8ToAnsi(updupd)
    msgbox, , Список изменений версии %vupd%, %updupd%
    return
}

OnMessage(0x53, "WM_HELP")
Gui +OwnDialogs

SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nПроверяем наличие обновлений.
URLDownloadToFile, %downllen%, %a_temp%/verlen.ini
IniRead, buildupd, %a_temp%/verlen.ini, UPD, build
if buildupd =
{
    SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОшибка. Нет связи с сервером.
    sleep, 2000
}
if buildupd > % buildscr
{
    IniRead, vupd, %a_temp%/verlen.ini, UPD, v
    SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОбнаружено обновление до версии %vupd%!
    sleep, 2000
    IniRead, desupd, %a_temp%/verlen.ini, UPD, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/verlen.ini, UPD, upd
    updupd := Utf8ToAnsi(updupd)
    SplashTextoff
    msgbox, 16384, Обновление скрипта до версии %vupd%, %desupd%
    IfMsgBox OK
    {
        msgbox, 1, Обновление скрипта до версии %vupd%, Хотите ли Вы обновиться?
        IfMsgBox OK
        {
            put2 := % A_ScriptFullPath
            RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\SAMP ,put2 , % put2
            SplashTextOn, , 60,Автообновление, Обновление. Ожидайте..`nОбновляем скрипт до версии %vupd%!
            URLDownloadToFile, %downlurl%, %a_temp%/updt.exe
            sleep, 1000
            run, %a_temp%/updt.exe
            exitapp
        }
    }
}
SplashTextoff


TrayTip , МЗ, Вступайте в нашу группу вконтакте https://vk.com/mzahk, Seconds, Options

Gui, show, center h530 w500,
Gui, Font, S10   Bold
Gui, Add, Picture, x0 y30 w1300 h700, C:\Program Files (x86)\МЗ\AHK_1.jpg
Gui, Add, Tab2, x0 y0 w1300 h25 cFF2400  +BackgroundTrans, Введите данные
Gui, Add, DropDownList,  x210 y60 vJWI,  Интерн|Фельдшер|Врач-Участковый|Врач-Терапевт|Врач-Хирург|Парамедик|Старший Специалист|Заведующая Отделением|Заведующий Отделением|Заместитель Главного Врача|Главный врач
Gui, Add, Edit, vTAG, 
Gui, Add, Edit, vName,
Gui, Add, Edit, vSurname,
Gui, Add, Edit, vMiddle_Name,
Gui, Add, DropDownList, vBol, ОКБ. г.Мирный|ЦГБ г.Невский|ЦГБ г.Приволжск
Gui, Add, Edit, vDelay,
Gui, Add, Edit, vFast, 
Gui, Add, DropDownList, vPartner, Напарник:
Gui, Add, Edit, vPartner_Name_surname,
Gui, Add, Button, gJens, Женский
Gui, Add, Button, gMujs, Мужской
Gui, Add, Button, y430  default xm, Применить




Gui, Add, Text, x10 y65  w300 h20 cFF2400  +BackgroundTrans , Звание:_________________
Gui, Add, Text, x10 y95  w300 h20 cFF2400  +BackgroundTrans , Тег: ___________________
Gui, Add, Text, x10 y127 w300 h20 cFF2400 +BackgroundTrans , Имя: ____________________
Gui, Add, Text, x10 y157 w300 h20 cFF2400 +BackgroundTrans , Фамилия:_______________
Gui, Add, Text, x10 y187 w300 h20 cFF2400 +BackgroundTrans , Отчество: ______________
Gui, Add, Text, x10 y217 w300 h20 cFF2400 +BackgroundTrans , Название больницы: _____
Gui, Add, Text, x10 y247 w300 h20 cFF2400 +BackgroundTrans , Задержка:______________
Gui, Add, Text, x10 y277 w300 h20 cFF2400 +BackgroundTrans , Пост:___________________
Gui, Add, Text, x10 y307 w300 h20 cFF2400 +BackgroundTrans , Напарник:_______________
Gui, Add, Text, x10 y337 w300 h20 cFF2400 +BackgroundTrans , Имя Фамилия напарника:_
Gui, Add, Text,  x10 y367 w300 h20 cFF2400 +BackgroundTrans, Пол____________________
Gui, Add, Text,  x10 y397 w300 h20 cFF2400 +BackgroundTrans, Пол____________________

Gui, Add, Text, x10 y480 w1220 h20 c000000   +BackgroundTrans,   Задержка рекомендуется 2000/3000.
Gui, Add, Text, x10 y500 w1220 h20 c000000   +BackgroundTrans,   Если у Вас есть напарник, заполните поля.

Jens:
Floor = а
Female = ла
return

Mujs:
Floor =
Female =
return


;--------------------------------------------------------------------------------

!1:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, Здравствуйте, я лечащий врач, %Name% %Surname%.{enter}
SendInput, {F6}
sleep %delay%
SendInput, /do На груди висит бейдж: "%Bol%, %JWI% | %TAG% | %Surname% %Name% %Middle_Name%". {enter}
SendInput, {F6}
sleep %delay%
SendInput, Чем-то могу помочь? {enter}
SendInput, {F6}
sleep 200
SendInput, /timestamp {enter}
return

!2:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,  Хорошо, пройдёмте за мной .{enter}
return


!3:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,  Хорошо, сейчас я осмотрю вас. {enter}
SendInput, {F6}
sleep %delay%
SendInput,  /me осмотрел%floor% пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me подумав, сделал%floor% соответствующие выводы о состоянии пациента {enter}
return


!4:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do В грудном кармане бланк выписки и ручка. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достал%floor% бланк, ручку и записал%floor% диагноз с лекарством {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Бланк выписки заполнен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, / do На плече висит мед.сумка с нашивкой "%Bol%".{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor% сумку, после чего достал%floor% из неё нужное лекарство {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Лекарство и бланк в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me передал%floor% лекарство и бланк пациенту  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Лекарство и бланк переданы. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /helpmed{space}
return


!5:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,Всего доброго, не болейте! {enter}
return


!6:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Хорошо, вы можете пройти лечение бесплатно в стационаре нашей больницы, проходите в палату. {enter}
return


!7:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do На груди висит сумка с надписью "%Bol%".   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыв сумку, резким движением взял%floor% миг и использовал таблетку по назначению  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Таблетка подействовала.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /helpmed{space}
return



!8:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 750
SendInput, /do Рация от мегафона на панели автомобиля. {enter}
SendInput, {F6}
sleep 750
SendInput, /me снял%floor% рацию с панели и сказал%floor% в неё {enter}
SendInput, {F6}
sleep 750
SendInput, /s {#}ffff00[Мегафон] Водители{!} Уступаем дорогу карете скорой помощи{!} {enter}
return

!9:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 500
SendInput, /me взглянул%floor% на часы "%Bol% с фирменной гравировкой В моем сердце" {Enter}
m = 60
m -= %A_Min%
s = 60
s -= %A_Sec%
sleep 500
SendInput, {F6}
sleep 500
SendInput, /do Время на часах: %A_Hour%:%A_Min%:%A_Sec% | Дата : %A_DD%.%A_MM%.%A_YYYY% | .{enter}
SendInput, {F6}
sleep 250
SendInput, /paytime {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}
Return

!0:: 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 250
SendInput, /do На поясе висит рация. {enter}
SendInput, {F6}
sleep 250
SendInput /me сняв рацию начал%floor% что то говорить в нее {enter}
return


!Numpad1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 250
SendInput, /me повесил%floor% рацию обратно на пояс {enter}
SendInput, {F6}
sleep 250
SendInput /do Рация на поясе. {enter}
return

!Numpad2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 521
SendInput, /r [%TAG%] Разрешите, отехать на 30 минут по личным делам? {enter}
return

!Numpad3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 250
SendInput, /r [%TAG%] Разрешаю. {enter}
return

!Numpad4::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 250
SendInput, /r [%TAG%] Отказано. {enter}
return

!Numpad5::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me  взял%floor% мед.диплом {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% изучение  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me передал%floor% мед.диплом человеку напротив {enter}
return



!Numpad6::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% паспорт из рук человека  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me раскрыл%floor% паспорт, затем начал%floor% его изучение  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыл%floor% паспорт, затем передал%floor% его владельцу  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

!Numpad7::
SendInput, {F6}
sleep  %delay%
SendInput, Дайте, пожалуйста, свою медицинскую карту.  {enter}
return

!Numpad8::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% медицинскую карту  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor% медицинскую карту и изучил%floor%  её {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me поставил%floor% штамп в графе годности {enter}
SendInput, {F6}
sleep 250
SendInput, /me отдал%floor% медицинскую карту человеку напротив  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /goden   {space}
return


!Numpad9::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, /r [%TAG%] Взял%floor% перерыв{!}  {enter}
return

!Numpad0::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, /r [%TAG%] Сдал%floor% смену{!} {enter}
return

:?:/Пост::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%]  Разрешите, выехать на пост:[%Fast%]? %Partner%%Partner_Name_surname% {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Выехал::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%]  Выехал%floor% на пост:[%Fast%] %Partner%%Partner_Name_surname%. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Дежурство::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%]  Пост [%Fast%].%Partner%%Partner_Name_surname% Состояние стабильное, вылечено: [ {space}
return

:?:/Окончил::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Окончил%floor% дежурство поста [%Fast%]. Еду на базу %Partner%%Partner_Name_surname%. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Город::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Разрешите, выехать на патрулирование города. %Partner%%Partner_Name_surname%. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Патрулирование::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Выехал%floor% на патрулирование города %Partner% %Partner_Name_surname%. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Патрул::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Патрулирование города. %Partner%%Partner_Name_surname% Состояние стабильное, вылечено:[ {space}
return

:?:/Еду::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Окончил%floor% патрулирование города. Еду на базу %Partner%%Partner_Name_surname%.  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Принял::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Принял%floor% %Partner%%Partner_Name_surname% Вызов: {space}
return

:?:/Место::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Прибыл%floor% %Partner%%Partner_Name_surname% Вызов: {space}
return

:?:/Ложный::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] %Partner%%Partner_Name_surname% Ложный вызов:    {space}
return

:?:/Госпитализация::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Госпитализация%Partner%%Partner_Name_surname% Вызов:  {space}
return

:?:/Помощь::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Помощь оказана на месте %Partner%%Partner_Name_surname% Вызов: {space}
return

:?:/ВЦГБ::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Госпитализирован %Partner%%Partner_Name_surname% Вызов:  {space}
return

:?:/ЦГБ::
SendInput, {F6}
sleep %delay%
SendInput, /r [%TAG%] Сдал%floor% АСМП %Partner%%Partner_Name_surname%. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Карта_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
Sendinput, /me взял%floor% мед.карту  {Enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me положил%floor%  мед.карту на стол  {Enter}
return

:?:/Карта_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput,  {F6}
Sleep 100
Sendinput, /do На столе лежит мед.карта и ручка.         {Enter}
SendInput,  {F6}
sleep  %delay%
Sendinput, /me взял%floor%  мед.карту и ручку         {Enter}
SendInput,  {F6}
sleep  %delay%
Sendinput, /me заполнил%floor%  мед.карту       {Enter}
SendInput,  {F6}
sleep  %delay%
Sendinput, /me отдал%floor%  мед.карту          {Enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/КПК::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do Звук КПК: "Внимание{!} Поступление вызова{!}". {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достал%floor%  из кармана КПК, запустил%floor%  его {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открывает базу поступивших вызовов {enter}
SendInput, {F6}
sleep 250
SendInput, /me фиксирует последние данные GPS пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыл%floor%  и убрал%floor%  КПК в карман  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/АСМП_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me нажал%floor%  на кнопку для опускания каталки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me аккуратно приподнял%floor%  человека и переложил%floor%  на каталку   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me нажал%floor%  на кнопку для, поднятия каталки   {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/АСМП_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do Рация на поясе. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me сняв рацию с пояса, вызвал%floor%  через неё дежурного врача {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Дежурный врач, подошёл к АСМП.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me передал%floor%  каталку с пациентом дежурному врачу  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/АСМП_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do Каталка с пострадавшим в приёмном отделении. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me повез%female% каталку в операционную {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Каталка с пострадавшим у операционного стола. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me нажал%floor% на кнопку для опускания каталки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me аккуратно приподнял%floor% человека, и переложил%floor% на кушетку {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me сложил%floor% и убрал%floor% каталку {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/ЭКГ_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do Электрокардиограф стоит у стены.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me подкатил%floor% электрокардиограф к пациенту {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% медицинский спирт со стола и открыл%floor% его {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обезжирил%floor% электроды на приборе, и поставил%floor% спирт на стол {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Гель "Синтакт" лежит в шкафу.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% гель Синтакт и смазал электроды  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me поставил%floor% гель на стол {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% обработанные электроды и прикрепил%floor% их к телу пациента  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me подключил%floor% электроды к электрокардиографу и включил%floor% его {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me запустил%floor% прибор  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Электрокардиограф записывает график ЭКГ.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me остановил%floor% запись, и выключил прибор {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% электроды с тела пациента, и положил%floor%  их на стол {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me изучил%floor% график и поставил%floor% диагноз {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor%, что фибрилляция пациента снизилась {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/ЭКГ_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,   У Вас проблемы с сердцем.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Обратитесь к своему врачу-терапевту, он вам выпишет направление.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Принимайте "Кардиомагнил", 1 таблетку под язык раз в неделю для профилактики. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Одну пачку этого лекарства я выпишу вам прямо сейчас. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  Стоит он 450 рублей, Вы согласны? {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/ЭКГ_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,  Не волнуйтесь, с сердцем у Вас всё хорошо.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput,   Принимайте "Кардиомагнил", 1 таблетку раз в день для профилактики.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Одну упаковку этого лекарства я выпишу вам прямо сейчас. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  Стоит он 450 рублей, Вы согласны? {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Шприц::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do Препараты лежат на стеллаже.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достал%floor% ампулу  и шприц {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me набрал%floor% в шприц содержимое ампулы  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me протер%female% место укола спиртовой салфеткой {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me медленно вводит препарат в вену пациента  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me приложил%floor% вату к месту укола {enter}   
SendInput, {F6}
sleep  %delay%
SendInput, Ватку держите 5 минут, потом выбросите в урну. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return


:?:/Вакцинация::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,  /do На столе лежит всё необходимое для вакцинации.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% ватный диск и спирт {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me смочил%floor% ватный диск в спирте {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /me продезинфицировал%floor% место введения вакцины  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выкинул%floor% ватный диск в урну {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% одноразовую иглу, и новый одноразовый шприц {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% иглу на шприц  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% пробирку с вакциной   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me наполнил%floor% шприц вакциной  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me убрал%floor% лишний воздух из шприца {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me ввёл%floor% иглу в дельтовидную мышцу пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me ввёл%floor% вакцину {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me вынул%floor% иглу {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me придавил%floor% место прокола заранее приготовленной ваткой в спирте {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Держите ватку так не менее 5-ти минут. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Зонд_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /do На столе лежит урогенитальный зонд. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% урогенитальный зонд со стола {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Сейчас, будет немного неприятно, потерпите {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me ввёл%floor% урогенитальный зонд в уретру пациента {enter} 
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% пробу с внутренней стенки уретры {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достал%floor% урогенитальный зонд из уретры человека {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе стоит микробиологический анализатор. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me опустил%floor% урогенитальный зонд в анализатор {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включил%floor% микробиологический анализатор {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me запустил%floor% процесс диагностики мазка  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor%, проблемы {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return

:?:/Зонд_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, К сожалению, у Вас имеется шанс заболевания венерическим заболеванием. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Как можно скорее обратитесь к своему лечащему врачу{!} {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Можете одеваться и спускаться вниз. {enter}
SendInput, {F6}
sleep 200
SendInput, /timestamp {enter} {F12}
return

:?:/Зонд_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Всё хорошо. Вы здоровы. Можете одеваться. {enter}
SendInput, {F6}
sleep 200
SendInput, /timestamp {enter} {F12}
return


:?:/Кровь::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do Рядом стоит аппарат наркоза. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me подключил%floor% апппрпт наркоза к пациенту  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рядом стоит стол.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежат перчатки. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% перчатки   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% перчатки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола вату и Йодонат {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me смочил%floor% вату йодонатом  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% обрабатывать область груди {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежит скальпель.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% скальпель  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me сделал%floor% надрез в области грудной клетки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me делает разрезы мышц и жира {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обнаружил%floor% легие и кровеносные сосуды  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обнаружил%floor% повреждённый сосуд {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% нитки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% перекрывать поврежденный сосуд нитками  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежит катетер. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% катетер в руки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% выкачивать кровь из полости плевры {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежат игла и нитки.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% нитки и иглу {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начинает зашивать разрезанные мышцы {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me зашивает кожу на груди {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% ватку и раствор {enter} 
SendInput, {F6}
sleep  %delay%
SendInput, /me смочил%floor% вату  йодовым раствором {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обрабатывает швы {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor%  хирургический пластырь в руки{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me накладывает хирургический пластырь на швы {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отключил%floor%  аппарат наркоза {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отсоеденил%floor%  аппарат наркоза от пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return


:?:/Рентген_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Присаживайтесь. Кладите ногу/руку вот сюда, и не двигайтесь. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включает рентген аппарат  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me фиксирует сустав в нужном положении  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Не двигайтесь.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выполнил%floor% снимок  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выключает рентген аппарат  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достав снимок из аппарата, рассматривает его {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил перелом на снимке  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me откладывает снимок на тумбочку  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return


:?:/Рентген_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, У Вас, перелом. Необходимо наложить лангетку. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor%  лангетку со стола, и наложил%floor%  на место перелома пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрепил%floor%  лангетку, на месте перелома {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  Приходите через неделю на повторный осмотр{!} {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return


:?:/Рентген_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, У Вас, перелом. Я наложу Вам гипс. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Стол и стул для перевязки у окна. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  Пересядьте вот сюда.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me указал%floor% на стул {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыв шкаф, достал%floor% тазик и гипс  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me положив гипс на раковину и открыв кран, набирает воду в тазик {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыв кран и поставив тазик на пол, погрузил%floor% в него гипс для размачивания {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достаёт гипс из тазика  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me накладывает гипс  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Подождём немного, пока застынет. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me щупает гипс {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достав бинты, накладывает их поверх гипса  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Готово. Гипс не мочите две недели. Через две недели жду Вас, на осмотр.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Если будет болеть, то пейте обезболивающее. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Рентген_4::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,  У Вас сильный ушиб. Я, наложу вам эластичный бинт. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Препараты лежат на стеллаже. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стеллажа гель {enter}
SendInput, {F6}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыв гель, смазывает место ушиба  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыв гель, кладёт его на тумбочку  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Вот гель, заберёте его потом.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Мед. сумка висит на плече.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достав%female% из мед.сумки эластичный бинт, накладывает его {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  Бинт носите одну неделю. Гелем мажьте в течение недели, каждый день: утром и вечером.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, Перед нанесением геля, снимите бинт, затем нанесите гель, {enter}
SendInput, {F6}
sleep  %delay%
SendInput, подождите 3 минуты, и снова забинтуйте. {enter}
return

:?:/Донор::
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% донора за руку {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me берет клеенчатый валик {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me подкладывает клеёнчатый валик под локоть донора {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me фиксирует руку донора ладонью к верху {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me берет пробирку, и иглу с переходником с мед.лотка {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me присоединяет пробирку к игле {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me кладет собранную систему в мед.лоток {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Система лежит в мед.лотке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me берет жгут и спиртовую салфетку с мед.лотка {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обрабатывает спиртовой салфеткой область локтевого сгиба, на руке донора {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me затягивает жгут на плече донора {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Сожмите, пожалуйста кулак{!} {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me берет из мед.лотка собранную систему {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me вводит иглу в вену {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снимает жгут с плеча донора {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Можете разжать руку{!} {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me медленно оттягивает поршень шприца вверх {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me прикладывает спиртовую салфетку к месту прокола {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выводит иглу из вены {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отсоединяет пробирку от иглы {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе стоит держатель для пробирок. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me помещает пробирку в держатель для пробирок {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me кладет использованную иглу в мед.лоток {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Спасибо за донорство{!} {enter}
return

:?:/Мрт::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Здравствуйте, сейчас Вам необходимо лечь на выдвижной стол МРТ. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включает аппарат МРТ  {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /do Аппарат включен. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включает сканирование {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Идет сканирование... {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отключает сканирование {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /do Сканирование отключено. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Все, можете одеваться, результаты будут обработаны в течении 2-3 дней. {enter}
return

:?:/Нож::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me осмотрел%floor% рану больного {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола давящую повязку, и наложил%floor% её сверху ранения {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола перекись водорода и ватку, и обработал%floor% место ранения {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола шприц с обезбаливающим, и сделал%floor% укол  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола иголку с нитью и продел%floor% её  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me аккуратно зашил%floor% рану, и обрезал%floor% концы нити {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% зелёнку со стола и обработал%floor% место ранения  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% бинт со стола, и перевязал%floor% место ранения {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% давящую повязку, и положил%floor% её на стол {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Нос::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
Sendinput, /do Медицинская сумка на правом плече.  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me снял%floor% сумку с плеча, и поставил на землю  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me открыл%floor% сумку  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do В правом отделении сумки, лежит вата и бутылка с перекисью водорода.  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me достал%floor% перекись водорода и вату из сумки  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me смочил%floor% вату перекисью водорода  {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me поднес%female% ватку к ноздре пострадавшего  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Желудк::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,  /do На столе лежит зонд, и раствор чистой воды.{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% зонд и раствор воды  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начинает промывание желудка {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me вытащил%floor% трубку зонда, и убрал%floor% инструменты {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Всего доброго, не болейте{!} {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Аппендикс::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me одел%floor% стерильные перчатки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола шприц с обезбаливающим, и сделал%floor% укол {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /do Около койки стоит аппарат для наркоза.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% кислородную маску {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me надел%floor% маску на пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включил%floor% аппарат для наркоза {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% скальпель со стола, и сделал%floor% надрез {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выделил%floor% орган аппендикса щипцами, и удалил%floor% его скальпелем {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обработал полость {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола иглу с нитью и продел%floor% её {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me аккуратно зашил%floor%  рану, и обрезал%floor%  концы нити {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% зелёнку со стола, и обработал%floor%  место ранения {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor%  бинт со стола, и перевязал%floor%  место ранения {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выключил%floor% аппарат для наркоза {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /me снял%floor% маску с пациента {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, Отдыхайте, и соблюдайте диету всего доброго. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Грудь::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /d﻿o У стены стоит шкаф. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor% шкаф {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На верхней полке лежат перчатки. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% перчатки с полки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% перчатки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыл%floor% шкаф  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% маркер со стола {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отметил%floor% места для надрезов  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me положил%floor% маркер на стол  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% шприц с обезболивающим со стола {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me вколол%floor% обезболивающее в плечо пациента{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Около койки стоит аппарат для наркоза. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% кислородную маску {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% маску на пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включил%floor% аппарат для наркоза {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% скальпель со стола {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me сделал%floor% надрезы по линиям {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежат силиконовые импланты. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% силиконовые импланты {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me аккуратно вставил%floor% импланты в надрезы﻿ {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола дезинфицирующие тампоны {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обработал%floor% места надрезов {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% иголку с нитью со стола {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me зашил%floor% надрезы {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% ножницы со стола {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обрезал%floor% нить﻿ {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола обработанные зеленкой ватные тампоны {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me обработал%floor% швы зеленкой {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% стерильную эластичную повязку со стола {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me перевязал%floor% пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выключил%floor% аппарат для наркоза {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% маску с пациента﻿ {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Прибор_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput,{F6}
sleep  %delay%
Sendinput, /do В углу комнаты, стоит аппарат для компьютерной томографии.  {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput,  Ложитесь, пожалуйста на стол.  {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput,  Не двигайтесь{!}   {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, /me задвинул%floor% стол в прибор   {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, /me включил%floor% сканирование на аппарате   {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, /me выключил%floor% сканирование на аппарате    {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, /me изучает снимок     {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, /me изучил%floor% снимок     {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, /try обнаружил, проблемы  {Enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Прибор_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput,{F6}
sleep  %delay%
Sendinput, /do На снимке обнаружены отклонения.  {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, Есть небольшие отклонения, но ничего опасного. {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput, Вам, необходимо придерживаться режима сна, и специальной диеты.  {Enter}
return


:?:/Прибор_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput,{F6}
sleep  %delay%
Sendinput, /do На снимке не обнаружено отклонений. {Enter}
SendInput,{F6}
sleep  %delay%
Sendinput,  Все хорошо. Ваш мозг не поврежден{!}  {Enter}
return

:?:/УЗИ::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% гель со стола и открыл%floor% его {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me выдавил%floor% гель на живот пациента и растёр%female% его {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыл%floor% тюбик с гелем, и поставил%floor% на стол {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Возле койки стоит аппарат УЗИ. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включил%floor% аппарат УЗИ, и взял%floor% датчик с аппарата {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me провел%floor% датчиком по животу, и изучил%floor% результаты {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закончил%floor% осмотр, и положил%floor% датчик. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Датчик УЗИ на аппарате. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% салфетки со стола, и передал%floor% их пациенту {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/Пуля::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me осмотрел%floor% ранение {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Сейчас, вытащим пулю. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола стерильные перчатки и надел%floor% их {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола перекись водорода и ватку  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /me обработал%floor% кожу, вокруг ранения  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола шприц с обезболивающим, и сделал%floor% укол  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола щипцы, и аккуратно достал%floor% пулю  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола иглу с нитью и продел%floor% её {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me аккуратно зашил%floor% рану, и обрезал%floor% концы нити {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% зелёнку со стола, и обработал %floor%место ранения  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Аппарат::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Раздевайтесь по пояс. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Вот, подходите к аппарату, и грудью прижмитесь к синему квадрату. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  Так, хорошо, приготовьтесь к снимку. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включил%floor% аппарат {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Глубоко вдохните и не дышите.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me сделал%floor% снимок  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Все, можете одеваться. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выключил%floor% аппарат {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return



:?:/Чувства_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /todo Проверим, есть ли пульс*подставив%Female% два пальца к сонной артерии пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput,/try обнаружил%floor% пульс на сонной артерии {enter}
return

:?:/Чувства_2::
SendInput, {F6}
sleep  %delay%
SendInput, Всё в порядке, пульс есть{!} {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Через плечо надета мед.сумка с медицинскими препаратами. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыв сумку, достал%floor%  нашатырный спирт и ватку {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me смочив вату спиртом, приложил%floor% ее к носу пострадавшего {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me убрав спирт в сумку, закрыл%floor% ее {enter}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Чувства_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me запрокинул%floor% голову пациента{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% одежду в которую одет пациент  {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me наложил%floor% маску на лицо {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% делать непрямой массаж сердца {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% делать искусственное дыхание "рот-в-рот" пациенту  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me поднес%female% руку к сонной артерии пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor% пульс на сонной артерии {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Чувства_4::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% делать непрямой массаж сердца {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% делать искусственное дыхание "рот-в-рот" пациенту  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me поднес%female% руку к сонной артерии пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor% пульс на сонной артерии {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Чувства_5::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me убирает маску с лица в сумку {enter}
return



:?:/Алкоголь_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do Через плечо надета мед. сумка с медицинскими препаратами. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,/me открыв сумку, достал%floor%  алкотестер и одноразовый мундштук {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /todo Сейчас проверим Вас на алкоголь*присоединив%female% мундштук к прибору {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me набрав воздух в алкотестер из окружающей среды, сделал%floor% тестовое включение прибора   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, do На приборе появилась надпись "Алкоголь не обнаружен". {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Всё в порядке, прибор работает. Можем приступать к проверке. {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  Дыхните, пожалуйста. {enter}


:?:/Алкоголь_2::
SendInput, {F6}
sleep  %delay%
SendInput,  do Алкотестер, закончив проверку, распечатал%floor%  чеки с информацией о пациенте. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /todo Сейчас посмотрим на результаты теста*взглянув%female% на чеки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Какой уровень алкоголя в крови проверяемого?   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Алкоголь_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Гражданин, у Вас слишком высокий уровень алкоголя в крови. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Ожидайте сотрудников МВД для дальнейшей проверки.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отделив мундштук от алкотестера, выбросил%floor% его в урну {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выключив алкотестер, убрал%floor% его в сумку  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Алкоголь_4::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,  Всё хорошо, алкоголь не был найден в Вашем организме. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me оторвал%floor% один из чеков с результатами теста и передал%floor% его пациенту  {enter}
SendInput, {F6}
sleep  %delay%
SendInput,   Всего доброго, не нарушайте{!}  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do У двери СМП/У стены стоит урна.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отделив мундштук от алкотестера, выбросил%floor%  его в урну  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выключив алкотестер, убрал%floor% его в сумку  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return


:?:/ФКС_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Здравствуйте. Сейчас, я проведу Вам, колоноскопию. {enter}
SendInput, {F6}
sleep  %delay% 
SendInput, Раздевайтесь. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежат стерильные перчатки. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% перчатки в руки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% перчатки {enter} 
SendInput, {F6}
sleep  %delay%
SendInput, /do На стойке висит эндоскоп. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% эндоскоп со стойки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% смазку в руку {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me смазал%floor% эндоскоп смазкой {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me поставил%floor% смазку на стол {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% вводить эндоскоп в ректальное отверстие пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% визуальный осмотр состояния прямой кишки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor%, отклонения {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% вынимать эндоскоп из ректального отверстия пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Эндоскоп вынут. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me положил%floor%  эндоскоп в аппарат для дезинфекции {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Эндоскоп в аппарате для дезинфекции. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return

:?:/ФКС_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, К сожалению, у Вас есть некоторые заболевания прямой кишки. Советую обратиться к врачу. {enter}
SendInput, {F6}
return

:?:/ФКС_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, К счастью, с Вашей прямой кишкой всё в порядке{!} {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Можете одеваться и спускаться. {enter}
SendInput, {F6}
sleep 500
SendInput, /timestamp {enter} {F12}
return

:?:/Вши_1::
SendMessage, 0x50,, 0x4090409,, A 
SendInput, {F6}
sleep  %delay%
SendInput, /do В правом кармане одноразовые перчатки.    {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me достал%floor% из правого кармана перчатки   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me одел%floor% перчатки на руки   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Хорошо, сейчас я Вас осмотрю.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me осматривает голову пациента   {enter}
SendInput, {F6}
sleep  %delay%
SendInput,/try обнаружил%floor%, вши {enter}
return

:?:/Вши_2::
SendMessage, 0x50,, 0x4090409,, A 
SendInput, {F6}
sleep  %delay%
SendInput, У Вас обнаружены вши{!} {enter}
return

:?:/Вши_3::
SendMessage, 0x50,, 0x4090409,, A 
SendInput, {F6}
sleep  %delay%
SendInput, У Вас, не обнаружено вшей, Вы можете быть свободны.   {enter}
return

:?:/Открытый::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,  Итак, приступим. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do В углу стоит хирургический стол.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% жгут со стола и наложил%floor% его выше места перелома  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% шприц с обезбаливающим со стола  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me ввёл%floor% обезболивающее в ногу пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me проталкнул%floor% кость во внутрь  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% иглу в руки, продел%floor% в неё нить {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me зашил%floor% ранение  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отложил%floor% нить с иглой на стол   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% бинты со стола и перевязал %floor%ранение  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% дрель со стола подключил%floor% её к розетке  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включил%floor% дрель и сделал%floor% тонкие прорезы сквозь ногу  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me продел%floor% в ногу спицы {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me наложил%floor% на каждую спицу вату с двух сторон, прижав пробкой  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Два кольца лежат на столе. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% кольца {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor% кольца и наложил%floor% их   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыл%floor% кольца {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% палки и продел%floor% их сквозь отверстия колец  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me наложил%floor% палки и зафиксировал%floor% их гайками  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Ожоги::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
Sendinput, /do Медицинская сумка на плече. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me снял%floor% сумку с плеча и поставил%floor% на тумбочку {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me нащупал%floor% стерильные перчатки и взял%floor% их в руку {enter}
SendInput, {F6}
sleep  %delay% 
Sendinput, /me достал%floor% из стерильные перчатки из сумки {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me надел%floor% перчатки на руки {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me осмотрел%floor% пациента {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me освободил%floor% место ожога от одежды {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me сделал%floor% оценку площади и глубины ожога {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do Бутылка с холодной, чистой водой в сумке. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me взял%floor% бутылку с чистой водой в руку и вынул%floor% из сумки {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me открутил%floor% крышку на бутылке {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me вылил%floor% воду на место ожога {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me достал%floor% из сумки шприц с обезболивающим {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me смочил%floor% шприц спиртовым раствором ватный тампон {enter}
SendInput, {F6} 
sleep  %delay%
Sendinput, /me обработав место укола, вколол%floor% обезболивающее пациенту {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me взглянул%floor%  в сумку {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /do В сумке балончик. {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me достал%floor% из сумки баллончик с надписью "Пантенол" {enter}
SendInput, {F6}
sleep  %delay% 
Sendinput, /me разбрызгал%floor% спрей на область ожога {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me посмотрел%floor% а другой отдел сумки {enter}
SendInput, {F6}
sleep  %delay% 
Sendinput, /me достал%floor% из сумки стерильную салфетку {enter}
SendInput, {F6}
sleep  %delay%
Sendinput, /me прикрыл%floor% салфеткой ожог {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Все, ваш ожог обработан. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Одевайтесь и можете идти. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/Глисты_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6} 
sleep  %delay%
SendInput,  Здравствуйте, сейчас мы проведем Вам биoрезoнансную диагнoстику на паразитoв. {enter}
SendInput, {F6} 
sleep  %delay%
SendInput,  Ложитесь на кушетку. {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /me открыл%floor% сумку, после чего достал%floor% биорезонансный прибор {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, Снимите штаны и нижнее бельё по колено. {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return


:?:/Глисты_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6} 
sleep  %delay%
SendInput,  Хорошо,теперь расслабьтесь. {enter}
SendInput, {F6} 
sleep  %delay% 
SendInput, /me вводит трубочку биорезонансново прибора в анальное отверстие пациента {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /me включает прибор {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /me cканирует кишечник пациента {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /try обнаружил%floor%,глисты {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return


:?:/Глисты_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6} 
sleep  %delay% 
SendInput,  У вас обнаружены паразиты{!} {enter}
SendInput, {F6} 
sleep  %delay% 
SendInput,  Я выпишу Вам Гельминтокс Парантел . Его стоимость всего 450 рублей, Вы согласны?  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return

:?:/Глисты_4::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6} 
sleep  %delay% 
SendInput,   У Вас всё в порядке{!} {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return

:?:/Ребро_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Сейчас проведем сканирование, выясним серьезность, ложитесь. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me подключил%floor%  апппрпт наркоза к пациенту  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рентген аппарат стоит у стены.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выкатывает аппарат к койке пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включает аппарат {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me наклоняет аппарат прислоняя прибор к спине пациента  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола вату и Йодонат {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me запускает сканирование {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me вынимает снимок из аппарата  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me задумчиво смотрит на снимок {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor%, перелом правого нижнего ребра  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return

:?:/Ребро_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me отложил%floor%  снимок на тумбочку  {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  Соболезную Вам, худшие опасения подтвердились.  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%  
SendInput, Будем ставить Вам Корсет.  {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me взяв перчатки с тумбочки надел%floor%  их {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me щупает место перелома {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me резким движением рук вправляет кость в правильное положение {enter}
SendInput, {F6}
sleep  %delay%    
SendInput,  Сейчас достану обезболивающее и корсет. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Шкаф стоит у стены. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me открыл%floor%  дверцу шкафа {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me взяв препарат в руку несет его пациенту {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me потянул%floor%  препарат пациенту {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  Разжуйте и проглотите, это снизит боль {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me взяв корсет, несет его пациенту {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me аккуратно надевает корсет на спину пациента {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me завязывает шнурки фиксируя корсет плотно на месте перелома {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me проверяет фиксацию корсета {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  Вам с ним нужно будет проходить полторы-две недели. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  После нужно будет приехать к нам, повторно проведем сканирование. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  Вообще не снимать и не мочить{!} Спать только на животе. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  Сейчас я Вам вколю обезболивающее.  {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  Потому что, как только перестанет действовать таблеточное – почувствуете резкую боль. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Препараты лежат на стеллаже. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me достал%floor% нужные препараты со стеллажа {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me достал%floor% нужный препарат со стеллажа {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me смочил%floor% ватку Хлоргексидином {enter}
SendInput, {F6}
sleep  %delay%   
SendInput, /me снял%floor% со шприца колпачок {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me набрав Хлоргексидин в шприц {enter}
SendInput, {F6}
sleep  %delay%   
SendInput, /me приспустил%floor% штаны пациента {enter}
SendInput, {F6} 
sleep  %delay%  
SendInput, /me смазывает место будущего укола мокрой ваткой {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me убрал%floor% Хлоргексидин на стеллаж {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Препараты на стеллаже. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me достал%floor% нужный препарат со стеллажа {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me набрал%floor% в шприц Налбуфин {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Лекарство в шприце. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me введя шприц в место укола вводит лекарство внутрь {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Урна в углу палаты. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me вытащив шприц бросил%floor% его в урну {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /me прислонил%floor% ватку к месту укола  {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  Так. Прижимайте ватку, потом просто бросьте ее в урну. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  Вам нужно полежать в таком положении минимум 1 час. {enter}
SendInput, {F6}
sleep  %delay%  
SendInput,  После чего, Вы можете ехать домой. {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return


:?:/Ребро_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, Я выпишу Вам Фастум-гель. Его стоимость 450 рублей. Вы согласны? {enter}
return


:?:/Позвоночник::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do У стены стоит стол с необходимыми инструментами. {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% антисептик с ватой {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me обрабатывает операционное поле  {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me включил%floor% аппарат наркоза {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% кислородную маску {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% кислородную маску на пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me подключил%floor% пациента к аппарату искусственной вентиляции лёгких {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me передвинул%floor% аппарат поближе к койке {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me  включил%floor% аппарат подачи хирургического цемента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% скальпель {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me сделал%floor% разрез в месте перелома позвоночника {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% троакар {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me постепенно ввел%floor% троакар в позвоночник {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включил%floor% аппарат {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me подсоединил%floor% трубку аппарата к троакару {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /me нажал%floor% кнопку 'Подать воздух' {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me вытащил%floor% троакар из позвонка {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% трубку {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me засунул%floor% трубку в позвонок {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me  нажал%floor% на кнопку 'Запуск' {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me начал%floor% заливать цемент в позвоночник {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выключил%floor% аппарат подачи хирургического цемента {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me вытащил%floor% трубку из позвоночника {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me положил%floor% трубку на аппарат {enter}
SendInput, {F6} 
sleep  %delay%
SendInput,  /me начал%floor% двигать аппарат к углу комнаты {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me взял%floor% в руки нитки и ножницы {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me отрезал%floor% нужное количество ниток {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me сшивает место разреза кожи {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me взял%floor% послеоперационный пластырь {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Послеоперационный пластырь в руках. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me наклеил%floor% пластырь на место шва {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me отключил%floor% пациента от аппарата искусственной вентиляции лёгких {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me  снял%floor% кислородную маску с пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Операция прошла успешно. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Сейчас я Вам одену корсет. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me  взял%floor% корсет в руку {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /me аккуратно одевает корсет на спину пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me плотно завязывает шнурки корсета {enter}
SendInput, {F6}
sleep  %delay%
SendInput,  /me проверяет фиксацию корсета {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Теперь необходимо носить корсет как минимум 2 месяца. {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return

:?:/Грыжа::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежат перчатки и мед.маска.  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% перчатки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% перчатки  {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /do Рядом стоит аппарат наркоза.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me подключил%floor% аппарат наркоза к пациенту  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% датчики от аппарата  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me подключил%floor% датчики к пациенту  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% бутыль с Йодонатом со стойки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor% бутыль с Йодонатом  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола вату  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me смочил%floor% вату йодонатом  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% обрабатывать место надреза  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежит скальпель.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% скальпель  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me сделал%floor% надрез в середине позвоночника  {enter} 
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% ватный тампон со стола  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me вытер аккуратно кровь  {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /me взял%female% ранорасширитель с подноса  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me расширил%floor% надрез с помощью инструмента  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me посмотрел%floor% на датчик пульса пациента  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% зажим с подноса  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% инструмент для удаления связок и костей {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% удалять участки связок и костей  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% оценивать степень повреждения нервов  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% зажим с подноса  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% инструмент для удаления грыжи  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% удалять грыжу с диска позвоночника  {enter}
SendInput, {F6}
sleep  %delay%  
SendInput, /do Хирургическая нить и игла лежат на столе.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% с подноса хирургическую нить и иглу  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% продевать нить в ушко иглы  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor%  зашивать надрез на спине пациента   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежит раствор хлорида натрия и вата.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me смочил%floor% вату раствором хлорида натрия  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% обрабатывать швы  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Хирургический пластырь лежит на столе.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% хирургический пластырь в руки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% накладывать хирургический пластырь на швы  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отключил%floor% аппарат наркоза  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отсоединил%floor% аппарат наркоза от пациента  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Операция на этом закончена.  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return

:?:/АВД_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% с пациента одежду  {enter}
return


:?:/АВД_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do Мед. сумка весит на плече.  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor%  мед. сумку {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor%  сухое полотенце с полки и протер%female% тело пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отложил%floor% полотенце на стол  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor% полку  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% АВД и электроды и включил%floor% его  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% электроды и подключил%floor% их к АВД  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% первый электрод и приклеил%floor% его на тело пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% второй электрод и приклеил%floor% его на тело пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me нажал%floor% на кнопку "Проанализировать"  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor%, пульс  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return

:?:/АВД_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do АВД начал издавать звуки.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me нажал%floor% на кнопку "Пуск"  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me поднес%female% руку к сонной артерии пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me пытается нащупать пульс  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do У человека есть пульс?  {enter}
SendInput, {F6}
sleep 250
SendInput,  /timestamp {enter}{F12}
return

:?:/АВД_4::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /me выключил%floor% АВД апарат и вытащил%floor% электроды  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me поставил%floor% апарат на полку  {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return

:?:/Клизма_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do В шкафу необходимые вещи.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor% шкаф  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% одноразовую пелёнку  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me постелил%floor%пелёнку на койку  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Снимите всю нижнюю одежду.  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Ложитесь на левый бок, согните ноги.   {enter}
SendInput, {F6}
sleep 350
SendInput, /timestamp {enter}{F12}
return

:?:/Клизма_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do  Шкаф открыт. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% клизму {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do  В стеллаже баночка с раствором "Энема клин".  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл стеллаж  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% баночку раствором  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыв баночку, аккуратно ввёл%floor% раствор в клизму  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me поставил%floor% баночку с оставшимся раствором в стеллаж  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыл%floor% стеллаж  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% вазелиновое масло из шкафа  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me закрыл%floor% шкаф  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me смазал%floor% конец трубки клизмы вазелиновым маслом {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me осторожно вводит трубку в задний проход пациента  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% вводить раствор в пациента  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me вытащил%floor% трубку из заднего прохода   {enter}
SendInput, {F6}  
sleep  %delay%
SendInput,  Садитесь на туалет и ожидайте выхода каловых масс. Он находится в коридоре.  {enter}
SendInput, {F6}  
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/Cколиоз_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, И так, приступим{!} {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На плече висит медицинская сумка. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor% сумку, после чего достал%floor% сколиометр {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me прикладывает сколиометр к спинному позвоночнику пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снимает показания с прибора {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me смотрит результат {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor%, отклонения {enter}
SendInput, {F6}
sleep 200
SendInput, /timestamp {enter} {F12}
return

:?:/Cколиоз_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput,  Ох, да у вас искривление в позвоночнике{!} {enter}
SendInput, {F6}
sleep  %delay%
SendInput, Рекомендую вам прийти к нам позже и заказать корсет{!} {enter}
SendInput, {F6}
sleep 200
SendInput, /timestamp {enter} {F12}
return

:?:/Cколиоз_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Хорошо,у Вас всё в порядке. {enter}
SendInput, {F6}
sleep 200
SendInput, /timestamp {enter} {F12}
return

:?:/Наркотики_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /do На полке лежит различное оборудование.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% с полки экспресс тест на наркотики  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me распечатал%floor% герметичную оболочку баночки  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me передал%floor% тест человеку напротив  {enter}
SendInput, {F6}
sleep %delay%
SendInput, Возьмите.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, Вам необходимо заполнить контейнер уриной до вот этого уровня.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me показал%floor% на отметку в тестере  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Наркотики_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, Давайте я посмотрю.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% тест у человека напротив   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me достал%floor% тест-полоску из контейнера   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me посмотрел%floor% на тест-полоску   {enter}
SendInput, {F6} 
sleep %delay%
SendInput, /try обнаружил%floor%, наркотическое опьянения {enter}
SendInput, {F6}
sleep %delay%
SendInput, /timestamp {enter}{F12}
return

:?:/Наркотики_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /do У человека обнаружено наркотическое опьянение.  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Наркотики_4::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, {F6}
sleep %delay%
SendInput, /do У человека не обнаружено наркотического опьянения.﻿﻿  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Капельница::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /do Возле стола стоит стойка с капельницей. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% стойку с капельницей  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me поставил%floor% стойку около кушетки с пациентом  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me достал%floor% из мед. сумки пакет с раствором рингера   {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep %delay%
SendInput, /me повесил%floor% пакет с раствором рингера на стойку   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me достал%floor% из мед. сумки шприц-бабочку {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me присоединил%floor% ее к капельнице  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me достал%floor% из мед. сумки ампулу   {enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me расколол%floor% ее и влил%floor% содержимое в шприц   {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me наложил%floor% жгут на руку пациента  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% ватку со столика и смочил%floor% ее в спирте {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me протер%female% место укола  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me находит вену  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me убрал%floor% жгут с руки  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me вводит шприц-бабочку в вену  {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/ФГДС_1::
SendMessage, 0x50,, 0x4190419,, A 
SendInput, {F6}
sleep %delay%
SendInput,  Здравствуйте. Сейчас я проведу Вам гастроскопию.  Ложитесь на кушетку, на левый бок. {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /do На столике лежит капа. {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% капу в руку {Enter} 
SendInput, {F6}
sleep %delay%
SendInput,   Так... Вот, откройте рот, закусите капу. {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me вставил%floor% капу в рот пациента {Enter}
SendInput, {F6} 
Sleep 250 
SendInput, /timestamp {enter}{F12} 
return 

:?:/ФГДС_2::
SendMessage, 0x50,, 0x4190419,, A 
 SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% вводить гастроскоп в пищевод пациента {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% изучать пищевод {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /try обнаружил%floor%, отклонения  {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me продолжил%floor% вводить гастроскоп в желудок пациента {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% осматривать стенки желудка {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /try обнаружил%floor%, отклонения  {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me осмотрел%floor% двенадцатипёрстную кишку {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /try обнаружил%floor%, отклонения  {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% вынимать гастроскоп из желудка пациента {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me положил%floor% гастроскоп в аппарат для дезинфекции {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /do Гастроскоп в аппарате для дезинфекции. {Enter} 
SendInput, {F6} 
Sleep 250 
SendInput, /timestamp {enter}{F12} 
return 


:?:/Змея_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Будем вводить противоядие. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% ватный диск и спирт {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me смочил%floor% ватный диск в спирте {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
SendInput, {F6}
sleep  %delay%
SendInput, /me продезинфицировал%floor% место введения {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выкинул%floor% ватный диск в урну {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% одноразовую иглу, и новый одноразовый шприц {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% иглу на шприц  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% пробирку с противоядием{enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me наполнил%floor% шприц {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me убрал%floor% лишний воздух из шприца {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me ввёл%floor% противоядие {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me вынул%floor% иглу {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выкинул%floor% шприц в урну {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /timestamp {enter}{F12}
return


:?:/Сахар_1::
SendMessage, 0x50,, 0x4190419,, A 
SendInput, {F6} 
sleep %delay% 
Sendinput, /do В правом кармане одноразовые перчатки. {enter}
SendInput, {F6} 
Sleep %delay% 
SendInput, /me достал%floor% из правого кармана перчатки {enter}
SendInput, {F6} 
sleep %delay% 
SendInput, /me одел%floor% перчатки на руки {enter}
SendInput, %delay% 
sleep %delay% 
SendInput, Давайте правую руку. {Enter} 
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return 

:?:/Сахар_2::
SendMessage, 0x50,, 0x4190419,, A  
SendInput, {F6} 
sleep %delay% 
SendInput, /do На тумбе лежит всё необходимое для анализа. {enter}
SendInput, {F6} 
sleep %delay% 
SendInput, /me взял%floor% с тумбы ватку и спирт {enter}
SendInput, {F6} 
sleep %delay% 
SendInput, /me аккуратно открыл%floor% спирт, затем смочил%floor% ватку {enter}
SendInput, {F6} 
sleep %delay% 
SendInput, /me лёгким движением руки обработал%floor% место сбора крови {enter}
SendInput, {F6} 
sleep %delay% 
SendInput, /me отложил%floor% ватку на стол {enter}
SendInput, {F6} 
sleep %delay% 
SendInput, /do На тумбе перед сотрудником лежит новый скарификатор. {enter}
SendInput, {F6} 
sleep %delay% 
SendInput, /me сделал%floor% прокол в области подушечки пальца {enter}
SendInput, {F6} 
sleep %delay% 
SendInput, /me взял%floor% ватку с тумбы, затем вытер%Female% первую каплю крови {enter}
SendInput, {F6} 
Sleep %delay% 
Sendinput, /me аккуратно нанёс%Female% каплю крови на тест-полоску {enter}
SendInput, {F6} 
sleep %delay% 
SendInput, /me взял%floor% с тумбы сухую ватку и приложил%floor% к месту прокола {enter}
SendInput, {F6} 
sleep %delay% 
SendInput, /me вставил%floor% тест-полоску в глюкометр {enter}
SendInput, {F6} 
sleep %delay% 
SendInput, /me взглянул%floor% на показатели глюкометра {enter}
SendInput, {F6} 
sleep %delay% 
SendInput, /try обнаружил%floor%, что уровень сахара в норме {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return

:?:/Сахар_3::
SendMessage, 0x50,, 0x4190419,, A  
SendInput, {F6} 
sleep %delay% 
SendInput, Уровень сахара в крови в норме. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return

:?:/Сахар_4::
SendMessage, 0x50,, 0x4190419,, A 
SendInput, {F6} 
sleep %delay% 
SendInput, Уровень сахара в крови недостаточен. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return

:?:/Вздутие_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /me положил%floor% руки на живот пациенту и стал%floor% прощупывать {enter}
SendInput, {F6}
sleep %delay%
SendInput, В каком месте нажатия чувствуется больше боль? {enter}
return


:?:/Вздутие_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /me убрал%floor% руки c живота пациента {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me поставил%floor% диагноз пациента {enter}
SendInput, {F6}
sleep %delay%
SendInput, У вас вздутие. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/Вздутие_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /me убрал%floor% руки c живота пациента {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Руки убраны. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me поставил%floor% диагноз пациента {enter}
SendInput, {F6}
sleep %delay%
SendInput, У вас вздутие. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/Температура_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /do Градусник в мед.сумке. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me открыл%floor% мед.сумку {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% градусник из мед.сумки {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me стряхнул%floor% градусник {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me положил%floor% градусник под подмышку пациенту {enter}
SendInput, {F6}
sleep 10000
SendInput, /me взял%floor% градусник в руки {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me внимательно посмотрел%floor% на градусник {enter}
SendInput, {F6}
sleep %delay%
SendInput, /try обнаружил%floor%, что температура повышена {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return



:?:/Температура_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, У вас повышенная температура. {enter}
SendInput, {F6}
sleep %delay%
SendInput, Я выпишу Вам "Колдрекс". Его стоимость 450 рублей. Вы согласны? {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return


:?:/Температура_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, Ваша температура в норме. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me стряхнул%floor% градусник{enter}
SendInput, {F6}
sleep %delay%
SendInput, /me положил%floor% градусник в мед.сумку {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Градусник в мед.сумке. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return



:?:/Вена_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do На руках перчатки, на лице маска. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Жгут лежит на столе. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% жгут {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me перевязал%floor% жгут на руке пациента выше локтя {enter}
SendInput, {F6}
sleep %delay%
SendInput, Сожмите и разожмите кулак несколько раз. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return



:?:/Вена_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /do На руке пациента выступили вены. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% со стола запечатанную иглу и банка для анализов {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me распечатал%floor% иглу, после чего присоединил%floor% её к банке для анализов {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me вставил%floor% иглу в вену {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me вытащил%floor% иглу из вены пациента {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me снял%floor% жгут с руки пациента {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me приложил ватку к месту укола {enter}
SendInput, {F6}
sleep %delay%
SendInput, Согните руку и держите так в течении 5-10 минут. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% тест для анализа крови {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me положил%floor% тест в стерильную колбочку {enter}
SendInput, {F6}
sleep %delay%
SendInput,  Результаты получить вы сможете в течении недели у нас в Регистратуре{!} {enter}
SendInput, {F6}
sleep %delay%
SendInput,  А сейчас идите в строй на первом этаже{!}{Enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return




:?:/Палец_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, Здравствуйте. Вы на взятие крови?{Enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/Палец_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, Хорошо, давайте сюда свою медицинскую карту.{Enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/Палец_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% медицинскую карту человека{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /me положил%floor% на стол медицинскую карту{Enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/Палец_4::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, Садитесь на кушетку, кладите правую руку на стол.{Enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Палец_5::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /do На столе лежат медицинские перчатки.{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% перчатки со стола{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /me надел%floor% медицинские перчатки{Enter}
SendInput, {F6}
sleep %delay%
SendInput, Будем брать кровь из безымянного пальца.{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /do На столе стоит банка со спиртовыми шариками.{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /me открыл%floor% банку{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% один ватный шарик в руку{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% обрабатывать безымянный палец{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /do На столе лежат стерильные скарификаторы.{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% скарификатор в руку{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /me быстрым движением проколол%floor% палец пациенту{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% стекло для взятия мазка{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /me сделал%floor% мазок крови по стеклу{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /do На столе лежит спиртовой шарик.{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /me приложил%floor% спиртовой шарик к проколу{Enter}
SendInput, {F6}
sleep %delay%
SendInput, Так, держите, пока кровь не остановится{Enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Палец_6::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /do На столе лежит карточка пациента.{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /me открыл%floor% карточку пациента{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /do На столе лежит ручка.{Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% ручку в руку{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /me внес%floor% данные о проведении процедуры в карточку{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /me закрыл%floor% карточку{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% карточку в руку{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /me передал%floor% карточку человеку напротив{Enter} 
SendInput, {F6}
sleep %delay%
SendInput, За результатами приходите через день-два. {Enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return



:?:/Зрения_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, Перейдем к осмотру зрения.{Enter}
SendInput, {F6}
sleep %delay%
SendInput, /do На стене висит таблица Сивцева. {Enter}
SendInput, {F6}
sleep %delay%
SendInput, Сейчас я Вам буду показывать буквы, а вы будете их называть. {Enter} 
SendInput, {F6}
sleep %delay%
SendInput, /do Указка лежит на столе. {Enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% указку в левую руку {Enter}
SendInput, {F6}
sleep %delay%
SendInput, Закройте правый глаз{!} {Enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Зрения_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /me указал%floor% на букву "Б" {Enter}
return

:?:/Зрения_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
SendInput, /me указал%floor%  на букву "Н"  {Enter}
return

:?:/Зрения_4::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /me указал%floor% на букву "Ш" {Enter} 
return


:?:/Зрения_5::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput,  Хорошо, закройте левый глаз{!} {Enter} 
return

:?:/Зрения_6::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /me указал%floor% на букву "Ф" {Enter} 
return


:?:/Зрения_7::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, /me указал%floor% на букву "П" {Enter} 
return
   
:?:/Зрения_8::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput,  /me положил%floor%  указку на стол {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Указка на столе. {enter}
SendInput, {F6}
sleep %delay%
SendInput, Открывайте глаза.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do На столе ручка. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% ручку, затем внес%Female% изменения в мед. книжку {enter}
return


:?:/Роды_1::
SendMessage, 0x50,, 0x4190419,, A 
SendInput, {F6}
sleep %delay%
SendInput, Успокойтесь, девушка, сейчас главное не волноваться{!} {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me расстегнул%floor% на девушке одежду, которая стягивала живот {enter}
SendInput, {F6}
sleep %delay%
SendInput, Пожалуйста, согните ноги в коленях и очень сильно раздвиньте. {enter}
SendInput, {F6}
sleep %delay%
SendInput, Запомните: тужиться нужно только после глубокого вдоха, вне потуг нужно глубоко дышать. {enter}
SendInput, {F6}
sleep %delay%
SendInput, Во время потуг, пожалуйста, держитесь за свои колени и тяните их на себя, ничего не бойтесь.  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /n [нужно, чтобы девушка отыграла, что у нее начались сильные схватки] 


:?:/Роды_2::
SendInput, {F6}
sleep %delay%
SendInput, /s Тужьтесь, тужьтесь{!} Сильнее{!} {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do На свет постепенно начала появляться голова новорожденного. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /todo Сделайте выдох и постарайтесь больше не тужиться*придерживая голову ребенка {enter}
SendInput, {F6}
sleep %delay%
SendInput,  /do Ребенок полностью появился на свет. {enter}
SendInput, {F6}
sleep %delay%
SendInput, Спокойствие{!} Теперь необходимо разрезать пуповину. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /do Через плечо надета мед. сумка с множеством препаратов. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me достав нитки для бинтов, сделал%floor% 2 узла на расстоянии 5 и 10 см выше пупка ребенка  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me достав ножницы из сумки, аккуратно перерезал%floor%  пуповину между узлами {enter}
SendInput, {F6} 
Sleep 250 
SendInput, /timestamp {enter}{F12} 
SendInput, {F6}
sleep %delay%
SendInput, /me аккуратно похлопал%floor%  ребенка по ягодицам и спине {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me достав антисептик, продезинфицировал%floor% конец пуповины у ребенка {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me убрав антисептик в сумку, достал%floor% к бинты и обвязал%floor% к ими пуповину {enter}
SendInput, {F6} 
sleep %delay%
SendInput, /me достав салфетки из сумки, вытер%Female% слизь с носа и рта новорожденного {enter}
SendInput, {F6}
sleep %delay%
SendInput, /todo Ну что, мамаша! Поздравляю!*достав объемную ткань из сумки {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me завернув новорожденного в ткань, положил%floor% его на грудь матери {enter}
return 



:?:/Матка_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Здравствуйте. Сейчас, я проведу Гистероскопию. {enter}
SendInput, {F6}
sleep  %delay% 
SendInput, Раздевайтесь. Садитесь в гинекологическое кресло. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return

:?:/Матка_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежат стерильные перчатки. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% перчатки в руки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% перчатки {enter} 
SendInput, {F6}
sleep  %delay%
SendInput, /do На стойке висит гистероскоп. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% гистероскоп со стойки {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% вводить гистероскоп в матку пациентки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% осмотр матки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor%, отклонения {Enter} 
return


:?:/Матка_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput,  У Вас, есть патология.   {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Рядом стоит аппарат наркоза. {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me подключил%floor% апппрпт наркоза к пациенту  {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me удалил%floor%  патологию {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me отсоеденил%floor%  аппарат наркоза от пациента {enter}
return

:?:/Матка_4::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, Патологий у Вас, нет{!}  {enter}
return


:?:/Матка_5::
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% вынимать гистероскоп из  матки {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me положил%floor% гистероскоп в аппарат для дезинфекции {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return


:?:/Цистоскоп_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Здравствуйте. Сейчас я проведу Цистоскопию. {enter}
SendInput, {F6}
sleep  %delay% 
SendInput, Раздевайтесь. Садитесь кресло. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return


:?:/Цистоскоп_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежат стерильные перчатки. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% перчатки в руки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% перчатки {enter} 
SendInput, {F6}
sleep  %delay%
SendInput, /do На стойке висит цистоскоп. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% цистоскоп со стойки {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% вводить  цистоскоп  в  уретру {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% осмотр  мочевого пузыря {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor%, отклонения {Enter} 
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return


:?:/Цистоскоп_3::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, У Вас, есть отклонения {!}  {enter}
return

:?:/Цистоскоп_4::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep %delay%
SendInput, Отклонений  у Вас, нет{!}  {enter}
return

:?:/Цистоскоп_5::
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% вынимать цистоскоп  из  уретры {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me положил%floor%  цистоскоп  в аппарат для дезинфекции {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return


:?:/ВМС_1:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, {F6} 
sleep %delay% 
SendInput, Итак, у вас четвертый день менструации. {Enter} 
SendInput, {F6} 
sleep %delay% 
SendInput, Раздевайтесь. Садитесь в гинекологическое кресло.{Enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return 

:?:/ВМС_2:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, {F6} 
sleep %delay% 
SendInput, /do Поднос со спиралью стоит на столе.{enter} 
SendInput, {F6} 
sleep %delay% 
SendInput, /me взял%floor% спираль с подноса {enter} 
SendInput, {F6} 
sleep %delay% 
SendInput, /me начал%floor% вводить спираль в матку {enter}
SendInput, {F6} 
sleep %delay% 
SendInput, /me потянул%floor% за нитку {enter}
SendInput, {F6} 
sleep %delay% 
SendInput,  Внутриматочная спираль установлена ​​на 5 лет. Всего доброго, не болейте{!}{enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return 
 

:?:/Стерилизация::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /d﻿o У стены стоит шкаф. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me открыл%floor% шкаф {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На верхней полке лежат перчатки. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% перчатки с полки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% перчатки  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do Около койки стоит аппарат для наркоза. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% кислородную маску {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% маску на пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включил%floor% аппарат для наркоза {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% скальпель {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me сделал%floor% надрез в области брюшной полости {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me взял%floor% кольца {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% перетягивать фаллопиевы трубы {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выключил%floor% аппарат для наркоза {enter}
SendInput, {F6} 
sleep  %delay%
SendInput, /me снял%floor% маску с пациента {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return


:?:/Плод_1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, Здравствуйте. Сейчас, я проведу Фетоскопия. {enter}
SendInput, {F6}
sleep  %delay% 
SendInput, Раздевайтесь. Садитесь в гинекологическое кресло. {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter} {F12}
return


:?:/Плод_2::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep  %delay%
SendInput, /do На столе лежат стерильные перчатки. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% перчатки в руки {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% перчатки {enter} 
SendInput, {F6}
sleep  %delay%
SendInput, /do Около койки стоит аппарат для наркоза. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% кислородную маску {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me надел%floor% маску на пациента {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me включил%floor% аппарат для наркоза {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me взял%floor% со стола перекись водорода и ватку, и обработал%floor% место операции  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /do На стойке висит фетоскоп. {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% фетоскоп со стойки {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% вводить фетоскоп  в брюшную стенку  {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me начал%floor% осмотр  плода {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /try обнаружил%floor%, отклонения  {Enter} 
return

:?:/Плод_3::
SendInput, {F6}
sleep %delay%
SendInput, /me начал%floor% вынимать фетоскоп из  матки {enter}
SendInput, {F6}
sleep %delay%
SendInput, /me положил%floor% фетоскоп  в аппарат для дезинфекции {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me выключил%floor% аппарат для наркоза {enter}
SendInput, {F6}
sleep  %delay%
SendInput, /me снял%floor% маску с пациента﻿ {enter}
SendInput, {F6}
sleep 250
SendInput, /timestamp {enter}{F12}
return

:?:/Плод_4::
SendInput, {F6}
sleep %delay%
SendInput, Есть пороки развития. {enter}
return


:?:/Плод_5::
SendInput, {F6}
sleep %delay%
SendInput, Все хорошо. {enter}
return



:?:/голова::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Миг. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/живот::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Но-Шпа. Её стоимость 450 рублей. Вы согласны? {enter}
return
:?:/диарея::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Активированый уголь. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/потенция::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Виагру. Её стоимость 450 рублей. Вы согласны? {enter}
return
:?:/геморрой::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Свечи Релиф. Их стоимость 450 рублей. Вы согласны? {enter}
return
:?:/ушиб::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Фастум-гель. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/ожог::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам спрей Пантенол. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/витамины::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Унивит. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/тошнота::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Церукал. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/изжога::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Омепразол. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/насморк::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Отривин. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/мигрень::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Амигренин. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/мочевой::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Цистон. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/печень::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Гепабене. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/аллергия::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Зодак. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/сердце::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Кардиомагнил. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/простуда::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Терафлю. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/кашельс::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 500
SendInput, Я выпишу Вам Лазолван. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/кашельв::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Амбробене. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/диабет::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Диабетон. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/горло::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Гексорал. Его стоимость 450 рублей. Вы согласны? {enter}
:?:/глаза::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Визин. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/судороги::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Магнелис. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/уши::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Отинум. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/почки::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Уролисан. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/суставы::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Фастум-гель. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/давлениев::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Андипал. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/давлениен::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Норадреналин. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/яйца::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Амоксиклав. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/сон::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Персен Ночь. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/зрение::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Виталюкс. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/память::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Гинкоум Эвалар. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/укачивание::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Драмина. Его стоимость 450 рублей. Вы согласны? {enter}
return
:?:/курение::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
sleep 200
SendInput, Я выпишу Вам Табекс. Его стоимость 450 рублей. Вы согласны? {enter}
return

;--------------------------------------------------------------------------------

Pause::Pause ; Assign the toggle-pause function to the "pause" key...
!p::Pause ; ... or assign it to Win+p or some other hotkey.
return

!o::
ExitApp 

!i::
Reload

;--------------------------------------------------------------------------------



ButtonПрименить:
GuiClose:
GuiEscape:
Gui, Submit






;--------------------------------------------------------------------------------
Gui, 2:show, center h700 w1300,
Gui, 2:Font, S10   Bold
Gui, 2:Add, Tab2, x0 y0 w1290 h25 cFF2400  +BackgroundTrans, Бинды|РП Ситуации 1|РП Ситуации 2|Препараты|txt > AHK

Gui,2: Tab, 1
Gui, 2 :Add, Picture, x0 y30 w1300 h700, C:\Program Files (x86)\МЗ\AHK_1.jpg
Gui,2: Font, S10 C000000
Gui,2: Add, Text, x10 y60 w300 h20    cFF2400 +BackgroundTrans,   Alt+1
Gui,2: Add, Text, x10 y90 w300 h20    cFF2400 +BackgroundTrans ,  Alt+2
Gui,2: Add, Text, x10 y120 w300 h20  cFF2400 +BackgroundTrans ,  Alt+3
Gui,2: Add, Text, x10 y150 w300 h20  cFF2400 +BackgroundTrans ,  Alt+4
Gui,2: Add, Text, x10 y180 w300 h20  cFF2400 +BackgroundTrans ,  Alt+5
Gui,2: Add, Text, x10 y210 w300 h20  cFF2400 +BackgroundTrans ,  Alt+6
Gui,2: Add, Text, x10 y240 w300 h20  cFF2400 +BackgroundTrans ,  Alt+7
Gui,2: Add, Text, x10 y270 w300 h20  cFF2400 +BackgroundTrans ,  Alt+8
Gui,2: Add, Text, x10 y300 w300 h20  cFF2400 +BackgroundTrans ,  Alt+9
Gui,2: Add, Text, x10 y330 w300 h20  cFF2400 +BackgroundTrans ,  Alt+0
Gui,2: Add, Text, x10 y360 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num1
Gui,2: Add, Text, x10 y390 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num2
Gui,2: Add, Text, x10 y420 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num3
Gui,2: Add, Text, x10 y450 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num4
Gui,2: Add, Text, x10 y480 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num5
Gui,2: Add, Text, x10 y510 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num6
Gui,2: Add, Text, x10 y540 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num7
Gui, 2:Add, Text, x10 y570 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num8
Gui, 2:Add, Text, x10 y600 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num9
Gui, 2:Add, Text, x10 y630 w300 h20  cFF2400 +BackgroundTrans ,  Alt+Num0

Gui,2: Add, Text, x100 y60 w300 h20 +BackgroundTrans , [Приветствие]
Gui,2: Add, Text, x100 y90 w300 h20 +BackgroundTrans , [Беспокойствие]
Gui,2: Add, Text, x100 y120 w300 h20 +BackgroundTrans , [Осмотр]
Gui,2: Add, Text, x100 y150 w300 h20 +BackgroundTrans , [Передать препарат]
Gui,2: Add, Text, x100 y180 w300 h20 +BackgroundTrans , [Всего доброго, не болейте!]
Gui,2: Add, Text, x100 y210 w300 h20 +BackgroundTrans , [Если пациент отказался]
Gui,2: Add, Text, x100 y240 w300 h20 +BackgroundTrans , [Самолечение]
Gui,2: Add, Text, x100 y270 w300 h20 +BackgroundTrans , [Мегафон в АСМП]
Gui,2: Add, Text, x100 y300 w300 h20 +BackgroundTrans , [Посмотреть время]
Gui,2: Add, Text, x100 y330 w300 h20 +BackgroundTrans , [Рация]
Gui,2: Add, Text, x100 y360 w300 h20 +BackgroundTrans , [Рация]
Gui,2: Add, Text, x100 y390 w300 h20 +BackgroundTrans , [Разрешение отъехать]
Gui,2: Add, Text, x100 y420 w300 h20 +BackgroundTrans , [Разрешаю для 7-10 рангов]
Gui,2: Add, Text, x100 y450 w300 h20 +BackgroundTrans , [Отказываю для 7-10 рангов]
Gui,2: Add, Text, x100 y480 w300 h20 +BackgroundTrans , [Взять мед.диплом]
Gui,2: Add, Text, x100 y510 w300 h20 +BackgroundTrans ,  [Взять паспорт]
Gui,2: Add, Text, x100 y540 w300 h20 +BackgroundTrans ,  [Мед.комиссия для призывников]
Gui, 2:Add, Text, x100 y570 w300 h20 +BackgroundTrans ,  [Мед.комиссии для призывников]
Gui, 2:Add, Text, x100 y600 w300 h20 +BackgroundTrans ,  [Взял%floor% перерыв]
Gui, 2:Add, Text, x100 y630 w300 h20 +BackgroundTrans ,  [Сдал%floor% смену]

Gui, 2:Add, Text, x400 y60 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y75 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y90 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y105 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y120 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y135 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y150 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y165 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y180 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y195 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y210 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y225 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y240 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y255 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y270 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y285 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y300 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y315 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y330 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y345 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y360 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y375 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y390 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y405 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y420 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y435 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y450 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y465 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y480 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y495 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y510 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y525 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y540 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y555 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y565 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y585 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y600 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y615 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y630 w300 h20 c000000 +BackgroundTrans, |

Gui, 2: Add, Text, x410 y60  w300 h20 cFF2400 +BackgroundTrans ,  /Пост
Gui, 2: Add, Text, x410 y90  w300 h20  cFF2400 +BackgroundTrans, /Выехал
Gui, 2: Add, Text, x410 y120 w300 h20 cFF2400 +BackgroundTrans, /Дежурство
Gui, 2: Add, Text, x410 y150 w300 h20 cFF2400 +BackgroundTrans, /Окончил
Gui, 2: Add, Text, x410 y180 w300 h20 cFF2400 +BackgroundTrans, /Город
Gui, 2: Add, Text, x410 y210 w300 h20  cFF2400 +BackgroundTrans, /Патрулирование
Gui, 2: Add, Text, x410 y240 w300 h20  cFF2400 +BackgroundTrans , /Патрул
Gui, 2: Add, Text, x410 y270 w300 h20  cFF2400 +BackgroundTrans , /Еду
Gui, 2: Add, Text, x410 y300 w300 h20  cFF2400 +BackgroundTrans , /Принял
Gui, 2: Add, Text, x410 y330 w300 h20  cFF2400 +BackgroundTrans , /Место
Gui, 2: Add, Text, x410 y360 w300 h20  cFF2400 +BackgroundTrans , /Ложный
Gui, 2: Add, Text, x410 y390 w300 h20  cFF2400 +BackgroundTrans , /Госпитализация
Gui, 2: Add, Text, x410 y420 w300 h20  cFF2400 +BackgroundTrans , /ВЦГБ
Gui, 2: Add, Text, x410 y450 w300 h20  cFF2400 +BackgroundTrans , /ЦГБ


Gui, 2: Add, Text, x550 y60 w300 h20 +BackgroundTrans ,   [О выезде на пост]
Gui, 2: Add, Text, x550 y90 w300 h20 +BackgroundTrans ,   [Если разрешили]
Gui, 2: Add, Text, x550 y120 w300 h20 +BackgroundTrans,  [Каждые 5 минут на посте]
Gui, 2: Add, Text, x550 y150 w300 h20 +BackgroundTrans , [По окончании дежурства на посту]
Gui, 2: Add, Text, x550 y180 w300 h20 +BackgroundTrans , [О выезде на патруль]
Gui, 2: Add, Text, x550 y210 w300 h20 +BackgroundTrans , [Если разрешили]
Gui, 2: Add, Text, x550 y240 w300 h20 +BackgroundTrans , [Каждые 5 минут на патруле]
Gui, 2: Add, Text, x550 y270 w300 h20 +BackgroundTrans , [По окончании патрулирования]
Gui, 2: Add, Text, x550 y300 w300 h20 +BackgroundTrans , [О выезде на вызов]
Gui, 2: Add, Text, x550 y330 w300 h20 +BackgroundTrans , [По прибытии на место вызова]
Gui, 2: Add, Text, x550 y360 w300 h20 +BackgroundTrans , [Если вызов ложный]
Gui, 2: Add, Text, x550 y390 w300 h20 +BackgroundTrans , [Если вызов не ложный]
Gui, 2: Add, Text, x550 y420 w300 h20 +BackgroundTrans , [После госпитализации пациента]
Gui, 2: Add, Text, x550 y450 w300 h20 +BackgroundTrans , [По окончании работы]


Gui, 2:Add, Text, x810 y60 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x810 y75 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x810 y90 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x810 y105 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y120 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y135 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y150 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y165 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y180 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y195 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y210 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y225 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y240 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y255 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y240 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y255 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y270 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y285 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y300 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y315 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y330 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y345 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y360 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y375 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y390 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y405 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y420 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y435 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y450 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y465 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y480 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y495 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y510 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y525 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y540 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y555 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y565 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y585 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y600 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y615 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x810 y630 w300 h20 c000000 +BackgroundTrans, |


Gui, 2:Add, Text, x820 y60 w300 h20 cFF2400  +BackgroundTrans , Звание:
Gui, 2:Add, Text, x820 y90 w300 h20 cFF2400  +BackgroundTrans , Тег: 
Gui, 2:Add, Text, x820 y120 w300 h20 cFF2400 +BackgroundTrans , Имя:
Gui, 2:Add, Text, x820 y150 w300 h20 cFF2400 +BackgroundTrans , Фамилия:
Gui, 2:Add, Text, x820 y180 w300 h20 cFF2400 +BackgroundTrans , Отчество:
Gui, 2:Add, Text, x820 y210 w300 h20 cFF2400 +BackgroundTrans , Название больницы:
Gui, 2:Add, Text, x820 y240 w300 h20 cFF2400 +BackgroundTrans , Задержка:
Gui, 2:Add, Text, x820 y270 w300 h20 cFF2400 +BackgroundTrans , Пост:
Gui, 2:Add, Text, x820 y300 w300 h20 cFF2400 +BackgroundTrans , Напарник:
Gui, 2:Add, Text, x820 y330 w300 h20 cFF2400 +BackgroundTrans , ИФ напарниа:
Gui, 2:Add, Text, x820 y360 w300 h20 cFF2400 +BackgroundTrans , Пол:  
Gui, 2:Add, Text, x820 y390 w300 h20 cFF2400 +BackgroundTrans , Пол:  


Gui, 2:Add, Text, x980 y60 w900 h20 +BackgroundTrans ,  [%JWI%]
Gui, 2:Add, Text, x980 y90 w900 h20 +BackgroundTrans ,  [%TAG%]
Gui, 2:Add, Text, x980 y120 w900 h20 +BackgroundTrans, [%Name%]
Gui, 2:Add, Text, x980 y150 w300 h20 +BackgroundTrans , [%Surname%]
Gui, 2:Add, Text, x980 y180 w300 h20 +BackgroundTrans , [%Middle_Name%]
Gui, 2:Add, Text, x980 y210 w300 h20 +BackgroundTrans , [%Bol%]
Gui, 2:Add, Text, x980 y240 w300 h20 +BackgroundTrans , [%delay%]
Gui, 2:Add, Text, x980 y270 w300 h20 +BackgroundTrans , [%Fast%]
Gui, 2:Add, Text, x980 y300 w300 h20 +BackgroundTrans , [%Partner%]
Gui, 2:Add, Text, x980 y330 w300 h20 +BackgroundTrans , [%Partner_Name_surname%]
Gui, 2:Add, Text, x980 y360 w300 h20 +BackgroundTrans , [%Floor%]
Gui, 2:Add, Text, x980 y390 w300 h20 +BackgroundTrans , [%Female%]


Gui, 2:Tab, 2
Gui, 2 :Add, Picture, x0 y30 w1300 h700, C:\Program Files (x86)\МЗ\AHK_1.jpg
Gui, 2:Font, S10 C000000
Gui, 2:Add, Text, x10 y60 w300 h20 cFF2400 +BackgroundTrans,  /Карта_1
Gui, 2:Add, Text, x10 y90 w300 h20 cFF2400 +BackgroundTrans ,  /Карта_2
Gui, 2:Add, Text, x10 y120 w300 h20 cFF2400 +BackgroundTrans , /КПК
Gui, 2:Add, Text, x10 y150 w300 h20 cFF2400 +BackgroundTrans , /АСМП_1
Gui, 2:Add, Text, x10 y180 w300 h20 cFF2400  +BackgroundTrans ,/АСМП_2
Gui, 2:Add, Text, x10 y210 w300 h20 cFF2400  +BackgroundTrans ,/АСМП_3
Gui, 2:Add, Text, x10 y240 w300 h20 cFF2400 +BackgroundTrans , /ЭКГ_1
Gui, 2:Add, Text, x10 y270 w300 h20 cFF2400  +BackgroundTrans ,/ЭКГ_2
Gui, 2:Add, Text, x10 y300 w300 h20 cFF2400  +BackgroundTrans ,/ЭКГ_3
Gui, 2:Add, Text, x10 y330 w300 h20 cFF2400 +BackgroundTrans , /Шприц 
Gui, 2:Add, Text, x10 y360 w300 h20 cFF2400 +BackgroundTrans , /Вакцинация
Gui, 2:Add, Text, x10 y390 w300 h20 cFF2400 +BackgroundTrans , /Зонд_1
Gui, 2:Add, Text, x10 y420 w300 h20 cFF2400 +BackgroundTrans , /Зонд_2
Gui, 2:Add, Text, x10 y450 w300 h20 cFF2400 +BackgroundTrans , /Зонд_3
Gui, 2:Add, Text, x10 y480 w300 h20 cFF2400 +BackgroundTrans , /Кровь
Gui, 2:Add, Text, x10 y510 w300 h20 cFF2400 +BackgroundTrans , /Рентген_1
Gui, 2:Add, Text, x10 y540 w300 h20 cFF2400 +BackgroundTrans , /Рентген_2
Gui, 2:Add, Text, x10 y570 w300 h20 cFF2400 +BackgroundTrans , /Рентген_3
Gui, 2:Add, Text, x10 y600 w300 h20 cFF2400 +BackgroundTrans , /Рентген_4
Gui, 2:Add, Text, x10 y630 w300 h20 cFF2400 +BackgroundTrans , /Донор

Gui, 2:Add, Text, x100 y60 w300 h20 +BackgroundTrans ,  [Взять мед. карту]
Gui, 2:Add, Text, x100 y90 w300 h20 +BackgroundTrans ,  [Вернуть мед. карту]
Gui, 2:Add, Text, x100 y120 w300 h20 +BackgroundTrans ,[КПК]
Gui, 2:Add, Text, x100 y150 w300 h20 +BackgroundTrans ,[АСМП погрузка]
Gui, 2:Add, Text, x100 y180 w300 h20 +BackgroundTrans , [АСМП выгрузка]
Gui, 2:Add, Text, x100 y210 w300 h20 +BackgroundTrans , [АСМП выгрузка оперепация]
Gui, 2:Add, Text, x100 y240 w300 h20 +BackgroundTrans , [ЭКГ]
Gui, 2:Add, Text, x100 y270 w300 h20 +BackgroundTrans , [ЭКГ удачно]
Gui, 2:Add, Text, x100 y300 w300 h20 +BackgroundTrans , [ЭКГ неудачно]
Gui, 2:Add, Text, x100 y330 w300 h20 +BackgroundTrans , [Аллергический приступ]
Gui, 2:Add, Text, x100 y360 w300 h20 +BackgroundTrans , [Вакцинация]
Gui, 2:Add, Text, x100 y390 w300 h20 +BackgroundTrans , [Взятие удачно]
Gui, 2:Add, Text, x100 y420 w300 h20 +BackgroundTrans , [Взятие неудачно]
Gui, 2:Add, Text, x100 y450 w300 h20 +BackgroundTrans , [Взятиенет проблем]
Gui, 2:Add, Text, x100 y480 w300 h20 +BackgroundTrans , [Внутреннее кровотечение]
Gui, 2:Add, Text, x100 y510 w300 h20 +BackgroundTrans , [Рентген конечности]
Gui, 2:Add, Text, x100 y540 w300 h20 +BackgroundTrans , [Рентген конечности лангетка]
Gui, 2:Add, Text, x100 y570 w300 h20 +BackgroundTrans , [Рентген конечности гипс]
Gui, 2:Add, Text, x100 y600 w300 h20 +BackgroundTrans , [Рентген конечности мазь]
Gui, 2:Add, Text, x100 y630 w300 h20 +BackgroundTrans , [Донорство]

Gui, 2:Add, Text, x400 y60 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y75 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y90 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y105 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y120 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y135 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y150 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y165 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y180 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y195 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y210 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y225 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y240 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y255 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y270 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y285 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y300 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y315 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y330 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y345 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y360 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y375 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y390 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y405 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y420 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y435 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y450 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y465 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y480 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y495 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y510 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y525 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y540 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y555 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y565 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y585 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y600 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y615 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y630 w300 h20 c000000 +BackgroundTrans, |

Gui, 2:Add, Text, x410  y60  w300 h20 cFF2400 +BackgroundTrans , /Мрт
Gui, 2:Add, Text, x410  y90  w300 h20  cFF2400 +BackgroundTrans, /Нож
Gui, 2:Add, Text, x410  y120 w300 h20 cFF2400 +BackgroundTrans, /Нос
Gui, 2:Add, Text, x410  y150 w300 h20 cFF2400 +BackgroundTrans, /Желудк
Gui, 2:Add, Text, x410  y180 w300 h20 cFF2400 +BackgroundTrans, /Аппендикс
Gui, 2:Add, Text, x410  y210 w300 h20 cFF2400 +BackgroundTrans, /Грудь
Gui, 2:Add, Text, x410  y240 w300 h20 cFF2400 +BackgroundTrans, /Прибор_1
Gui, 2:Add, Text, x410  y270 w300 h20 cFF2400 +BackgroundTrans, /Прибор_2
Gui, 2:Add, Text, x410  y300 w300 h20 cFF2400 +BackgroundTrans ,/Прибор_3
Gui, 2:Add, Text, x410  y330 w300 h20 cFF2400 +BackgroundTrans, /УЗИ
Gui, 2:Add, Text, x410  y360 w300 h20 cFF2400 +BackgroundTrans, /Пуля
Gui, 2:Add, Text, x410  y390 w300 h20 cFF2400 +BackgroundTrans, /Аппарат 
Gui, 2:Add, Text, x410  y420 w300 h20 cFF2400 +BackgroundTrans, /Чувства_1
Gui, 2:Add, Text, x410  y450 w300 h20 cFF2400 +BackgroundTrans, /Чувства_2
Gui, 2:Add, Text, x410  y480 w300 h20 cFF2400 +BackgroundTrans, /Чувства_3
Gui, 2:Add, Text, x410  y510 w300 h20 cFF2400 +BackgroundTrans, /Чувства_4
Gui, 2:Add, Text, x410  y540 w300 h20 cFF2400 +BackgroundTrans, /Чувства_5
Gui, 2:Add, Text, x410  y570 w300 h20 cFF2400 +BackgroundTrans, /Алкоголь_1
Gui, 2:Add, Text, x410  y600 w300 h20 cFF2400 +BackgroundTrans, /Алкоголь_2
Gui, 2:Add, Text, x410  y630 w300 h20 cFF2400 +BackgroundTrans, /Алкоголь_3

Gui, 2:Add, Text, x510 y60 w300 h20 +BackgroundTrans , [МРТ]
Gui, 2:Add, Text, x510 y90 w300 h20 +BackgroundTrans , [Ножевое ранение]
Gui, 2:Add, Text, x510 y120 w300 h20 +BackgroundTrans ,[Носовое кровотечение]
Gui, 2:Add, Text, x510 y150 w300 h20 +BackgroundTrans ,[Отравление желудка]
Gui, 2:Add, Text, x510 y180 w300 h20 +BackgroundTrans , [Удаление аппендицита]
Gui, 2:Add, Text, x510 y210 w300 h20 +BackgroundTrans , [Увеличение груди]
Gui, 2:Add, Text, x510 y240 w300 h20 +BackgroundTrans , [Томография]
Gui, 2:Add, Text, x510 y270 w300 h20 +BackgroundTrans , [Томография удачно]
Gui, 2:Add, Text, x510 y300 w300 h20 +BackgroundTrans , [Томография неудачно]
Gui, 2:Add, Text, x510 y330 w300 h20 +BackgroundTrans , [Узи]
Gui, 2:Add, Text, x510 y360 w300 h20 +BackgroundTrans , [Пулевое ранение]
Gui, 2:Add, Text, x510 y390 w300 h20 +BackgroundTrans , [Флюрография]
Gui, 2:Add, Text, x495 y420 w500 h20 +BackgroundTrans , [Приведение в чувства (Проверка пульса)]
Gui, 2:Add, Text, x495 y450 w500 h20 +BackgroundTrans , [Приведение в чувства (Пульс есть или когда появится)
Gui, 2:Add, Text, x495 y480 w500 h20 +BackgroundTrans , [Приведение в чувства (Пульса нет)]
Gui, 2:Add, Text, x495 y510 w500 h20 +BackgroundTrans , [Приведение в чувства (Если пульс не появился)]
Gui, 2:Add, Text, x495 y540 w500 h20 +BackgroundTrans , [Приведение в чувства (Когда появляется пульс)]
Gui, 2:Add, Text, x510 y570 w300 h20 +BackgroundTrans , [Проверка на алкоголь]
Gui, 2:Add, Text, x510 y600 w300 h20 +BackgroundTrans , [Проверка на алкоголь]
Gui, 2:Add, Text, x510 y630 w300 h20 +BackgroundTrans , [Алкоголь] (превышена норма)]

Gui, 2:Add, Text, x920 y60 w300 h20 +BackgroundTrans,  |
Gui, 2:Add, Text, x920 y75 w300 h20 +BackgroundTrans,  |
Gui, 2:Add, Text, x920 y90 w300 h20 +BackgroundTrans,  |
Gui, 2:Add, Text, x920 y105 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y120 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y135 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y150 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y165 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y180 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y195 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y210 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y225 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y240 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y255 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y270 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y285 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y300 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y315 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y330 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y345 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y360 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y375 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y390 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y405 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y420 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y435 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y450 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y465 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y480 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y495 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y510 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y525 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y540 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y555 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y565 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y585 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y600 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y615 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y630 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x920 y645 w300 h20 +BackgroundTrans, |


Gui, 2:Add, Text, x925 y60  w300 h20 cFF2400 +BackgroundTrans , /Алкоголь_4
Gui, 2:Add, Text, x925 y90  w300 h20 cFF2400 +BackgroundTrans , /Вши_1
Gui, 2:Add, Text, x925 y120 w300 h20 cFF2400 +BackgroundTrans , /Вши_2
Gui, 2:Add, Text, x925 y150 w300 h20 cFF2400 +BackgroundTrans , /Вши_3
Gui, 2:Add, Text, x925  y90 y180 w300 h20 cFF2400 +BackgroundTrans , /Открытый
Gui, 2:Add, Text, x925 y210 w300 h20 cFF2400 +BackgroundTrans , /Ожоги
Gui, 2:Add, Text, x925 y240 w300 h20 cFF2400 +BackgroundTrans , /Глисты_1
Gui, 2:Add, Text, x925 y270 w300 h20 cFF2400 +BackgroundTrans , /Глисты_2
Gui, 2:Add, Text, x925 y300 w300 h20 cFF2400 +BackgroundTrans , /Глисты_3
Gui, 2:Add, Text, x925 y330 w300 h20 cFF2400 +BackgroundTrans , /Глисты_4
Gui, 2:Add, Text, x925 y360 w300 h20 cFF2400 +BackgroundTrans , /Ребро_1
Gui, 2:Add, Text, x925 y390 w300 h20 cFF2400 +BackgroundTrans , /Ребро_2
Gui, 2:Add, Text, x925 y420 w300 h20 cFF2400 +BackgroundTrans , /Ребро_3
Gui, 2:Add, Text, x925 y450 w300 h20 cFF2400 +BackgroundTrans , /Позвоночник
Gui, 2:Add, Text, x925 y480 w300 h20 cFF2400 +BackgroundTrans , /Грыжа_1
Gui, 2:Add, Text, x925 y510 w300 h20 cFF2400 +BackgroundTrans , /AВД_1
Gui, 2:Add, Text, x925 y540 w300 h20 cFF2400 +BackgroundTrans , /AВД_2
Gui, 2:Add, Text, x925 y570 w300 h20 cFF2400 +BackgroundTrans , /AВД_3
Gui, 2:Add, Text, x925 y600 w300 h20 cFF2400 +BackgroundTrans , /AВД_4
Gui, 2:Add, Text, x925 y630 w300 h20 cFF2400 +BackgroundTrans ,  /Змея_1

Gui, 2:Add, Text, x1025  y60 w300 h20 +BackgroundTrans ,  [Алкоголь (не превышена норма)]
Gui, 2:Add, Text, x1025  y90 w300 h20 +BackgroundTrans ,  [Проверка на вши]
Gui, 2:Add, Text, x1025  y120 w300 h20 +BackgroundTrans , [Проверка удачно]
Gui, 2:Add, Text, x1025  y150 w300 h20 +BackgroundTrans , [Проверка неудачно]
Gui, 2:Add, Text, x1025  y180 w300 h20 +BackgroundTrans , [Открытый]
Gui, 2:Add, Text, x1025  y210 w300 h20 +BackgroundTrans , [Ожоги]
Gui, 2:Add, Text, x1025  y240 w300 h20 +BackgroundTrans , [Проверка на глисты]
Gui, 2:Add, Text, x1025  y270 w300 h20 +BackgroundTrans , [Проверка на глисты]
Gui, 2:Add, Text, x1025  y300 w300 h20 +BackgroundTrans , [Проверка на глисты удачно]
Gui, 2:Add, Text, x1025  y330 w300 h20 +BackgroundTrans , [Проверка на глисты неудачно]
Gui, 2:Add, Text, x1025  y360 w300 h20 +BackgroundTrans , [Перелом рёбер]
Gui, 2:Add, Text, x1025  y390 w300 h20 +BackgroundTrans , [Перелом рёбер есть  удачно]
Gui, 2:Add, Text, x1025  y420 w300 h20 +BackgroundTrans , [Перелом рёбер нет неудачно]
Gui, 2:Add, Text, x1025  y450 w300 h20 +BackgroundTrans , [Перелом позвоночника]
Gui, 2:Add, Text, x1025  y480 w300 h20 +BackgroundTrans,  [Уёёдаление позвоночной грыжи]
Gui, 2:Add, Text, x980 y510 w300 h20 +BackgroundTrans , [Дефибриллятор (Снять одежду)]
Gui, 2:Add, Text, x980 y540 w300 h20 +BackgroundTrans , [Дефибриллятор (Проверка пульса)]
Gui, 2:Add, Text, x980 y570 w300 h20 +BackgroundTrans , [Дефибриллятор (Пульса нет)]
Gui, 2:Add, Text, x980 y600 w500 h20 +BackgroundTrans , [Дефибриллятор (Когда появится, был)]
Gui, 2:Add, Text, x1025  y630 w300 h20 +BackgroundTrans , [Действия при укусе змеи]



Gui, 2:Tab, 3
Gui, 2 :Add, Picture, x0 y30 w1300 h700, C:\Program Files (x86)\МЗ\AHK_1.jpg
Gui, 2:Font, S10 C000000
Gui, 2:Add, Text, x10 y60 w300 h20 cFF2400 +BackgroundTrans,  /Cколиоз_1
Gui, 2:Add, Text, x10 y90 w300 h20 cFF2400 +BackgroundTrans , /Cколиоз_2
Gui, 2:Add, Text, x10 y120 w300 h20 cFF2400 +BackgroundTrans , /Cколиоз_3
Gui, 2:Add, Text, x10 y150 w300 h20 cFF2400 +BackgroundTrans , /Наркотики_1
Gui, 2:Add, Text, x10 y180 w300 h20 cFF2400  +BackgroundTrans ,/Наркотики_2
Gui, 2:Add, Text, x10 y210 w300 h20 cFF2400  +BackgroundTrans ,/Наркотики_3
Gui, 2:Add, Text, x10 y240 w300 h20 cFF2400 +BackgroundTrans , /Наркотики_4
Gui, 2:Add, Text, x10 y270 w300 h20 cFF2400  +BackgroundTrans ,/Капельница
Gui, 2:Add, Text, x10 y300 w300 h20 cFF2400  +BackgroundTrans ,/Палец_1
Gui, 2:Add, Text, x10 y330 w300 h20 cFF2400 +BackgroundTrans , /Палец_2
Gui, 2:Add, Text, x10 y360 w300 h20 cFF2400 +BackgroundTrans , /Палец_3
Gui, 2:Add, Text, x10 y390 w300 h20 cFF2400 +BackgroundTrans , /Палец_4
Gui, 2:Add, Text, x10 y420 w300 h20 cFF2400 +BackgroundTrans , /Палец_5
Gui, 2:Add, Text, x10 y450 w300 h20 cFF2400 +BackgroundTrans , /Палец_6
Gui, 2:Add, Text, x10 y480 w300 h20 cFF2400 +BackgroundTrans , /ФГДС_1
Gui, 2:Add, Text, x10 y510 w300 h20 cFF2400 +BackgroundTrans , /ФГДС_2
Gui, 2:Add, Text, x10 y540 w300 h20 cFF2400 +BackgroundTrans , /Роды_1
Gui, 2:Add, Text, x10 y570 w300 h20 cFF2400 +BackgroundTrans , /Роды_2
Gui, 2:Add, Text, x10 y600 w300 h20 cFF2400 +BackgroundTrans , /Вздутие_1
Gui, 2:Add, Text, x10 y630 w300 h20 cFF2400 +BackgroundTrans , /Вздутие_2


Gui, 2:Add, Text, x120 y60 w300 h20 +BackgroundTrans , [Проверка на сколиоз]
Gui, 2:Add, Text, x120 y90 w300 h20 +BackgroundTrans , [Проверка на сколиоз  удачно]
Gui, 2:Add, Text, x120 y120 w300 h20 +BackgroundTrans , [Проверка на сколиоз неудачно]
Gui, 2:Add, Text, x120 y150 w300 h20 +BackgroundTrans , [Проверка на наркотики]
Gui, 2:Add, Text, x120 y180 w300 h20 +BackgroundTrans , [Проверка на наркотики]
Gui, 2:Add, Text, x120 y210 w300 h20 +BackgroundTrans , [Проверка на наркотики удачно]
Gui, 2:Add, Text, x120 y240 w300 h20 +BackgroundTrans , [Проверка на наркотики неудачно]
Gui, 2:Add, Text, x120 y270 w300 h20 +BackgroundTrans , [Капельница]
Gui, 2:Add, Text, x120 y300 w300 h20 +BackgroundTrans , [Взятие крови из пальца]
Gui, 2:Add, Text, x120 y330 w300 h20 +BackgroundTrans , [Взятие крови из пальца]
Gui, 2:Add, Text, x120 y360 w300 h20 +BackgroundTrans , [Взятие крови из пальца]
Gui, 2:Add, Text, x120 y390 w300 h20 +BackgroundTrans , [Взятие крови из пальца]
Gui, 2:Add, Text, x120 y420 w300 h20 +BackgroundTrans , [Взятие крови из пальца]
Gui, 2:Add, Text, x120 y450 w300 h20 +BackgroundTrans , [Взятие крови из пальца]
Gui, 2:Add, Text, x120 y480 w300 h20 +BackgroundTrans , [Гастроскопия]
Gui, 2:Add, Text, x120 y510 w300 h20 +BackgroundTrans , [Гастроскопия]
Gui, 2:Add, Text, x120 y540 w300 h20 +BackgroundTrans , [Принятиеродов]
Gui, 2:Add, Text, x120 y570 w300 h20 +BackgroundTrans , [Принятие родов]
Gui, 2:Add, Text, x120 y600 w300 h20 +BackgroundTrans , [Вздутие]
Gui, 2:Add, Text, x120 y630 w300 h20 +BackgroundTrans , [Вздутие]

Gui, 2:Add, Text, x400 y60 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y75 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y90 w300 h20 c000000 +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y105 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y120 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y135 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y150 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y165 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y180 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y195 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y210 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y225 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y240 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y255 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y270 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y285 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y300 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y315 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y330 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y345 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y360 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y375 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y390 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y405 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y420 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y435 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y450 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y465 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y480 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y495 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y510 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y525 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y540 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y555 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y565 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y585 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y600 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y615 w300 h20 c000000 +BackgroundTrans, |
Gui, 2:Add, Text, x400 y630 w300 h20 c000000 +BackgroundTrans, |


Gui, 2:Add, Text, x410 y60  w300 h20 cFF2400  +BackgroundTrans , /Матка_1
Gui, 2:Add, Text, x410 y90  w300 h20 cFF2400  +BackgroundTrans , /Матка_2
Gui, 2:Add, Text, x410 y120 w300 h20 cFF2400 +BackgroundTrans , /Матка_3
Gui, 2:Add, Text, x410 y150 w300 h20 cFF2400 +BackgroundTrans , /Матка_4
Gui, 2:Add, Text, x410 y180 w300 h20 cFF2400 +BackgroundTrans , /Матка_5
Gui, 2:Add, Text, x410  y210 w300 h20 cFF2400 +BackgroundTrans, /Цистоскоп_1
Gui, 2:Add, Text, x410  y240 w300 h20 cFF2400 +BackgroundTrans, /Цистоскоп_2
Gui, 2:Add, Text, x410  y270 w300 h20 cFF2400 +BackgroundTrans, /Цистоскоп_3
Gui, 2:Add, Text, x410  y300 w300 h20 cFF2400 +BackgroundTrans ,/Цистоскоп_4
Gui, 2:Add, Text, x410  y330 w300 h20 cFF2400 +BackgroundTrans, /Цистоскоп_5
Gui, 2:Add, Text, x410  y360 w300 h20 cFF2400 +BackgroundTrans, /Плод_1
Gui, 2:Add, Text, x410  y390 w300 h20 cFF2400 +BackgroundTrans, /Плод_2
Gui, 2:Add, Text, x410  y420 w300 h20 cFF2400 +BackgroundTrans, /Плод_3
Gui, 2:Add, Text, x410  y450 w300 h20 cFF2400 +BackgroundTrans, /Плод_4
Gui, 2:Add, Text, x410 y480 w300 h20 cFF2400 +BackgroundTrans,  /Плод_5
Gui, 2:Add, Text, x410 y510 w300 h20 cFF2400 +BackgroundTrans, /ВМС_1
Gui, 2:Add, Text, x410 y540 w300 h20  cFF2400 +BackgroundTrans,/ВМС_2
Gui, 2:Add, Text, x410 y570 w300 h20 cFF2400 +BackgroundTrans , /Сахар_1
Gui, 2:Add, Text, x410 y600 w300 h20 cFF2400 +BackgroundTrans , /Сахар_2 
Gui, 2:Add, Text, x410 y630 w300 h20 cFF2400 +BackgroundTrans , /Сахар_3


Gui, 2:Add, Text, x520 y60 w300 h20 +BackgroundTrans ,  [Гистероскопия]
Gui, 2:Add, Text, x520 y90 w300 h20 +BackgroundTrans ,  [Гистероскопия]
Gui, 2:Add, Text, x520 y120 w300 h20 +BackgroundTrans , [Гистероскопия удачно]
Gui, 2:Add, Text, x520 y150 w300 h20 +BackgroundTrans , [Гистероскопия неудачно]
Gui, 2:Add, Text, x520 y180 w300 h20 +BackgroundTrans , [Гистероскопия]
Gui, 2:Add, Text, x520 y210 w300 h20 +BackgroundTrans , [Цистоскопия]
Gui, 2:Add, Text, x520 y240 w300 h20 +BackgroundTrans , [Цистоскопия]
Gui, 2:Add, Text, x520 y270 w300 h20 +BackgroundTrans , [Цистоскопия удачно]
Gui, 2:Add, Text, x520 y300 w300 h20 +BackgroundTrans , [Цистоскопия неудачно]
Gui, 2:Add, Text, x520 y330 w300 h20 +BackgroundTrans , [Цистоскопия]
Gui, 2:Add, Text, x520 y360 w300 h20 +BackgroundTrans,  [Фетоскопия]
Gui, 2:Add, Text, x520 y390 w300 h20 +BackgroundTrans,  [Фетоскопия]
Gui, 2:Add, Text, x520 y420 w300 h20 +BackgroundTrans,  [Фетоскопия]
Gui, 2:Add, Text, x520 y450 w300 h20 +BackgroundTrans,  [Фетоскопия]
Gui, 2:Add, Text, x520 y480 w300 h20 +BackgroundTrans,  [Фетоскопия]
Gui, 2:Add, Text, x520 y510 w300 h20 +BackgroundTrans,  [Внутриматочная спираль]
Gui, 2:Add, Text, x520 y540 w300 h20 +BackgroundTrans,  [Внутриматочная спираль]
Gui, 2:Add, Text, x520 y570 w300 h20 +BackgroundTrans , [Анализ сахара в крови]
Gui, 2:Add, Text, x520 y600 w300 h20 +BackgroundTrans , [Анализ сахара в крови]
Gui, 2:Add, Text, x520 y630 w300 h20 +BackgroundTrans , [Анализ сахара в крови удачно]

Gui, 2:Add, Text, x780 y60 w300 h20 +BackgroundTrans,  |
Gui, 2:Add, Text, x780 y75 w300 h20 +BackgroundTrans,  |
Gui, 2:Add, Text, x780 y90 w300 h20 +BackgroundTrans,  |
Gui, 2:Add, Text, x780 y105 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y120 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y135 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y150 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y165 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y180 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y195 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y210 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y225 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y240 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y255 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y270 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y285 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y300 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y315 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y330 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y345 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y360 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y375 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y390 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y405 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y420 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y435 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y450 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y465 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y480 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y495 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y510 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y525 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y540 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y555 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y565 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y585 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y600 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y615 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y630 w300 h20 +BackgroundTrans, |
Gui, 2:Add, Text, x780 y645 w300 h20 +BackgroundTrans, |


Gui, 2:Add, Text, x790 y60  w300 h20 cFF2400  +BackgroundTrans ,  /Сахар_4
Gui, 2:Add, Text, x790 y90  w300 h20 cFF2400  +BackgroundTrans , /Зрения_1
Gui, 2:Add, Text, x790 y120 w300 h20 cFF2400 +BackgroundTrans , /Зрения_2
Gui, 2:Add, Text, x790 y150 w300 h20 cFF2400 +BackgroundTrans , /Зрения_3
Gui, 2:Add, Text, x790 y180 w300 h20 cFF2400 +BackgroundTrans , /Зрения_4
Gui, 2:Add, Text, x790 y210 w300 h20 cFF2400 +BackgroundTrans , /Зрения_5
Gui, 2:Add, Text, x790 y240 w300 h20 cFF2400 +BackgroundTrans , /Зрения_6
Gui, 2:Add, Text, x790 y270 w300 h20 cFF2400 +BackgroundTrans , /Зрения_7
Gui, 2:Add, Text, x790 y300 w300 h20 cFF2400 +BackgroundTrans , /Зрения_8
Gui, 2:Add, Text, x790 y330 w300 h20 cFF2400 +BackgroundTrans , /ФКС_1
Gui, 2:Add, Text, x790 y360 w300 h20 cFF2400 +BackgroundTrans , /ФКС_2
Gui, 2:Add, Text, x790 y390 w300 h20 cFF2400 +BackgroundTrans , /ФКС_3
Gui, 2:Add, Text, x790 y420 w300 h20 cFF2400 +BackgroundTrans ,  /Клизма_1
Gui, 2:Add, Text, x790 y450 w300 h20 cFF2400 +BackgroundTrans , /Клизма_2
Gui, 2:Add, Text, x790 y480 w300 h20 cFF2400 +BackgroundTrans , /Температура_1
Gui, 2:Add, Text, x790 y510 w300 h20 cFF2400 +BackgroundTrans , /Температура_2
Gui, 2:Add, Text, x790 y540 w300 h20 cFF2400 +BackgroundTrans ,  /Температура_3
Gui, 2:Add, Text, x790 y570 w300 h20 cFF2400 +BackgroundTrans , /Стерилизация 
Gui, 2:Add, Text, x790 y600 w300 h20 cFF2400 +BackgroundTrans , /Вена_1
Gui, 2:Add, Text, x790 y630 w300 h20 cFF2400 +BackgroundTrans , /Вена_2

Gui, 2:Add, Text, x920 y60 w300 h20 +BackgroundTrans ,   [Анализ сахара неудачно]
Gui, 2:Add, Text, x920 y90 w300 h20 +BackgroundTrans ,  [Проверка зрения]
Gui, 2:Add, Text, x920 y120 w300 h20 +BackgroundTrans , [Проверка зрения]
Gui, 2:Add, Text, x920 y150 w300 h20 +BackgroundTrans , [Проверка зрения]
Gui, 2:Add, Text, x920 y180 w300 h20 +BackgroundTrans , [Проверка зрения]
Gui, 2:Add, Text, x920 y210 w300 h20 +BackgroundTrans , [Проверка зрения]
Gui, 2:Add, Text, x920 y240 w300 h20 +BackgroundTrans , [Проверка зрения]
Gui, 2:Add, Text, x920 y270 w300 h20 +BackgroundTrans , [Проверка зрения]
Gui, 2:Add, Text, x920 y300 w300 h20 +BackgroundTrans , [Проверка зрения]
Gui, 2:Add, Text, x920 y330 w300 h20 +BackgroundTrans , [Колоноскопия]
Gui, 2:Add, Text, x920 y360 w300 h20 +BackgroundTrans , [Колоноскопия удачно]
Gui, 2:Add, Text, x920 y390 w300 h20 +BackgroundTrans , [Колоноскопия неудачно]
Gui, 2:Add, Text, x920 y420 w300 h20 +BackgroundTrans , [Клизма]
Gui, 2:Add, Text, x920 y450 w300 h20 +BackgroundTrans , [Клизма]
Gui, 2:Add, Text, x920 y480 w300 h20 +BackgroundTrans,  [Измерить температуру]
Gui, 2:Add, Text, x920 y510 w300 h20 +BackgroundTrans , [Измерить температуру удачно]
Gui, 2:Add, Text, x920 y540 w300 h20 +BackgroundTrans , [Измерить температуру неудачно]
Gui, 2:Add, Text, x920 y570 w300 h20 +BackgroundTrans , [Стерилизация женщины]
Gui, 2:Add, Text, x920 y600 w300 h20 +BackgroundTrans , [Взятие крови из вены]
Gui, 2:Add, Text, x920 y630 w300 h20 +BackgroundTrans , [Взятие крови из вены]



Gui, 2:Tab, 4
Gui, 2 :Add, Picture, x0 y30 w1300 h700, C:\Program Files (x86)\МЗ\AHK_1.jpg
Gui, 2:Font, S10 C000000
Gui, 2:Add, Text, x10 y60  w300 h20 cFF2400 +BackgroundTrans,   /Голова
Gui, 2:Add, Text, x10 y90  w300 h20 cFF2400  +BackgroundTrans,   /живот
Gui, 2:Add, Text, x10 y120 w300 h20 cFF2400  +BackgroundTrans,   /диарея
Gui, 2:Add, Text, x10 y150 w300 h20 cFF2400  +BackgroundTrans,   /потенция
Gui, 2:Add, Text, x10 y180 w300 h20 cFF2400  +BackgroundTrans,   /геморрой
Gui, 2:Add, Text, x10 y210 w300 h20 cFF2400  +BackgroundTrans,   /ушиб
Gui, 2:Add, Text, x10 y240 w300 h20 cFF2400  +BackgroundTrans,   /ожог
Gui, 2:Add, Text, x10 y270 w300 h20 cFF2400  +BackgroundTrans,   /витамин
Gui, 2:Add, Text, x10 y300 w300 h20 cFF2400  +BackgroundTrans,   /тошнота
Gui, 2:Add, Text, x10 y330 w300 h20 cFF2400  +BackgroundTrans,   /изжога
Gui, 2:Add, Text, x10 y360 w300 h20 cFF2400  +BackgroundTrans,   /насморк
Gui, 2:Add, Text, x10 y390 w300 h20 cFF2400  +BackgroundTrans,   /мигрень
Gui, 2:Add, Text, x10 y420 w300 h20 cFF2400  +BackgroundTrans,   /мочевой
Gui, 2:Add, Text, x10 y450 w300 h20 cFF2400  +BackgroundTrans,   /печень
Gui, 2:Add, Text, x10 y480 w300 h20 cFF2400  +BackgroundTrans,   /aллергия
Gui, 2:Add, Text, x10 y510 w300 h20 cFF2400  +BackgroundTrans,   /сердце
Gui, 2:Add, Text, x10 y540 w300 h20 cFF2400  +BackgroundTrans,   /простуда
Gui, 2:Add, Text, x10 y570 w300 h20 cFF2400  +BackgroundTrans,   /кашельс
Gui, 2:Add, Text, x10 y600 w300 h20 cFF2400  +BackgroundTrans,   /кашельв
Gui, 2:Add, Text, x10 y630 w300 h20 cFF2400  +BackgroundTrans,   /диабет

Gui, 2:Add, Text, x400 y60 w300 h20 c000000   +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y75 w300 h20 c000000   +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y90 w300 h20 c000000   +BackgroundTrans,  |
Gui, 2:Add, Text, x400 y105 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y120 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y135 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y150 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y165 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y180 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y195 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y210 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y225 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y240 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y255 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y270 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y285 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y300 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y315 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y330 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y345 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y360 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y375 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y390 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y405 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y420 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y435 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y450 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y465 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y480 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y495 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y510 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y525 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y540 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y555 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y565 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y585 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y600 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y615 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x400 y630 w300 h20 c000000   +BackgroundTrans, |

Gui, 2:Add, Text, x100 y60 w300 h20 c000000   +BackgroundTrans,  [Выписать:Миг]
Gui, 2:Add, Text, x100  y90 w300 h20 c000000   +BackgroundTrans, [Выписать:Но-Шпу]
Gui, 2:Add, Text, x100  y120 w300 h20 c000000   +BackgroundTrans, [Выписать:Активированый уголь]
Gui, 2:Add, Text, x100  y150 w300 h20 c000000   +BackgroundTrans, [Выписать:Виагру]
Gui, 2:Add, Text, x100 y180 w300 h20  c000000   +BackgroundTrans, [Выписать:Свечи Релиф]
Gui, 2:Add, Text, x100  y210 w300 h20 c000000   +BackgroundTrans, [Выписать:Фастум-гель]
Gui, 2:Add, Text, x100  y240 w300 h20 c000000   +BackgroundTrans, [Выписать:Пантенол]
Gui, 2:Add, Text, x100 y270 w300 h20  c000000   +BackgroundTrans, [Выписать:Унивит]
Gui, 2:Add, Text, x100 y300 w300 h20  c000000   +BackgroundTrans, [Выписать:Церукал]
Gui, 2:Add, Text, x100  y330 w300 h20 c000000   +BackgroundTrans, [Выписать:Омепразол]
Gui, 2:Add, Text, x100 y360 w300 h20  c000000   +BackgroundTrans, [Выписать:Отривин]
Gui, 2:Add, Text, x100 y390 w300 h20  c000000   +BackgroundTrans, [Выписать:Амигренин]
Gui, 2:Add, Text, x100 y420 w300 h20  c000000   +BackgroundTrans, [Выписать:Цистон]
Gui, 2:Add, Text, x100 y450 w300 h20  c000000   +BackgroundTrans, [Выписать:Гепабене]
Gui, 2:Add, Text, x100 y480 w300 h20  c000000   +BackgroundTrans, [Выписать:Зодак]
Gui, 2:Add, Text, x100 y510 w300 h20  c000000   +BackgroundTrans, [Выписать:Кардиомагнил]
Gui, 2:Add, Text, x100 y540 w300 h20  c000000   +BackgroundTrans, [Выписать:Терафлю]
Gui, 2:Add, Text, x100 y570 w300 h20  c000000   +BackgroundTrans, [Выписать:Лазолван]
Gui, 2:Add, Text, x100 y600 w300 h20  c000000   +BackgroundTrans, [Выписать:Амбробене]
Gui, 2:Add, Text, x100 y630 w300 h20  c000000   +BackgroundTrans, [Выписать:Диабетон]

Gui, 2:Add, Text, x410 y60 w300 h20 cFF2400 +BackgroundTrans, /горло
Gui, 2:Add, Text, x410 y90 w300 h20 cFF2400 +BackgroundTrans, /глаза
Gui, 2:Add, Text, x410 y120 w300 h20 cFF2400 +BackgroundTrans, /судороги
Gui, 2:Add, Text, x410 y150 w300 h20 cFF2400 +BackgroundTrans, /уши
Gui, 2:Add, Text, x410 y180 w300 h20 cFF2400 +BackgroundTrans, /почки
Gui, 2:Add, Text, x410 y210 w300 h20 cFF2400 +BackgroundTrans, /суставы
Gui, 2:Add, Text, x410 y240 w300 h20 cFF2400 +BackgroundTrans, /давлениев
Gui, 2:Add, Text, x410 y270 w300 h20 cFF2400 +BackgroundTrans, /давлениен
Gui, 2:Add, Text, x410 y300 w300 h20 cFF2400 +BackgroundTrans, /яйца
Gui, 2:Add, Text, x410 y330 w300 h20 cFF2400 +BackgroundTrans, /сон
Gui, 2:Add, Text, x410 y360 w300 h20 cFF2400 +BackgroundTrans, /зрение
Gui, 2:Add, Text, x410 y390 w300 h20 cFF2400 +BackgroundTrans, /память
Gui, 2:Add, Text, x410 y420 w300 h20 cFF2400 +BackgroundTrans, /укачивание
Gui, 2:Add, Text, x410 y450 w300 h20 cFF2400 +BackgroundTrans, /курение
Gui, 2:Add, Text, x510 y60 w300 h20 c000000 +BackgroundTrans, [Выписать:Гексорал]
Gui, 2:Add, Text, x510 y90 w300 h20 c000000 +BackgroundTrans, [Выписать:Визин]
Gui, 2:Add, Text, x510 y120 w300 h20 c000000 +BackgroundTrans, [Выписать:Магнелис]
Gui, 2:Add, Text, x510 y150 w300 h20 c000000 +BackgroundTrans, [Выписать:Отинум
Gui, 2:Add, Text, x510 y180 w300 h20 c000000 +BackgroundTrans, [Выписать:Уролисан]
Gui, 2:Add, Text, x510 y210 w300 h20 c000000 +BackgroundTrans, [Выписать:Фастум-гель]
Gui, 2:Add, Text, x510 y240 w300 h20 c000000 +BackgroundTrans, [Выписать:Андипал]
Gui, 2:Add, Text, x510 y270 w300 h20 c000000 +BackgroundTrans, [Выписать:Норадреналин]
Gui, 2:Add, Text, x510 y300 w300 h20 c000000 +BackgroundTrans, [Выписать:Амоксиклав]
Gui, 2:Add, Text, x510 y330 w300 h20 c000000 +BackgroundTrans, [Выписать:Персен Ночь]
Gui, 2:Add, Text, x510 y360 w300 h20 c000000 +BackgroundTrans, [Выписать:Виталюкс]
Gui, 2:Add, Text, x510 y390 w300 h20 c000000 +BackgroundTrans, [Выписать:Эвалар]
Gui, 2:Add, Text, x510 y420 w300 h20 c000000 +BackgroundTrans, [Выписать:Драмина]
Gui, 2:Add, Text, x510 y450 w300 h20 c000000 +BackgroundTrans, [Выписать:Табекс]

Gui, 2:Add, Text, x800 y60 w300 h20 c000000   +BackgroundTrans,  |
Gui, 2:Add, Text, x800 y75 w300 h20 c000000   +BackgroundTrans,  |
Gui, 2:Add, Text, x800 y90 w300 h20 c000000   +BackgroundTrans,  |
Gui, 2:Add, Text, x800 y105 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y120 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y135 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y150 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y165 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y180 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y195 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y210 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y225 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y240 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y255 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y270 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y285 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y300 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y315 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y330 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y345 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y360 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y375 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y390 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y405 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y420 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y435 w300 h20 c000000   +BackgroundTrans, |
Gui, 2:Add, Text, x800 y450 w300 h20 c000000   +BackgroundTrans, |




Gui,2: Tab, 5
Gui,2: Font, S10 C000000
Gui,2: Add, Text, x10 y60 w300 h20    cFF2400 +BackgroundTrans,  Путь к файлу:

Gui, 2:Add, Button, x10 y630 w200 h20 gButtonOpenGuiLecture,  Открыть файл   
Gui,2: Add, Text, x120 y60 w1220 h20 vEditLectureFile ReadOnly +BackgroundTrans,
Gui,2: Add, Edit, x0 y90 w1300 h500 vEditPreviewFile ReadOnly,



Gui, 2:Tab
Gui, 2:Font, s12
Gui, 2:Add, Text, x10 y670 w1220 h20 c000000 +BackgroundTrans, ✅ КПРП 2019-2021. Demo 10.5 Нажмите alt+p для паузы скрипта, для закрытия alt+o, для перезагрузки alt+i.


Return
ButtonOpenGuiLecture:
FileEncoding, UTF-8
FileSelectFile, LectureFile, 3, %A_WorkingDir%, , Текстовые файлы (*.txt)
Gui, GuiLecture:Submit, NoHide
GuiControl,, EditLectureFile,  %LectureFile%
Goto, PreviewFileGuiLecture
PreviewFileGuiLecture:
FileRead, PreviewFileText, %LectureFile%
Gui, GuiLecture:Submit, NoHide
GuiControl,, EditPreviewFile, %PreviewFileText%
Return
:?:/кпрп::
SendInput, {F6} {Enter}
Sleep 4000
FileEncoding, UTF-8-RAW
Loop{
FileReadLine, LectureFileLine, %LectureFile%, %A_Index%
If ErrorLevel{
Break
}
Else If (LectureFileLine=="end"){
Break
}
Else{
Clipboard :=
SendInput, {F6}%LectureFileLine%{Enter}
Sleep 4000
}
}
Return





