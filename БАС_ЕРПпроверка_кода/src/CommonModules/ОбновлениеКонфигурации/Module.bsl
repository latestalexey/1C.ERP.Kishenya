////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление конфигурации".
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// КЛИЕНТСКИЕ ОБРАБОТЧИКИ.
	
	КлиентскиеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриНачалеРаботыСистемы"].Добавить(
			"ОбновлениеКонфигурацииКлиент");
	
	КлиентскиеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриПолученииСпискаПредупрежденийЗавершенияРаботы"].Добавить(
			"ОбновлениеКонфигурацииКлиент");
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентаПриЗапуске"].Добавить(
		"ОбновлениеКонфигурации");
	
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиента"].Добавить(
		"ОбновлениеКонфигурации");
	
	СерверныеОбработчики["СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
		"ОбновлениеКонфигурации");
	
КонецПроцедуры

// Получить глобальные настройки обновления на сеанс платформы.
//
Функция ПолучитьНастройкиОбновления() Экспорт
	
	ЕстьДоступДляОбновления = ПроверитьДоступДляОбновления();
	ЕстьДоступДляПроверкиОбновления = Пользователи.РолиДоступны("ПроверкаДоступныхОбновленийКонфигурации")
		И ТипЗнч(Пользователи.АвторизованныйПользователь()) = Тип("СправочникСсылка.Пользователи");
	
	КонфигурацияИзменена = ?(ЕстьДоступДляОбновления Или ЕстьДоступДляПроверкиОбновления, КонфигурацияИзменена(), Ложь);
	
	СтруктураНастройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ОбновлениеКонфигурации", "НастройкиОбновленияКонфигурации");
	
	Настройки = Новый Структура;
	Настройки.Вставить("КороткоеИмяКонфигурации",                  КороткоеИмяКонфигурации(СтруктураНастройки));
	Настройки.Вставить("АдресСервераДляПроверкиНаличияОбновления", АдресСервераДляПроверкиНаличияОбновления(СтруктураНастройки));
	Настройки.Вставить("КаталогОбновлений",                        КаталогОбновлений(СтруктураНастройки));
	Настройки.Вставить("АдресРесурсаДляПроверкиНаличияОбновления", АдресРесурсаДляПроверкиНаличияОбновления(СтруктураНастройки));
	Настройки.Вставить("АдресСервисаПроверкиЛегальности",          АдресСервисаПроверкиЛегальности());
	Настройки.Вставить("КонфигурацияИзменена",                     КонфигурацияИзменена);
	Настройки.Вставить("ПроверитьПрошлыеОбновленияБазы",           ОбновлениеКонфигурацииУспешно() <> Неопределено);
	Настройки.Вставить("ЕстьДоступДляОбновления",                  ЕстьДоступДляОбновления);
	Настройки.Вставить("ЕстьДоступДляПроверкиОбновления",          ЕстьДоступДляПроверкиОбновления);
	
	Настройки.Вставить("НастройкиОбновленияКонфигурации", ПолучитьСтруктуруНастроекПомощника());
	
	Возврат Настройки;
	
КонецФункции

// Вызывается при завершении обновления конфигурации через COM-соединение.
//
// Параметры:
//  РезультатОбновления  - Булево - Результат обновления.
//
Процедура ЗавершитьОбновление(Знач РезультатОбновления, Знач ЭлектроннаяПочта, Знач ИмяАдминистратораОбновления) Экспорт

	ТекстСообщения = НСтр("ru='Завершение обновления из внешнего скрипта.';uk='Завершення оновлення із зовнішнього скрипта.'");
	ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,,,ТекстСообщения);
	
	Если НЕ ПроверитьДоступДляОбновления() Тогда
		ТекстСообщения = НСтр("ru='Недостаточно прав для завершения обновления конфигурации.';uk='Недостатньо прав для завершення оновлення конфігурації.'");
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,,ТекстСообщения);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	ЗаписатьСтатусОбновления(ИмяАдминистратораОбновления, Ложь, Истина, РезультатОбновления);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями")
		И Не ПустаяСтрока(ЭлектроннаяПочта) Тогда
		Попытка
			ОтправитьУведомлениеОбОбновлении(ИмяАдминистратораОбновления, ЭлектроннаяПочта, РезультатОбновления);
			ТекстСообщения = НСтр("ru='Уведомление об обновлении успешно отправлено на адрес электронной почты:';uk='Повідомлення про оновлення успішно відправлено на адресу електронної пошти:'")
				+ " " + ЭлектроннаяПочта;
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,,,ТекстСообщения);
		Исключение
			ТекстСообщения = НСтр("ru='Ошибка при отправке письма электронной почты:';uk='Помилка при відправленні листа електронної пошти:'")
				+ " " + ЭлектроннаяПочта + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,,ТекстСообщения);
		КонецПопытки;
	КонецЕсли;
	
	Если РезультатОбновления Тогда
		
		ОбновлениеИнформационнойБазыСлужебный.ПослеЗавершенияОбновления();
		
	КонецЕсли;
	
КонецПроцедуры

// Получает из хранилища общих настроек настройки обновления конфигурации.
Функция ПолучитьСтруктуруНастроекПомощника() Экспорт
	
	Расписание = Неопределено;
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ОбновлениеКонфигурации", "НастройкиОбновленияКонфигурации");
	
	Если Настройки = Неопределено Тогда
		КоличествоСтарыхНастроек = 0;
	ИначеЕсли ТипЗнч(Настройки) = Тип("Структура") ИЛИ ТипЗнч(Настройки) = Тип("Соответствие") Тогда
		КоличествоСтарыхНастроек = Настройки.Количество();
	Иначе
		КоличествоСтарыхНастроек = 0;
	КонецЕсли;
	Настройки = ОбновлениеКонфигурацииКлиентСервер.ПолучитьОбновленныеНастройкиОбновленияКонфигурации(Настройки);
	// Если появились новые настройки, то их нужно сохранить.
	Если Настройки.Количество() > КоличествоСтарыхНастроек Тогда
		УстановитьПривилегированныйРежим(Истина);
		ЗаписатьСтруктуруНастроекПомощника(Настройки);	
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	// Если в ранних версиях было сохранено расписание, и еще не отработал обработчик
	// обновления ОбновлениеРасписанияПроверкиНаличияОбновления, то...
	Если Настройки <> Неопределено И Настройки.Свойство("РасписаниеПроверкиНаличияОбновления", Расписание) 
		И ТипЗнч(Расписание) = Тип("РасписаниеРегламентногоЗадания") Тогда
		Настройки.РасписаниеПроверкиНаличияОбновления = ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Расписание);
	КонецЕсли;
	Возврат Настройки;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов из других подсистем.

// Вызывается не через событие, т.к. нужно сделать вызов самым последним.
//
Процедура ПослеОбновленияИнформационнойБазы() Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеХранилища = Константы.СтатусОбновленияКонфигурации.Получить();
	
	Статус = Неопределено;
	Если ЗначениеХранилища <> Неопределено Тогда
		Статус = ЗначениеХранилища.Получить();
	КонецЕсли;
	
	Если Статус <> Неопределено И Статус.ОбновлениеВыполнено И Статус.РезультатОбновленияКонфигурации <> Неопределено
		И Не Статус.РезультатОбновленияКонфигурации Тогда
		
		Статус.РезультатОбновленияКонфигурации = Истина;
		Константы.СтатусОбновленияКонфигурации.Установить(Новый ХранилищеЗначения(Статус));
		
	КонецЕсли;
	
КонецПроцедуры

Функция КаталогСкрипта() Экспорт
	
	КаталогСкрипта = "";
	Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
		ПараметрЗапускаКлиента = ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить("ПараметрЗапуска");
		Если СтрНайти(ПараметрЗапускаКлиента, "ВыполнитьОбновлениеИЗавершитьРаботу") > 0 Тогда
			СтатусОбновления = Константы.СтатусОбновленияКонфигурации.Получить().Получить();
			Если СтатусОбновления <> Неопределено
				И СтатусОбновления.Свойство("КаталогСкрипта") Тогда
					КаталогСкрипта = СтатусОбновления.КаталогСкрипта;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат КаталогСкрипта;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверить, что запуск программы выполнен от имени внешнего пользователя 
// и выбросить исключение в этом случае.
//
// Параметры:
//  ТекстСообщения  - Строка - текст исключения. Если не задан, 
//                             используется текст по умолчанию.
//
// Пример использования:
//    ПрерватьВыполнениеЕслиАвторизованВнешнийПользователь();
//    ... далее располагается фрагмент кода, который рассчитывает только на выполнение 
//        из-под "обычного" пользователя.
//
Процедура ПрерватьВыполнениеЕслиАвторизованВнешнийПользователь(Знач ТекстСообщения = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		
		ТекстИсключения = ТекстСообщения;
		
		Если ПустаяСтрока(ТекстИсключения) Тогда
			ТекстИсключения = НСтр("ru='Данная операция не доступна внешнему пользователю системы.';uk='Дана операція не доступна зовнішньому користувачеві системи.'");
		КонецЕсли;
		
		ВызватьИсключение ТекстИсключения;
		
	КонецЕсли;
	
КонецПроцедуры

// Получить короткое имя (идентификатор) конфигурации.
//
// Возвращаемое значение:
//   Строка   - короткое имя конфигурации.
Функция КороткоеИмяКонфигурации(СтруктураНастройки)
	
	// Значение задано в инструменте разработчика
	Если СтруктураНастройки <> Неопределено Тогда // Значение из настроек пользователя.
		ИспользоватьЗначениеНастройки = Ложь;
		СтруктураНастройки.Свойство("ИспользоватьЗначениеНастройкиКороткоеИмяКонфигурации", ИспользоватьЗначениеНастройки);
		Если ИспользоватьЗначениеНастройки = Истина Тогда
			Возврат СтруктураНастройки.КороткоеИмяКонфигурации;
		КонецЕсли;
	КонецЕсли;
	
	// Определение короткого имени
	КороткоеИмя = "";
	ОбновлениеКонфигурацииПереопределяемый.ПриОпределенииКраткогоИмениКонфигурации(КороткоеИмя);
	КороткоеИмя = КороткоеИмя + "/";
	
	// Определение редакции конфигурации.
	НомерРедакции = "";
	ПодстрокиВерсии = СтрРазделить(Метаданные.Версия, ".");
	Если ПодстрокиВерсии.Количество() > 1 Тогда
		НомерРедакции = ПодстрокиВерсии[0] + ПодстрокиВерсии[1] + "/";
	КонецЕсли;
	
	// Определение версии платформы.
	ИнформацияСистемная = Новый СистемнаяИнформация;
	ПодстрокиВерсии = СтрРазделить(ИнформацияСистемная.ВерсияПриложения, ".");
	ВерсияПлатформы = ПодстрокиВерсии[0] + ПодстрокиВерсии[1] + "/";
	
	// Определение группы версий
	ГруппаВерсий = "";
	ОбновлениеКонфигурацииПереопределяемый.ПриОпределенииГруппыВерсий(ГруппаВерсий);
	Если Не ПустаяСтрока(ГруппаВерсий) Тогда
		ГруппаВерсий = Строка(ГруппаВерсий) + "/";
	КонецЕсли;
	
	ШаблонИмени = "[КороткоеИмя][НомерРедакции][ВерсияПлатформы][ГруппаВерсий]";
	КороткоеИмяКонфигурации = СтрЗаменить(ШаблонИмени, "[КороткоеИмя]", КороткоеИмя);
	КороткоеИмяКонфигурации = СтрЗаменить(КороткоеИмяКонфигурации, "[НомерРедакции]", НомерРедакции);
	КороткоеИмяКонфигурации = СтрЗаменить(КороткоеИмяКонфигурации, "[ВерсияПлатформы]", ВерсияПлатформы);
	КороткоеИмяКонфигурации = СтрЗаменить(КороткоеИмяКонфигурации, "[ГруппаВерсий]", ГруппаВерсий);
	
	Возврат КороткоеИмяКонфигурации;
	
КонецФункции

// Получить адрес веб-сервера поставщика конфигурации, на котором находится
// информация о доступных обновлениях.
//
// Возвращаемое значение:
//   Строка   - адрес веб-сервера.
//
// Пример реализации:
// 
//	Возврат "localhost";  // локальный веб-сервер для тестирования.
//
Функция АдресСервераДляПроверкиНаличияОбновления(СтруктураНастройки)
	
	Значение = "downloads.bas-soft.eu"; // Значение по умолчанию
	ОбновлениеКонфигурацииПереопределяемый.ПриОпределенииАдресаСервераДляПроверкиНаличияОбновления(Значение);
	
	Если СтруктураНастройки <> Неопределено Тогда // Значение из настроек пользователя.
		ИспользоватьЗначениеНастройки = Ложь;
		СтруктураНастройки.Свойство("ИспользоватьЗначениеНастройкиАдресСервераДляПроверкиНаличияОбновления", ИспользоватьЗначениеНастройки);
		Если ИспользоватьЗначениеНастройки = Истина Тогда
			Значение = СтруктураНастройки.АдресСервераДляПроверкиНаличияОбновления;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

Функция КаталогОбновлений(СтруктураНастройки)
	
	Значение = ОбновлениеКонфигурацииКлиентСервер.ДобавитьКонечныйРазделительПути(Метаданные.АдресКаталогаОбновлений);
	ОбновлениеКонфигурацииПереопределяемый.ПриОпределенииАдресаКаталогаОбновлений(Значение);
	
	Если СтруктураНастройки <> Неопределено Тогда // Значение из настроек пользователя.
		ИспользоватьЗначениеНастройки = Ложь;
		СтруктураНастройки.Свойство("ИспользоватьЗначениеНастройкиКаталогОбновлений", ИспользоватьЗначениеНастройки);
		Если ИспользоватьЗначениеНастройки = Истина Тогда
			Значение = СтруктураНастройки.КаталогОбновлений;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

Функция АдресРесурсаДляПроверкиНаличияОбновления(СтруктураНастройки)
	
	Значение = "/ipp/ITSREPV/V8Update/Configs/"; // Значение по умолчанию
	ОбновлениеКонфигурацииПереопределяемый.ПриОпределенииАдресаРесурсаДляПроверкиНаличияОбновления(Значение);
	
	Если СтруктураНастройки <> Неопределено Тогда // Значение из настроек пользователя.
		ИспользоватьЗначениеНастройки = Ложь;
		СтруктураНастройки.Свойство("ИспользоватьЗначениеНастройкиАдресРесурсаДляПроверкиНаличияОбновления", ИспользоватьЗначениеНастройки);
		Если ИспользоватьЗначениеНастройки = Истина Тогда
			Значение = СтруктураНастройки.АдресРесурсаДляПроверкиНаличияОбновления;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

Функция АдресСервисаПроверкиЛегальности()
	
	Значение = "https://webits.1c.ru/services/WebItsSimpleService?wsdl";  // Значение по умолчанию
	
	СтруктураНастройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ОбновлениеКонфигурации",
		"НастройкиОбновленияКонфигурации");
	
	Если СтруктураНастройки <> Неопределено Тогда // Значение из настроек пользователя.
		ИспользоватьЗначениеНастройки = Ложь;
		СтруктураНастройки.Свойство("ИспользоватьЗначениеНастройкиАдресСервисаПроверкиЛегальности", ИспользоватьЗначениеНастройки);
		Если ИспользоватьЗначениеНастройки = Истина Тогда
			Значение = СтруктураНастройки.АдресСервисаПроверкиЛегальности;
		КонецЕсли;	
	КонецЕсли;	
	
	Возврат Значение;
	
КонецФункции

// Возвращает признак успешного обновления конфигурации на основе данных константы настроек.
Функция ОбновлениеКонфигурацииУспешно(КаталогСкрипта = "") Экспорт

	Если НЕ ПравоДоступа("Чтение", Метаданные.Константы.СтатусОбновленияКонфигурации) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЗначениеХранилища = Константы.СтатусОбновленияКонфигурации.Получить();
	
	Статус = Неопределено;
	Если ЗначениеХранилища <> Неопределено Тогда
		Статус = ЗначениеХранилища.Получить();
	КонецЕсли;

	Если Статус = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Не СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
		И Не Статус.ОбновлениеВыполнено
		Или (Статус.ИмяАдминистратораОбновления <> ИмяПользователя()) Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Если Статус.РезультатОбновленияКонфигурации <> Неопределено Тогда
		Статус.Свойство("КаталогСкрипта", КаталогСкрипта);
	КонецЕсли;
	
	Возврат Статус.РезультатОбновленияКонфигурации;

КонецФункции

// Устанавливает новое значение в константу настроек обновления
// соответственно успешности последней попытки обновления конфигурации.
Процедура ЗаписатьСтатусОбновления(Знач ИмяАдминистратораОбновления, Знач ОбновлениеЗапланировано,
	Знач ОбновлениеВыполнено, Знач РезультатОбновления, КаталогСкрипта = "", СообщенияДляЖурналаРегистрации = Неопределено) Экспорт
	
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	
	Статус = Новый Структура;
	Статус.Вставить("ИмяАдминистратораОбновления", ИмяАдминистратораОбновления);
	Статус.Вставить("ОбновлениеЗапланировано", ОбновлениеЗапланировано);
	Статус.Вставить("ОбновлениеВыполнено", ОбновлениеВыполнено);
	Статус.Вставить("РезультатОбновленияКонфигурации", РезультатОбновления);
	Статус.Вставить("КаталогСкрипта", КаталогСкрипта);
	
	Константы.СтатусОбновленияКонфигурации.Установить(Новый ХранилищеЗначения(Статус));
	
КонецПроцедуры

// Выполняет очистку всех настроек обновления конфигурации.
Процедура СброситьСтатусОбновленияКонфигурации() Экспорт
	
	Константы.СтатусОбновленияКонфигурации.Установить(Новый ХранилищеЗначения(Неопределено));
	
КонецПроцедуры

// Записывает настройки помощника обновления в хранилище общих настроек.
Процедура ЗаписатьСтруктуруНастроекПомощника(НастройкиОбновленияКонфигурации, СообщенияДляЖурналаРегистрации = Неопределено) Экспорт
	
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ОбновлениеКонфигурации", 
		"НастройкиОбновленияКонфигурации", 
		НастройкиОбновленияКонфигурации);
		
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда	
		ПараметрыАутентификации = Новый Структура("Логин,Пароль");
		НастройкиОбновленияКонфигурации.Свойство("КодПользователяСервераОбновлений", ПараметрыАутентификации.Логин);
		НастройкиОбновленияКонфигурации.Свойство("ПарольСервераОбновлений", ПараметрыАутентификации.Пароль);
		СтандартныеПодсистемыСервер.СохранитьПараметрыАутентификацииНаСайте(ПараметрыАутентификации);
	КонецЕсли;
	
КонецПроцедуры

// Проверка доступа к подсистеме ОбновлениеКонфигурации.
Функция ПроверитьДоступДляОбновления()
	Возврат Пользователи.ЭтоПолноправныйПользователь(, Истина);
КонецФункции

Процедура ОтправитьУведомлениеОбОбновлении(Знач ИмяПользователя, Знач АдресНазначения, Знач УспешноеОбновление)
	
	Тема = ? (УспешноеОбновление, НСтр("ru='Успешное обновление конфигурации ""%1"", версия %2';uk='Успішне оновлення конфігурації ""%1"", версія %2'"), 
		НСтр("ru='Ошибка обновления конфигурации ""%1"", версия %2';uk='Помилка оновлення конфігурації ""%1"", версія %2'"));
	Тема = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Тема, Метаданные.КраткаяИнформация, Метаданные.Версия);
	
	Подробности = ?(УспешноеОбновление, НСтр("ru='Обновление конфигурации завершено успешно.';uk='Оновлення конфігурації завершене успішно.'"), 
		НСтр("ru='При обновлении конфигурации произошли ошибки. Подробности записаны в журнал регистрации.';uk='При оновленні конфігурації відбулися помилки. Подробиці записані в журнал реєстрації.'"));
	Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1
        |
        |Конфигурация: %2
        |Версия: %3
        |Строка соединения: %4'
        |;uk=' %1
        |
        |Конфігурація: %2
        |Версія: %3
        |Рядок з''єднання: %4'"),
	Подробности, Метаданные.КраткаяИнформация, Метаданные.Версия, СтрокаСоединенияИнформационнойБазы());
	
	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Тема", Тема);
	ПараметрыПисьма.Вставить("Тело", Текст);
	ПараметрыПисьма.Вставить("Кому", АдресНазначения);
	
	МодульРаботаСПочтовымиСообщениями = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениями");
	МодульРаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(
		МодульРаботаСПочтовымиСообщениями.СистемнаяУчетнаяЗапись(), ПараметрыПисьма);
	
КонецПроцедуры

// Возвращает имя события для записи журнала регистрации.
Функция СобытиеЖурналаРегистрации() Экспорт
	Возврат НСтр("ru='Обновление конфигурации';uk='Оновлення конфігурації'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий подсистем БСП.

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации. 
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	ПриДобавленииПараметровРаботыКлиента(Параметры);
	
КонецПроцедуры

// Заполняет структуру параметров, необходимых для работы клиентского кода
// конфигурации.
//
// Параметры:
//   Параметры   - Структура - структура параметров.
//
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных()
		ИЛИ ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Вставить("НастройкиОбновления", Новый ФиксированнаяСтруктура(ПолучитьНастройкиОбновления()));

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы.

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.1.8";
	Обработчик.Процедура = "ОбновлениеКонфигурации.ОбновлениеРасписанияПроверкиНаличияОбновления";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.2.2.10";
	Обработчик.Процедура = "ОбновлениеКонфигурации.ОчиститьПараметрыАдминистрирования";
	
КонецПроцедуры

// Процедура-обработчик обновления.
//
Процедура ОбновлениеРасписанияПроверкиНаличияОбновления() Экспорт
	
	Расписание = Неопределено;
	СписокПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Для Каждого ТекущийПользователь Из СписокПользователей Цикл
		ИмяПользователя = ТекущийПользователь.Имя;
		
		Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ОбновлениеКонфигурации", 
			"НастройкиОбновленияКонфигурации",
			,
			,
			ИмяПользователя);
		
		// Если в ранних версиях было сохранено расписание...
		Если Настройки <> Неопределено И Настройки.Свойство("РасписаниеПроверкиНаличияОбновления", Расписание) 
			И ТипЗнч(Расписание) = Тип("РасписаниеРегламентногоЗадания") Тогда
			
			Настройки.РасписаниеПроверкиНаличияОбновления = ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Расписание);
			
			ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
				"ОбновлениеКонфигурации", 
				"НастройкиОбновленияКонфигурации", 
				Настройки,
				,
				ИмяПользователя);
			
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры	

// Очищает параметры администрирования из сохраненных настроек.
//
Процедура ОчиститьПараметрыАдминистрирования() Экспорт
	
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ОбновлениеКонфигурации", "НастройкиОбновленияКонфигурации");
	
	Если ТипЗнч(Настройки) = Тип("Структура") ИЛИ ТипЗнч(Настройки) = Тип("Соответствие") Тогда
		
		СписокСвойствДляУдаления = Новый Массив;
		СписокСвойствДляУдаления.Добавить("КластерТребуетАутентификации");
		СписокСвойствДляУдаления.Добавить("ИмяАдминистратораКластера");
		СписокСвойствДляУдаления.Добавить("ПарольАдминистратораКластера");
		СписокСвойствДляУдаления.Добавить("НестандартныеПортыСервера");
		СписокСвойствДляУдаления.Добавить("ПортАгентаСервера");
		СписокСвойствДляУдаления.Добавить("ПортКластераСерверов");
		
		Для Каждого УдаляемоеСвойство Из СписокСвойствДляУдаления Цикл
			
			Если Настройки.Свойство(УдаляемоеСвойство) Тогда
				Настройки.Удалить(УдаляемоеСвойство);
			КонецЕсли;
			
		КонецЦикла;
		
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"ОбновлениеКонфигурации", 
			"НастройкиОбновленияКонфигурации", 
			Настройки);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
