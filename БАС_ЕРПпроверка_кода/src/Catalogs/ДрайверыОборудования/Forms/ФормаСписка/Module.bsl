#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса, "%Предопределенный%", НСтр("ru='Поставляемый в составе конфигурации';uk='Поставляється у складі конфігурації'"));
	Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса, "%Подключаемый%", НСтр("ru='Подключаемый по стандарту """"1С:Совместимо""""';uk='Підключається за стандартом """"1С:Сумісно""""'"));
	
	ВозможностьДобавленияНовыхДрайверов = МенеджерОборудованияВызовСервераПереопределяемый.ВозможностьДобавленияНовыхДрайверов(); 
	Элементы.СписокСоздать.Видимость = ВозможностьДобавленияНовыхДрайверов;
	Элементы.СписокСкопировать.Видимость = ВозможностьДобавленияНовыхДрайверов;
	Элементы.СписокКонтекстноеМенюСоздать.Видимость = ВозможностьДобавленияНовыхДрайверов;
	Элементы.СписокКонтекстноеМенюСкопировать.Видимость = ВозможностьДобавленияНовыхДрайверов;
	Элементы.ДобавитьНовыйДрайверИзФайла.Видимость = ВозможностьДобавленияНовыхДрайверов;
	
	ЭлементГруппировки = Список.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ЭлементГруппировки.Поле = Новый ПолеКомпоновкиДанных("ТипДрайвера");
	ЭлементГруппировки.Использование = Истина;
	
	ЭлементГруппировки = Список.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ЭлементГруппировки.Поле = Новый ПолеКомпоновкиДанных("ТипОборудования");
	ЭлементГруппировки.Использование = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыборФайлаДрайвераЗавершение(ПолноеИмяФайла, Параметры) Экспорт
	
	Если Не ПустаяСтрока(ПолноеИмяФайла) Тогда
		ПараметрыФормы = Новый Структура("ПолноеИмяФайла", ПолноеИмяФайла);
		ОткрытьФорму("Справочник.ДрайверыОборудования.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНовыйДрайверИзФайла(Команда)
	
	#Если ВебКлиент Тогда
		ПоказатьПредупреждение(, НСтр("ru='Данный функционал доступен только в режиме тонкого и толстого клиента.';uk='Даний функціонал доступний тільки в режимі тонкого і товстого клієнта.'"));
		Возврат;
	#КонецЕсли
	
	Оповещение = Новый ОписаниеОповещения("ВыборФайлаДрайвераЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьВыборФайлаДрайвера(Оповещение);
	
КонецПроцедуры

#КонецОбласти
