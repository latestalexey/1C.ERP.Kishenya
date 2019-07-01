
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	//исключить группировку по виду сделки, если управление не используется
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеСделками") Тогда
		Элементы.БыстраяГруппировка.СписокВыбора.Удалить(
			Элементы.БыстраяГруппировка.СписокВыбора.НайтиПоЗначению("ВидСделки"));
	КонецЕсли;
	
	Если Параметры.Свойство("ПоУчастнику") Тогда
		
		Участник = Параметры.ПоУчастнику;

		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	УчастиеВСделках.Ссылка
			|ИЗ
			|	КритерийОтбора.УчастиеВСделках(&Участник) КАК УчастиеВСделках");
		Запрос.УстановитьПараметр("Участник", Участник);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Ссылка",
			Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"),
			ВидСравненияКомпоновкиДанных.ВСписке,,Истина);
		
	КонецЕсли;
	
	НаЗакрытиеПоУмолчанию = Параметры.Свойство("НаЗакрытие");
	Если НаЗакрытиеПоУмолчанию Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Статус",
			Перечисления.СтатусыСделок.ВРаботе,
			ВидСравненияКомпоновкиДанных.НеРавно,,Истина);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Закрыта", Ложь, ВидСравненияКомпоновкиДанных.Равно,,Истина);
		
		АвтоЗаголовок = Ложь;
		Заголовок     = НСтр("ru='Сделки на закрытие';uk='Угоди на закриття'");
		Элементы.ФильтрСтатус.Видимость = Ложь;
	КонецЕсли;
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Ответственный",Ответственный);
		СтруктураБыстрогоОтбора.Свойство("Статус",       Статус);
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
	УстановитьОтборПоСтатусуСервер(Статус);
	
	Если ПустаяСтрока(Статус) Тогда
		Статус = "Все";
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.ФильтрОтветственный.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Справочники.СделкиСКлиентами));
		
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.СделкиСКлиентами);
	Элементы.СписокИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.СписокКоманднаяПанель);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "Ответственный", Ответственный, СтруктураБыстрогоОтбора, Настройки);
	
	Если Статус = "" Тогда
		Статус = Настройки.Получить("Статус");
		УстановитьОтборПоСтатусуСервер(Статус);
	Иначе
		Настройки.Удалить("Статус");
	КонецЕсли;
	
	УстановитьБыструюГруппировку(
		ОбщегоНазначенияУТКлиентСервер.ПолучитьПоляГруппировкиДинамическогоСписка(Список),
		Настройки.Получить("БыстраяГруппировка"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БыстраяГруппировкаПриИзменении(Элемент)
	
	УстановитьБыструюГруппировку(
		ОбщегоНазначенияУТКлиентСервер.ПолучитьПоляГруппировкиДинамическогоСписка(Список),
		БыстраяГруппировка);
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрСтатусПриИзменении(Элемент)

	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список,"Статус");
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список,"Закрыта");

	Если Статус = "ВРаботе" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Статус",
			ПредопределенноеЗначение("Перечисление.СтатусыСделок.ВРаботе"),
			ВидСравненияКомпоновкиДанных.Равно,,Истина);
	ИначеЕсли Статус = "Выиграна" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Статус",
			ПредопределенноеЗначение("Перечисление.СтатусыСделок.Выиграна"),
			ВидСравненияКомпоновкиДанных.Равно,,Истина);
	ИначеЕсли Статус = "Проиграна" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Статус",
			ПредопределенноеЗначение("Перечисление.СтатусыСделок.Проиграна"),
			ВидСравненияКомпоновкиДанных.Равно,,Истина);
	ИначеЕсли Статус = "НаЗакрытие" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Статус",
			ПредопределенноеЗначение("Перечисление.СтатусыСделок.ВРаботе"),
			ВидСравненияКомпоновкиДанных.НеРавно,,Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Закрыта", Ложь, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	ИначеЕсли Статус = "Открытые" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Закрыта", Ложь, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	ИначеЕсли Статус = "Закрытые" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Закрыта", Истина, ВидСравненияКомпоновкиДанных.Равно,,Истина);
	КонецЕсли;

	Если ЗначениеЗаполнено(Ответственный) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Ответственный",
			Ответственный,
			ВидСравненияКомпоновкиДанных.Равно,, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрОтветственныйПриИзменении(Элемент)

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Ответственный",
		Ответственный,
		ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Ответственный));

КонецПроцедуры

&НаКлиенте
Процедура ФильтрСтатусОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если ЗначениеЗаполнено(Участник) Тогда
		
		Отказ = Истина;
		ПараметрыФормы = Новый Структура("Основание", Участник);
		ОткрытьФорму("Справочник.СделкиСКлиентами.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец МенюОтчеты

#Область Прочее

&НаСервере
Процедура УстановитьОтборПоСтатусуСервер(Статус)
	
	Если НЕ НаЗакрытиеПоУмолчанию И ЗначениеЗаполнено(Статус) И Статус <> "Все" Тогда
		Если Статус = "ВРаботе" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Статус",
			ПредопределенноеЗначение("Перечисление.СтатусыСделок.ВРаботе"),
			ВидСравненияКомпоновкиДанных.Равно,,Истина);
		ИначеЕсли Статус = "Выиграна" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Статус",
			ПредопределенноеЗначение("Перечисление.СтатусыСделок.Выиграна"),
			ВидСравненияКомпоновкиДанных.Равно,,Истина);
		ИначеЕсли Статус = "Проиграна" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Статус",
			ПредопределенноеЗначение("Перечисление.СтатусыСделок.Проиграна"),
			ВидСравненияКомпоновкиДанных.Равно,,Истина);
		ИначеЕсли Статус = "НаЗакрытие" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Статус",
			ПредопределенноеЗначение("Перечисление.СтатусыСделок.ВРаботе"),
			ВидСравненияКомпоновкиДанных.НеРавно,,Истина);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Закрыта", Ложь, ВидСравненияКомпоновкиДанных.Равно,,Истина);
		ИначеЕсли Статус = "Открытые" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Закрыта", Ложь, ВидСравненияКомпоновкиДанных.Равно,,Истина);
		ИначеЕсли Статус = "Закрытые" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Закрыта", Истина, ВидСравненияКомпоновкиДанных.Равно,,Истина);
		КонецЕсли;
	Иначе
		Статус = "Все";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьБыструюГруппировку(ПоляГруппировки, ИмяПоля)
	
	ПоляГруппировки.Элементы.Очистить();
	
	Если ЗначениеЗаполнено(ИмяПоля) Тогда
		ПолеГруппировки = ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
		ПолеГруппировки.Использование = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
