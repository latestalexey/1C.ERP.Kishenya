
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	ВводНаОсновании.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюСоздатьНаОсновании);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	

	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");


КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Организация     = Настройки.Получить("Организация");
	ПодотчетноеЛицо = Настройки.Получить("ПодотчетноеЛицо");
	Валюта          = Настройки.Получить("Валюта");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Организация));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПодотчетноеЛицо", ПодотчетноеЛицо, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПодотчетноеЛицо));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Валюта", Валюта, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Валюта));
	
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОрганизацияОтборПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодотчетноеЛицоОтборПриИзменении(Элемент)
	
	ПодотчетноеЛицоОтборПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаОтборПриИзменении(Элемент)
	
	ВалютаОтборПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ОрганизацияОтборПриИзмененииСервер()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Организация));
	УстановитьВидимость();
	
КонецПроцедуры

&НаСервере
Процедура ПодотчетноеЛицоОтборПриИзмененииСервер()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПодотчетноеЛицо", ПодотчетноеЛицо, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПодотчетноеЛицо));
	УстановитьВидимость();
	
КонецПроцедуры

&НаСервере
Процедура ВалютаОтборПриИзмененииСервер()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Валюта", Валюта, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Валюта));
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.АвансовыйОтчет.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.Организация.Видимость = Не ЗначениеЗаполнено(Организация);
	Элементы.ПодотчетноеЛицо.Видимость = Не ЗначениеЗаполнено(ПодотчетноеЛицо);
	Элементы.Валюта.Видимость = Не ЗначениеЗаполнено(Валюта);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
