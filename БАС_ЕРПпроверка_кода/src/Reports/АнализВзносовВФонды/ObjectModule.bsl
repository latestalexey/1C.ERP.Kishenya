#Если Не ТолстыйКлиентУправляемоеПриложение Или Сервер Тогда

Перем ДатаНачалаНП, ДатаКонцаНП;

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ИнициализироватьОтчет();
	
	СтандартнаяОбработка = ложь;
	ДокументРезультат.Очистить();
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Если ЗначениеПараметра <> Неопределено Тогда
		ДатаНачалаНП = Дата(ЗначениеПараметра.Значение.ДатаНачала);
		ДатаКонцаНП  = Дата(ЗначениеПараметра.Значение.ДатаОкончания);
	КонецЕсли;
	
	Если ДатаНачалаНП = '00010101' Тогда
		ДатаНачалаНП = НачалоМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
	Если ДатаКонцаНП = '00010101' Тогда
		ДатаКонцаНП = КонецМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
	
	НастройкиОтчета.Структура.Очистить();
	
	Группировка = НастройкиОтчета.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	Группировка.ПоляГруппировки.Элементы.Очистить();
	Группировка.Выбор.Элементы.Очистить();
	Группировка.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	
	НастройкиОтчета.Выбор.Элементы.Очистить();
	ОтчетыКлиентСервер.ДобавитьВыбранноеПоле(НастройкиОтчета.Выбор, "Организация");
	ОтчетыКлиентСервер.ДобавитьВыбранноеПоле(НастройкиОтчета.Выбор, "ГоловнаяОрганизация");
	ОтчетыКлиентСервер.ДобавитьВыбранноеПоле(НастройкиОтчета.Выбор, "ФизическоеЛицо");
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	ТаблицаЗначений =  Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаЗначений);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	Если ТаблицаЗначений.Количество() > 0 Тогда
		СформироватьМакет(ДокументРезультат, ТаблицаЗначений, ДанныеРасшифровки);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОтчет() Экспорт
	
	ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект);
	
КонецПроцедуры

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ИнициализироватьОтчет();
	ЗначениеВДанныеФормы(ЭтотОбъект, Форма.Отчет);
	
КонецПроцедуры

Процедура СформироватьМакет(ДокументРезультат, ФизЛицаОрганизаций, ДанныеРасшифровки)
	
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	НастройкиКомпоновки = КомпоновщикНастроек.ПолучитьНастройки();
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(ЭтотОбъект.СхемаКомпоновкиДанных, НастройкиКомпоновки);
		
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, истина);
	
	УстановитьПараметрыВыводаТабличногоДокумента(ДокументРезультат);
	
КонецПроцедуры

Процедура УстановитьПараметрыВыводаТабличногоДокумента(ДокументРезультат)
	ДокументРезультат.Автомасштаб 			= 	Истина;
	ДокументРезультат.ОриентацияСтраницы 	= 	ОриентацияСтраницы.Портрет;
	ДокументРезультат.ТолькоПросмотр		= 	Истина;
	ДокументРезультат.ПолеСверху			= 	5;
	ДокументРезультат.ПолеСнизу				= 	0;
	ДокументРезультат.ПолеСлева				= 	15;
КонецПроцедуры

#КонецОбласти

#КонецЕсли