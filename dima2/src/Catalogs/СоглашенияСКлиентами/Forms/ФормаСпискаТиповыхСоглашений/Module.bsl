
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	Список.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности", НачалоДня(ТекущаяДата()));
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОтборыСписковКлиентСервер.ЗаполнитьСписокВыбораОтбораПоАктуальности(Элементы.ОтборСрокДействия.СписокВыбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Менеджер", Менеджер, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоАктуальностиПриСозданииНаСервере(Список, Актуальность, ДатаСобытия, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоРегулярностиПриСозданииНаСервере(Список, Регулярность, СтруктураБыстрогоОтбора);

	Если ОтборыСписковКлиентСервер.НеобходимОтборПоСостояниюПриСозданииНаСервере(Состояние, СтруктураБыстрогоОтбора) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.Менеджер.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Справочники.СоглашенияСКлиентами, НСтр("ru='<Мои соглашения>';uk='<Мої оферти>'")));
		
	ДоступноСозданиеТиповыхСоглашений                   = ПраваПользователяПовтИсп.ИзменениеТиповыхСоглашений();
	Элементы.СписокСоздать.Видимость                    = ДоступноСозданиеТиповыхСоглашений;
	Элементы.СписокСкопировать.Видимость                = ДоступноСозданиеТиповыхСоглашений;
	Элементы.СписокКонтекстноеМенюСоздать.Видимость     = ДоступноСозданиеТиповыхСоглашений;
	Элементы.СписокКонтекстноеМенюСкопировать.Видимость = ДоступноСозданиеТиповыхСоглашений;
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	ВводНаОсновании.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюСоздатьНаОсновании);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
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
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "Менеджер", Менеджер, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоАктуальностиПриЗагрузкеИзНастроек(Список, Актуальность, ДатаСобытия, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоРегулярностиПриЗагрузкеИзНастроек(Список, Регулярность, СтруктураБыстрогоОтбора, Настройки);

	Если ОтборыСписковКлиентСервер.НеобходимОтборПоСостояниюПриЗагрузкеИзНастроек(Состояние, СтруктураБыстрогоОтбора, Настройки) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МенеджерПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Менеджер", Менеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Менеджер));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияПриИзменении(Элемент)

	ОтборыСписковКлиентСервер.ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия);

КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияОчистка(Элемент, СтандартнаяОбработка)
	
	ОтборыСписковКлиентСервер.ПриОчисткеОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокДействияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.ПриВыбореОтбораПоАктуальности(
		ВыбранноеЗначение, 
		СтандартнаяОбработка, 
		ЭтаФорма,
		Список, 
		"Актуальность", 
		"ДатаСобытия");
	
КонецПроцедуры

&НаКлиенте
Процедура РегулярностьПриИзменении(Элемент)

	ОтборыСписковКлиентСервер.УстановитьОтборВСпискеПоРегулярности(Список, Регулярность);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
		
	Если Копирование Тогда
		Возврат;
	КонецЕсли;

	Отказ = Истина;
	
	Если ДоступноСозданиеТиповыхСоглашений Тогда
		ОткрытьФорму(
		"Справочник.СоглашенияСКлиентами.ФормаОбъекта",
		Новый Структура("Типовое,ЗначенияЗаполнения", Истина,Новый Структура("Типовое", Истина)),
		,
		,);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСтатусНеСогласовано(Команда)
	
	ПродажиКлиент.УстановитьСтатусСоглашенийСКлиентамиНеСогласовано(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусДействует(Команда)
	
	ПродажиКлиент.УстановитьСтатусСоглашенийСКлиентамиДействует(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрыто(Команда)
	
	ПродажиКлиент.УстановитьСтатусСоглашенийСКлиентамиЗакрыто(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

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

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Справочник.СоглашенияСКлиентами.ПустаяСсылка"));
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

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#КонецОбласти
