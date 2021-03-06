
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Организация = Параметры.Организация;
	ОрганизацияПолучатель = Параметры.ОрганизацияПолучатель;
	Склад = Параметры.Склад;
	АдресВХранилище = Параметры.АдресВХранилище;
	ОтрицательныеОстатки = Параметры.ОтрицательныеОстатки;
	Дата = Параметры.Дата;
	СкрыватьПодакцизныеТовары = Параметры.СкрыватьПодакцизныеТовары;
	
	ЭтоКомиссия = ?(Параметры.Свойство("ЭтоКомиссия") <> Неопределено, Параметры.Свойство("ЭтоКомиссия"), Ложь);
	ЭтоПродажа = ?(Параметры.Свойство("ЭтоПродажа") <> Неопределено, Параметры.Свойство("ЭтоПродажа"), Ложь);
	ЭтоВозврат = ?(Параметры.Свойство("ЭтоВозврат") <> Неопределено, Параметры.Свойство("ЭтоВозврат"), Ложь);
	
	Элементы.СкрыватьПодакцизныеТовары.Видимость = Параметры.ОтображатьФлагСкрыватьПодакцизныеТовары;
	Элементы.ТаблицаТоваровСерия.Видимость = Параметры.ИспользоватьСерииНоменклатуры;
	
	ЗаполнитьТаблицуТоваров();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ЗаполнитьТаблицуТоваров();
	
КонецПроцедуры

&НаКлиенте
Процедура СкрыватьПодакцизныеТоварыПриИзменении(Элемент)
	
	ЗаполнитьТаблицуТоваров();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТоваровКоличествоПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ТаблицаТоваров.ТекущиеДанные;
	СтрокаТаблицы.Выбран = (СтрокаТаблицы.Количество <> 0);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()

	ПоместитьТоварыВХранилище();
	Закрыть(КодВозвратаДиалога.OK);
	
	ОповеститьОВыборе(АдресВХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтрокиВыполнить()

	Для Каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
		Если ОтрицательныеОстатки И СтрокаТаблицы.КоличествоОстатокПолучателя < 0
		 ИЛИ Не ОтрицательныеОстатки И СтрокаТаблицы.КоличествоОстатокОтправителя > 0 Тогда
			СтрокаТаблицы.Выбран = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтрокиВыполнить()

	Для Каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
		СтрокаТаблицы.Выбран = Ложь
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаТоваров.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаТоваров.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбран = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаТоваров.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаТоваров.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбран = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьТаблицуТоваров();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваров.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.Выбран");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.RosyBrown);

КонецПроцедуры

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Элементы.ОрганизацияПолучатель.Видимость = ОтрицательныеОстатки;
	Элементы.ТаблицаТоваровКоличествоОстатокПолучателя.Видимость = ОтрицательныеОстатки;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПоместитьТоварыВХранилище() 
	
	Товары = ТаблицаТоваров.Выгрузить(, "Выбран, Номенклатура, Характеристика, Серия, Назначение, КоличествоУпаковок, Количество");
	
	МассивУдаляемыхСтрок = Новый Массив;
	Для Каждого СтрокаТаблицы Из Товары Цикл
		
		Если Не СтрокаТаблицы.Выбран Тогда
			МассивУдаляемыхСтрок.Добавить(СтрокаТаблицы);
		КонецЕсли;
		СтрокаТаблицы.КоличествоУпаковок = СтрокаТаблицы.Количество;
		
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		Товары.Удалить(СтрокаТаблицы);
	КонецЦикла;

	ПоместитьВоВременноеХранилище(Товары, АдресВХранилище);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТоваров()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Серия КАК Серия,
	|	Товары.Количество КАК Количество,
	|	Товары.Назначение КАК Назначение
	|
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	Остатки.ВидЗапасов.Назначение КАК Назначение,
	|	СУММА(Остатки.КоличествоОстаток) КАК КоличествоОстаток
	|ПОМЕСТИТЬ ОстаткиОтправителя
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизаций.Остатки(&Граница,
	|		Организация = &ОрганизацияОтправитель
	|		И АналитикаУчетаНоменклатуры.Склад = &Склад
	|		И (
	|		&ИспользоватьКомиссию И ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	|			И (&КомиссияПриЗакупках И ВидЗапасов.Комитент = &ОрганизацияПолучатель ИЛИ НЕ &КомиссияПриЗакупках)
	|		ИЛИ
	|		&ИспользоватьПродажу И  ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
	|			И (&ЗапасыПоПоставщикам И ВидЗапасов.Поставщик = &ОрганизацияПолучатель ИЛИ НЕ &ЗапасыПоПоставщикам)
	|		ИЛИ НЕ (&ИспользоватьКомиссию ИЛИ &ИспользоватьПродажу)
	|		)
	|	) КАК Остатки
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		Остатки.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|ГДЕ
	|	Остатки.КоличествоОстаток > 0
	|	И НЕ (Аналитика.Номенклатура.ПодакцизныйТовар И &СкрыватьПодакцизныеТовары)
	|СГРУППИРОВАТЬ ПО
	|	Аналитика.Номенклатура,
	|	Аналитика.Характеристика,
	|	Аналитика.Серия,
	|	Остатки.ВидЗапасов.Назначение
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	Остатки.ВидЗапасов.Назначение КАК Назначение,
	|	Остатки.КоличествоОстаток КАК КоличествоОстаток
	|
	|ПОМЕСТИТЬ ОстаткиПолучателя
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизаций.Остатки(&Граница,
	|		&ОтрицательныеОстатки
	|		И Организация = &ОрганизацияПолучатель
	|		И АналитикаУчетаНоменклатуры.Склад = &Склад
	|	) КАК Остатки
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		Остатки.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|ГДЕ
	|	Остатки.КоличествоОстаток < 0
	|	И НЕ (Аналитика.Номенклатура.ПодакцизныйТовар И &СкрыватьПодакцизныеТовары)
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА Товары.Количество ЕСТЬ NULL
	|		ИЛИ Товары.Количество = 0
	|	ТОГДА
	|		Ложь
	|	ИНАЧЕ
	|		Истина
	|	КОНЕЦ КАК Выбран,
	|	ОстаткиПолучателя.Номенклатура КАК Номенклатура,
	|	ОстаткиПолучателя.Характеристика КАК Характеристика,
	|	ОстаткиПолучателя.Серия КАК Серия,
	|	ОстаткиПолучателя.Назначение КАК Назначение,
	|	ОстаткиОтправителя.КоличествоОстаток КАК КоличествоОстатокОтправителя,
	|	ОстаткиПолучателя.КоличествоОстаток КАК КоличествоОстатокПолучателя,
	|
	|	ВЫБОР КОГДА Товары.Количество ЕСТЬ NULL
	|		ИЛИ Товары.Количество = 0
	|	ТОГДА
	|		ВЫБОР КОГДА (-ОстаткиПолучателя.КоличествоОстаток) < ОстаткиОтправителя.КоличествоОстаток ТОГДА
	|			-ОстаткиПолучателя.КоличествоОстаток
	|		ИНАЧЕ
	|			ОстаткиОтправителя.КоличествоОстаток
	|		КОНЕЦ
	|	ИНАЧЕ
	|		Товары.Количество
	|	КОНЕЦ КАК Количество
	|ИЗ
	|	ОстаткиПолучателя КАК ОстаткиПолучателя
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Товары КАК Товары
	|	ПО
	|		ОстаткиПолучателя.Номенклатура = Товары.Номенклатура
	|		И ОстаткиПолучателя.Характеристика = Товары.Характеристика
	|		И ОстаткиПолучателя.Серия = Товары.Серия
	|		И (ОстаткиПолучателя.Назначение = Товары.Назначение ИЛИ &НеУчитыватьНазначения)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ОстаткиОтправителя КАК ОстаткиОтправителя
	|	ПО
	|		ОстаткиПолучателя.Номенклатура = ОстаткиОтправителя.Номенклатура
	|		И ОстаткиПолучателя.Характеристика = ОстаткиОтправителя.Характеристика
	|		И ОстаткиПолучателя.Серия = ОстаткиОтправителя.Серия
	|		И ОстаткиПолучателя.Назначение = ОстаткиОтправителя.Назначение
	|ГДЕ
	|	&ОтрицательныеОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА Товары.Количество ЕСТЬ NULL
	|		ИЛИ Товары.Количество = 0
	|	ТОГДА
	|		Ложь
	|	ИНАЧЕ
	|		Истина
	|	КОНЕЦ КАК Выбран,
	|	ОстаткиОтправителя.Номенклатура КАК Номенклатура,
	|	ОстаткиОтправителя.Характеристика КАК Характеристика,
	|	ОстаткиОтправителя.Серия КАК Серия,
	|	ОстаткиОтправителя.Назначение КАК Назначение,
	|	ОстаткиОтправителя.КоличествоОстаток КАК КоличествоОстатокОтправителя,
	|	0 КАК КоличествоОстатокПолучателя,
	|
	|	ВЫБОР КОГДА Товары.Количество ЕСТЬ NULL
	|		ИЛИ Товары.Количество = 0
	|	ТОГДА
	|		ОстаткиОтправителя.КоличествоОстаток
	|	ИНАЧЕ
	|		Товары.Количество
	|	КОНЕЦ КАК Количество
	|ИЗ
	|	ОстаткиОтправителя КАК ОстаткиОтправителя
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Товары КАК Товары
	|	ПО
	|		ОстаткиОтправителя.Номенклатура = Товары.Номенклатура
	|		И ОстаткиОтправителя.Характеристика = Товары.Характеристика
	|		И ОстаткиОтправителя.Серия = Товары.Серия
	|		И (ОстаткиОтправителя.Назначение = Товары.Назначение ИЛИ &НеУчитыватьНазначения)
	|ГДЕ
	|	Не &ОтрицательныеОстатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия,
	|	Назначение
	|");
	
	Запрос.УстановитьПараметр("ОрганизацияПолучатель", ОрганизацияПолучатель);
	Запрос.УстановитьПараметр("ОрганизацияОтправитель", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("ОтрицательныеОстатки", ОтрицательныеОстатки);
	Запрос.УстановитьПараметр("СкрыватьПодакцизныеТовары", СкрыватьПодакцизныеТовары);
	
	ДатаЗаполнения = ?(ЗначениеЗаполнено(Дата), КонецДня(Дата), ТекущаяДата());
	Граница = Новый Граница(ДатаЗаполнения, ВидГраницы.Включая);
	Запрос.УстановитьПараметр("Граница", Граница);
	
	Если ТаблицаТоваров.Количество() > 0 Тогда
		Товары = ТаблицаТоваров.Выгрузить(, "Выбран, Номенклатура, Характеристика, Серия, Назначение, Количество");
		СтрокиКУдалению = Товары.НайтиСтроки(Новый Структура("Выбран", Ложь));
		Для Каждого СтрокаКУдалению Из СтрокиКУдалению Цикл
			Товары.Удалить(СтрокаКУдалению);
		КонецЦикла;
	Иначе
		Товары = ПолучитьИзВременногоХранилища(АдресВХранилище);
		Товары.Свернуть("Номенклатура, Характеристика, Серия, Назначение", "Количество");
	КонецЕсли;
	Запрос.УстановитьПараметр("Товары", Товары);
	
	ПолучательУказан = ЗначениеЗаполнено(ОрганизацияПолучатель);
	ИспользоватьКомиссию = (ЭтоКомиссия И ПолучательУказан);
	ИспользоватьПродажу = (ЭтоПродажа И ПолучательУказан);
	
	Запрос.УстановитьПараметр("ИспользоватьКомиссию", ИспользоватьКомиссию);
	Запрос.УстановитьПараметр("ИспользоватьПродажу", ИспользоватьПродажу);
	Запрос.УстановитьПараметр("КомиссияПриЗакупках", ИспользоватьКомиссию И ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриЗакупках"));
	Запрос.УстановитьПараметр("ЗапасыПоПоставщикам", ИспользоватьПродажу И ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПоставщикам"));
	Запрос.УстановитьПараметр("НеУчитыватьНазначения", ЭтоВозврат);
	
	ТаблицаТоваров.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
