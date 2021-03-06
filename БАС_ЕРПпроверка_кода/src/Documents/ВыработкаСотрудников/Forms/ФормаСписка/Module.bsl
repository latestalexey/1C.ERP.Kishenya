#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	//++ НЕ УТКА
	
	Если Параметры.Свойство("ОтборПоСпискуЗаказов") Тогда
		ОтборПоСпискуЗаказов(Параметры.ОтборПоСпискуЗаказов);
	ИначеЕсли Параметры.Свойство("ОтборПоСпискуЭтаповГрафика") Тогда
		ОтборПоСпискуЭтаповГрафика(Параметры.ОтборПоСпискуЭтаповГрафика);
	ИначеЕсли Параметры.Свойство("ОтборПоСпискуЭтапов") Тогда
		ОтборПоСпискуЭтапов(Параметры.ОтборПоСпискуЭтапов);
	КонецЕсли; 
	
	//-- НЕ УТКА
	
	ДоступныеВидыНарядов.Добавить(Перечисления.ВидыБригадныхНарядов.Производство);
	ДоступныеВидыНарядов.Добавить(Перечисления.ВидыБригадныхНарядов.Ремонт);
	ДоступныеВидыНарядов.Добавить(Перечисления.ВидыБригадныхНарядов.ПрочиеРаботы);
	
	Элементы.ОтборВидНаряда.СписокВыбора.Добавить(Перечисления.ВидыБригадныхНарядов.ПустаяСсылка(), НСтр("ru='Любой';uk='Будь-який'"));
	Для Каждого Строка Из ДоступныеВидыНарядов Цикл
		Элементы.ОтборВидНаряда.СписокВыбора.Добавить(Строка.Значение);
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПроизводствоПоРаспоряжениям", НСтр("ru='Производство (по распоряжению)';uk='Виробництво (за розпорядженням)'"));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ПроизводствоБезРаспоряжений", НСтр("ru='Производство (без распоряжений)';uk='Виробництво (без розпоряджень)'"));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ДоступныеВидыНарядов", ДоступныеВидыНарядов.ВыгрузитьЗначения());
	
	ПриИзмененииОтборов();
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.СписокКомандыФормы);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	

	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "СписокДата");

	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если Параметры.Свойство("НеЗагружатьОтборы") Тогда
		Настройки.Удалить("ОтборВидНаряда");
		Настройки.Удалить("Подразделение");
		Настройки.Удалить("Бригада");
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ПриИзмененииОтборов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ПодразделениеПриИзмененииВызовСервера();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидНарядаПриИзменении(Элемент)
	
	ВидНарядаПриИзмененииВызовСервера();
	
КонецПроцедуры

&НаКлиенте
Процедура БригадаПриИзменении(Элемент)
	
	БригадаПриИзмененииВызовСервера();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ВидНаряда", ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.Производство"));
	
	Если ЗначениеЗаполнено(Бригада) Тогда
		ЗначенияЗаполнения.Вставить("Бригада", Бригада);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Подразделение) Тогда
		ЗначенияЗаполнения.Вставить("Подразделение", Подразделение);
	КонецЕсли;
	
	Если МассивРаспоряжений.Количество() > 0 Тогда
		ЗначенияЗаполнения.Вставить("МассивРаспоряжений", МассивРаспоряжений);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.ВыработкаСотрудников.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.БригадныеНаряды);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриИзмененииОтборов()

	УстановитьОтборПоПодразделению();
	УстановитьОтборПоВидуНаряда();
	УстановитьОтборПоБригаде();
	
КонецПроцедуры

&НаСервере
Процедура ПодразделениеПриИзмененииВызовСервера()

	УстановитьОтборПоПодразделению();
	
КонецПроцедуры

&НаСервере
Процедура ВидНарядаПриИзмененииВызовСервера()

	УстановитьОтборПоВидуНаряда();
	
КонецПроцедуры

&НаСервере
Процедура БригадаПриИзмененииВызовСервера()

	УстановитьОтборПоБригаде();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПодразделению()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Подразделение", 
		Подразделение, 
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Подразделение));
		
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоБригаде()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Бригада", 
		Бригада, 
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Бригада));
		
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоВидуНаряда()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ВидНаряда",
		ОтборВидНаряда,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ОтборВидНаряда));
	
КонецПроцедуры

//++ НЕ УТКА

&НаСервере
Процедура ОтборПоСпискуЗаказов(СписокЗаказов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ВыработкаСотрудниковВидыРабот.Ссылка
	|ИЗ
	|	Документ.ВыработкаСотрудников.ВидыРабот КАК ВыработкаСотрудниковВидыРабот
	|ГДЕ
	|	ВыработкаСотрудниковВидыРабот.Распоряжение ССЫЛКА Документ.МаршрутныйЛистПроизводства
	|	И ВЫРАЗИТЬ(ВыработкаСотрудниковВидыРабот.Распоряжение КАК Документ.МаршрутныйЛистПроизводства).Распоряжение В (&СписокЗаказов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТрудозатратыКОформлениюОстатки.Распоряжение КАК Ссылка
	|ИЗ
	|	РегистрНакопления.ТрудозатратыКОформлению.Остатки КАК ТрудозатратыКОформлениюОстатки
	|ГДЕ
	|	ТрудозатратыКОформлениюОстатки.Распоряжение.Распоряжение В (&СписокЗаказов)";
	
	Запрос.УстановитьПараметр("СписокЗаказов", СписокЗаказов);
	
	Результат = Запрос.ВыполнитьПакет();
	
	СписокДокументов = Результат[0].Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	МассивРаспоряжений.ЗагрузитьЗначения(Результат[1].Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", СписокДокументов);

	Заголовок = НСтр("ru='Выработка сотрудников (установлен отбор по заказам)';uk='Виробіток співробітників (встановлений відбір по замовленнях)'");
	АвтоЗаголовок = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ОтборПоСпискуЭтаповГрафика(СписокЭтапов)
	
	ТаблицаЭтапов = Новый ТаблицаЗначений;
	ТаблицаЭтапов.Колонки.Добавить("Заказ", Новый ОписаниеТипов("ДокументСсылка.ЗаказНаПроизводство"));
	ТаблицаЭтапов.Колонки.Добавить("КодСтрокиПродукция", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10,0,ДопустимыйЗнак.Неотрицательный)));
	ТаблицаЭтапов.Колонки.Добавить("КодСтрокиЭтапыГрафик", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10,0,ДопустимыйЗнак.Неотрицательный)));
	Для каждого ДанныеЭтапа Из СписокЭтапов Цикл
		СтрокаЭтап = ТаблицаЭтапов.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаЭтап, ДанныеЭтапа);
	КонецЦикла; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаЭтапов.Заказ КАК Заказ,
	|	ТаблицаЭтапов.КодСтрокиПродукция КАК КодСтрокиПродукция,
	|	ТаблицаЭтапов.КодСтрокиЭтапыГрафик КАК КодСтрокиЭтапыГрафик
	|ПОМЕСТИТЬ ТаблицаЭтапов
	|ИЗ
	|	&ТаблицаЭтапов КАК ТаблицаЭтапов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Заказ,
	|	КодСтрокиПродукция,
	|	КодСтрокиЭтапыГрафик
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ВыработкаСотрудниковВидыРабот.Ссылка
	|ИЗ
	|	ТаблицаЭтапов КАК ТаблицаЭтапов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.МаршрутныйЛистПроизводства КАК МаршрутныйЛистПроизводства
	|		ПО (МаршрутныйЛистПроизводства.Распоряжение = ТаблицаЭтапов.Заказ)
	|			И (МаршрутныйЛистПроизводства.КодСтроки = ТаблицаЭтапов.КодСтрокиПродукция)
	|			И (МаршрутныйЛистПроизводства.КодСтрокиЭтапыГрафик = ТаблицаЭтапов.КодСтрокиЭтапыГрафик)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВыработкаСотрудников.ВидыРабот КАК ВыработкаСотрудниковВидыРабот
	|		ПО (ВыработкаСотрудниковВидыРабот.Распоряжение = МаршрутныйЛистПроизводства.Ссылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	МаршрутныйЛистПроизводства.Ссылка
	|ИЗ
	|	ТаблицаЭтапов КАК ТаблицаЭтапов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.МаршрутныйЛистПроизводства КАК МаршрутныйЛистПроизводства
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТрудозатратыКОформлению.Остатки КАК ТрудозатратыКОформлениюОстатки
	|			ПО ТрудозатратыКОформлениюОстатки.Распоряжение = МаршрутныйЛистПроизводства.Ссылка
	|		ПО (МаршрутныйЛистПроизводства.Распоряжение = ТаблицаЭтапов.Заказ)
	|			И (МаршрутныйЛистПроизводства.КодСтроки = ТаблицаЭтапов.КодСтрокиПродукция)
	|			И (МаршрутныйЛистПроизводства.КодСтрокиЭтапыГрафик = ТаблицаЭтапов.КодСтрокиЭтапыГрафик)";
	
	Запрос.УстановитьПараметр("ТаблицаЭтапов", ТаблицаЭтапов);
	
	Результат = Запрос.ВыполнитьПакет();
	
	СписокДокументов = Результат[1].Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	МассивРаспоряжений.ЗагрузитьЗначения(Результат[2].Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", СписокДокументов);

	Заголовок = НСтр("ru='Выработка сотрудников (установлен отбор по этапам)';uk='Виробіток співробітників (встановлений відбір за етапами)'");
	АвтоЗаголовок = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ОтборПоСпискуЭтапов(СписокЭтапов)

	ТаблицаЭтапов = Новый ТаблицаЗначений;
	ТаблицаЭтапов.Колонки.Добавить("Заказ", Новый ОписаниеТипов("ДокументСсылка.ЗаказНаПроизводство"));
	ТаблицаЭтапов.Колонки.Добавить("КодСтрокиПродукция", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10,0,ДопустимыйЗнак.Неотрицательный)));
	ТаблицаЭтапов.Колонки.Добавить("Этап", Новый ОписаниеТипов("СправочникСсылка.ЭтапыПроизводства"));
	Для каждого ДанныеЭтапа Из СписокЭтапов Цикл
		СтрокаЭтап = ТаблицаЭтапов.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаЭтап, ДанныеЭтапа);
	КонецЦикла; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаЭтапов.Заказ КАК Заказ,
	|	ТаблицаЭтапов.КодСтрокиПродукция КАК КодСтрокиПродукция,
	|	ТаблицаЭтапов.Этап КАК Этап
	|ПОМЕСТИТЬ ТаблицаЭтапов
	|ИЗ
	|	&ТаблицаЭтапов КАК ТаблицаЭтапов
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Заказ,
	|	КодСтрокиПродукция,
	|	Этап
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ВыработкаСотрудниковВидыРабот.Ссылка
	|ИЗ
	|	ТаблицаЭтапов КАК ТаблицаЭтапов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.МаршрутныйЛистПроизводства КАК МаршрутныйЛистПроизводства
	|		ПО (МаршрутныйЛистПроизводства.Распоряжение = ТаблицаЭтапов.Заказ)
	|			И (МаршрутныйЛистПроизводства.КодСтроки = ТаблицаЭтапов.КодСтрокиПродукция)
	|			И (МаршрутныйЛистПроизводства.Этап = ТаблицаЭтапов.Этап)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВыработкаСотрудников.ВидыРабот КАК ВыработкаСотрудниковВидыРабот
	|		ПО (ВыработкаСотрудниковВидыРабот.Распоряжение = МаршрутныйЛистПроизводства.Ссылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	МаршрутныйЛистПроизводства.Ссылка
	|ИЗ
	|	ТаблицаЭтапов КАК ТаблицаЭтапов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.МаршрутныйЛистПроизводства КАК МаршрутныйЛистПроизводства
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТрудозатратыКОформлению.Остатки КАК ТрудозатратыКОформлениюОстатки
	|			ПО ТрудозатратыКОформлениюОстатки.Распоряжение = МаршрутныйЛистПроизводства.Ссылка
	|		ПО (МаршрутныйЛистПроизводства.Распоряжение = ТаблицаЭтапов.Заказ)
	|			И (МаршрутныйЛистПроизводства.КодСтроки = ТаблицаЭтапов.КодСтрокиПродукция)
	|			И (МаршрутныйЛистПроизводства.Этап = ТаблицаЭтапов.Этап)";
	
	Запрос.УстановитьПараметр("ТаблицаЭтапов", ТаблицаЭтапов);
	
	Результат = Запрос.ВыполнитьПакет();
	
	СписокДокументов = Результат[1].Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	МассивРаспоряжений.ЗагрузитьЗначения(Результат[2].Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", СписокДокументов);

	Заголовок = НСтр("ru='Выработка сотрудников (установлен отбор по этапам)';uk='Виробіток співробітників (встановлений відбір за етапами)'");
	АвтоЗаголовок = Ложь;
	
КонецПроцедуры

//-- НЕ УТКА

#КонецОбласти
