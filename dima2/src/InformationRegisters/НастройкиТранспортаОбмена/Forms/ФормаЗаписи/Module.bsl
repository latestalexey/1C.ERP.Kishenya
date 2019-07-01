&НаКлиенте
Перем ВнешниеРесурсыРазрешены;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьВидимостьЭлементовФормы();
	
	Если ЗначениеЗаполнено(Запись.ВидТранспортаСообщенийОбменаПоУмолчанию) Тогда
		
		ИмяСтраницы = "НастройкиТранспорта[ВидТранспорта]";
		ИмяСтраницы = СтрЗаменить(ИмяСтраницы, "[ВидТранспорта]"
		, ОбщегоНазначения.ИмяЗначенияПеречисления(Запись.ВидТранспортаСообщенийОбменаПоУмолчанию));
		
		Если Элементы[ИмяСтраницы].Видимость Тогда
			
			Элементы.СтраницыВидовТранспорта.ТекущаяСтраница = Элементы[ИмяСтраницы];
			
		КонецЕсли;
		
	КонецЕсли;
	
	СобытиеЖурналаРегистрацииУстановкаПодключенияКWebСервису 
		= ОбменДаннымиСервер.СобытиеЖурналаРегистрацииУстановкаПодключенияКWebСервису();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		Элементы.ПараметрыДоступаВИнтернет.Видимость = Истина;
		Элементы.ПараметрыДоступаВИнтернет1.Видимость = Истина;
	Иначе
		Элементы.ПараметрыДоступаВИнтернет.Видимость = Ложь;
		Элементы.ПараметрыДоступаВИнтернет1.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.Узел) Тогда
		УстановитьПривилегированныйРежим(Истина);
		Пароли = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Запись.Узел, "COMПарольПользователя, FTPСоединениеПароль, WSПароль, ПарольАрхиваСообщенияОбмена", Истина);
		УстановитьПривилегированныйРежим(Ложь);
		COMПарольПользователя = ?(ЗначениеЗаполнено(Пароли.COMПарольПользователя), ЭтотОбъект.УникальныйИдентификатор, "");
		FTPСоединениеПароль = ?(ЗначениеЗаполнено(Пароли.FTPСоединениеПароль), ЭтотОбъект.УникальныйИдентификатор, "");
		WSПароль = ?(ЗначениеЗаполнено(Пароли.WSПароль), ЭтотОбъект.УникальныйИдентификатор, "");
		ПарольАрхиваСообщенияОбмена = ?(ЗначениеЗаполнено(Пароли.ПарольАрхиваСообщенияОбмена), ЭтотОбъект.УникальныйИдентификатор, "");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВариантРаботыИнформационнойБазыПриИзменении();
	
	АутентификацияОперационнойСистемыПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ВнешниеРесурсыРазрешены <> Истина Тогда
		
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("РазрешитьВнешнийРесурсЗавершение", ЭтотОбъект, ПараметрыЗаписи);
		Запросы = СоздатьЗапросНаИспользованиеВнешнихРесурсов(Запись, Истина, Истина, Истина, Истина);
		РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Запросы, ЭтотОбъект, ОповещениеОЗакрытии);
		
		Отказ = Истина;
		
	КонецЕсли;
	ВнешниеРесурсыРазрешены = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("ЗаписатьИЗакрыть") Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	УстановитьПривилегированныйРежим(Истина);
	Если COMПарольПользователяИзменен Тогда
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Узел, COMПарольПользователя, "COMПарольПользователя")
	КонецЕсли;
	Если FTPСоединениеПарольИзменен Тогда
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Узел, FTPСоединениеПароль, "FTPСоединениеПароль")
	КонецЕсли;
	Если WSПарольИзменен Тогда
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Узел, WSПароль, "WSПароль")
	КонецЕсли;
	Если ПарольАрхиваСообщенияОбменаИзменен Тогда
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Узел, ПарольАрхиваСообщенияОбмена, "ПарольАрхиваСообщенияОбмена")
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура FILEКаталогОбменаИнформациейНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикВыбораФайловогоКаталога(Запись, "FILEКаталогОбменаИнформацией", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура FILEКаталогОбменаИнформациейОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикОткрытияФайлаИлиКаталога(Запись, "FILEКаталогОбменаИнформацией", СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура COMКаталогИнформационнойБазыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ОбработчикВыбораФайловогоКаталога(Запись, "COMКаталогИнформационнойБазы", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура COMКаталогИнформационнойБазыОткрытие(Элемент, СтандартнаяОбработка)

ОбменДаннымиКлиент.ОбработчикОткрытияФайлаИлиКаталога(Запись, "COMКаталогИнформационнойБазы", СтандартнаяОбработка)

КонецПроцедуры

&НаКлиенте
Процедура COMВариантРаботыИнформационнойБазыПриИзменении(Элемент)
	
	ВариантРаботыИнформационнойБазыПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура COMАутентификацияОперационнойСистемыПриИзменении(Элемент)
	
	АутентификацияОперационнойСистемыПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура WSПарольПриИзменении(Элемент)
	WSПарольИзменен = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПарольАрхиваСообщенияОбмена1ПриИзменении(Элемент)
	ПарольАрхиваСообщенияОбменаИзменен = Истина;
КонецПроцедуры

&НаКлиенте
Процедура FTPСоединениеПарольПриИзменении(Элемент)
	FTPСоединениеПарольИзменен = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПарольАрхиваСообщенияОбменаПриИзменении(Элемент)
	ПарольАрхиваСообщенияОбменаИзменен = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПарольАрхиваСообщенияОбмена2ПриИзменении(Элемент)
	ПарольАрхиваСообщенияОбменаИзменен = Истина;
КонецПроцедуры

&НаКлиенте
Процедура COMПарольПользователяПриИзменении(Элемент)
	COMПарольПользователяИзменен = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьПодключениеCOM(Команда)
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПроверитьПодключениеCOMЗавершение", ЭтотОбъект);
	Запросы = СоздатьЗапросНаИспользованиеВнешнихРесурсов(Запись, Истина, Ложь, Ложь, Ложь);
	РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Запросы, ЭтотОбъект, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеWS(Команда)
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПроверитьПодключениеWSЗавершение", ЭтотОбъект);
	Запросы = СоздатьЗапросНаИспользованиеВнешнихРесурсов(Запись, Ложь, Ложь, Истина, Ложь);
	РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Запросы, ЭтотОбъект, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеFILE(Команда)
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПроверитьПодключениеFILEЗавершение", ЭтотОбъект);
	Запросы = СоздатьЗапросНаИспользованиеВнешнихРесурсов(Запись, Ложь, Истина, Ложь, Ложь);
	РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Запросы, ЭтотОбъект, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеFTP(Команда)
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПроверитьПодключениеFTPЗавершение", ЭтотОбъект);
	Запросы = СоздатьЗапросНаИспользованиеВнешнихРесурсов(Запись, Ложь, Ложь, Ложь, Истина);
	РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Запросы, ЭтотОбъект, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеEMAIL(Команда)
	
	ПроверитьПодключение("EMAIL");
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыДоступаВИнтернет(Команда)
	
	ОбменДаннымиКлиент.ОткрытьФормуПараметровПроксиСервера();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ЗаписатьИЗакрыть");
	Записать(ПараметрыЗаписи);

КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьПодключение(ВидТранспортаСтрокой)
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	ПроверитьПодключениеНаСервере(Отказ, ВидТранспортаСтрокой);
	
	ОповеститьПользователяОРезультатахПодключения(Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПодключениеНаСервере(Отказ, ВидТранспортаСтрокой)
	
	ОбменДаннымиСервер.ПроверитьПодключениеОбработкиТранспортаСообщенийОбмена(Отказ, Запись, Перечисления.ВидыТранспортаСообщенийОбмена[ВидТранспортаСтрокой]);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПроверкуУстановкиВнешнегоСоединения(Отказ)
	
	ПараметрыСоединения = Новый Структура;
	ПараметрыСоединения.Вставить("COMВариантРаботыИнформационнойБазы", Запись.COMВариантРаботыИнформационнойБазы);
	ПараметрыСоединения.Вставить("COMАутентификацияОперационнойСистемы", Запись.COMАутентификацияОперационнойСистемы);
	ПараметрыСоединения.Вставить("COMИмяИнформационнойБазыНаСервере1СПредприятия",
		Запись.COMИмяИнформационнойБазыНаСервере1СПредприятия);
	ПараметрыСоединения.Вставить("COMИмяПользователя", Запись.COMИмяПользователя);
	ПараметрыСоединения.Вставить("COMИмяСервера1СПредприятия", Запись.COMИмяСервера1СПредприятия);
	ПараметрыСоединения.Вставить("COMКаталогИнформационнойБазы", Запись.COMКаталогИнформационнойБазы);
	
	УстановитьПривилегированныйРежим(Истина);
	ПараметрыСоединения.Вставить("COMПарольПользователя",
		ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Запись.Узел, "COMПарольПользователя", Истина));
	УстановитьПривилегированныйРежим(Ложь);
	
	ОбменДаннымиВызовСервера.ВыполнитьПроверкуУстановкиВнешнегоСоединения(Отказ, ПараметрыСоединения);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПроверкуУстановкиПодключенияWS(Отказ)
	
	ПараметрыПодключения = ОбменДаннымиСервер.СтруктураПараметровWS();
	ЗаполнитьЗначенияСвойств(ПараметрыПодключения, Запись);
	
	УстановитьПривилегированныйРежим(Истина);
	ПараметрыПодключения.WSПароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Запись.Узел, "WSПароль", Истина);
	УстановитьПривилегированныйРежим(Ложь);
	
	СообщениеПользователю = "";
	Если Не ОбменДаннымиСервер.ЕстьПодключениеККорреспонденту(Запись.Узел, ПараметрыПодключения, СообщениеПользователю) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю,,,, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовФормы()
	
	ИспользуемыеТранспорты = Новый Массив;
	
	Если ЗначениеЗаполнено(Запись.Узел) Тогда
		
		ИспользуемыеТранспорты = ОбменДаннымиПовтИсп.ИспользуемыеТранспортыСообщенийОбмена(Запись.Узел);
		
	КонецЕсли;
	
	Для Каждого СтраницаВидаТранспорта Из Элементы.СтраницыВидовТранспорта.ПодчиненныеЭлементы Цикл
		
		СтраницаВидаТранспорта.Видимость = Ложь;
		
	КонецЦикла;
	
	Элементы.ВидТранспортаСообщенийОбменаПоУмолчанию.СписокВыбора.Очистить();
	
	Для Каждого Элемент Из ИспользуемыеТранспорты Цикл
		
		ИмяЭлементаФормы = "НастройкиТранспорта[ВидТранспорта]";
		ИмяЭлементаФормы = СтрЗаменить(ИмяЭлементаФормы, "[ВидТранспорта]", ОбщегоНазначения.ИмяЗначенияПеречисления(Элемент));
		
		Элементы[ИмяЭлементаФормы].Видимость = Истина;
		
		Элементы.ВидТранспортаСообщенийОбменаПоУмолчанию.СписокВыбора.Добавить(Элемент, Строка(Элемент));
		
	КонецЦикла;
	
	Если ИспользуемыеТранспорты.Количество() = 1 Тогда
		
		Элементы.СтраницыВидовТранспорта.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьПользователяОРезультатахПодключения(Знач ОшибкаПодключения)
	
	ТекстПредупреждения = ?(ОшибкаПодключения, НСтр("ru='Не удалось установить подключение.';uk='Не вдалося встановити підключення.'"),
											   НСтр("ru='Подключение успешно установлено.';uk='Підключення успішно встановлене.'"));
	ПоказатьПредупреждение(, ТекстПредупреждения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРаботыИнформационнойБазыПриИзменении()
	
	ТекущаяСтраница = ?(Запись.COMВариантРаботыИнформационнойБазы = 0, Элементы.СтраницаВариантРаботыФайловый, Элементы.СтраницаВариантРаботыКлиентСерверный);
	
	Элементы.ВариантыРаботыИнформационнойБазы.ТекущаяСтраница = ТекущаяСтраница;
	
КонецПроцедуры

&НаКлиенте
Процедура АутентификацияОперационнойСистемыПриИзменении()
	
	Элементы.COMИмяПользователя.Доступность    = Не Запись.COMАутентификацияОперационнойСистемы;
	Элементы.COMПарольПользователя.Доступность = Не Запись.COMАутентификацияОперационнойСистемы;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВнешнийРесурсЗавершение(Результат, ПараметрыЗаписи) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ВнешниеРесурсыРазрешены = Истина;
		Записать(ПараметрыЗаписи);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СоздатьЗапросНаИспользованиеВнешнихРесурсов(Знач Запись, ЗапрашиватьCOM,
	ЗапрашиватьFILE, ЗапрашиватьWS, ЗапрашиватьFTP)
	
	ЗапросыРазрешений = Новый Массив;
	РегистрыСведений.НастройкиТранспортаОбмена.ЗапросНаИспользованиеВнешнихРесурсов(ЗапросыРазрешений,
		Запись, ЗапрашиватьCOM, ЗапрашиватьFILE, ЗапрашиватьWS, ЗапрашиватьFTP);
	Возврат ЗапросыРазрешений;
	
КонецФункции

&НаКлиенте
Процедура ПроверитьПодключениеFILEЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		ПроверитьПодключение("FILE");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеFTPЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		ПроверитьПодключение("FTP");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеWSЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		Отказ = Ложь;
		
		ОчиститьСообщения();
		
		ВыполнитьПроверкуУстановкиПодключенияWS(Отказ);
		
		ОповеститьПользователяОРезультатахПодключения(Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеCOMЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		Отказ = Ложь;
		
		ОчиститьСообщения();
		
		Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая Тогда
			
			ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель(Ложь);
			
		КонецЕсли;
		
		ВыполнитьПроверкуУстановкиВнешнегоСоединения(Отказ);
		
		ОповеститьПользователяОРезультатахПодключения(Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
