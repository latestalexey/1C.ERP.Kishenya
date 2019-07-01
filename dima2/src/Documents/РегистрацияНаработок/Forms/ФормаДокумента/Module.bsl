
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	ЗаполнитьДополнительныеРеквизитыНаработок(Объект.Наработки);
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ШаблонОшибки = НСтр("ru='Не заполнена колонка ""Объект эксплуатации"" в строке %НомерСтроки% списка ""Наработки""';uk='Не заповнена колонка ""Об''єкт експлуатації"" в рядку %НомерСтроки% списку ""Напрацювання""'");
	
	Для Каждого СтрокаНаработки Из Объект.Наработки Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаНаработки.ОбъектФормы) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрЗаменить(ШаблонОшибки, "%НомерСтроки%", СтрокаНаработки.НомерСтроки),,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Наработки", СтрокаНаработки.НомерСтроки, "ОбъектФормы"),,
				Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНаработки

&НаКлиенте
Процедура НаработкиОбъектФормыПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Наработки.ТекущиеДанные;
	ТекущиеДанные.ОбъектЭксплуатации = ТекущиеДанные.ОбъектФормы;
	
	Если Не ИспользоватьУправлениеРемонтами Тогда
		НаработкиОбъектФормыПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НаработкиОбъектФормыПриИзмененииНаСервере()
	
	ТекущиеДанные = Объект.Наработки.НайтиПоИдентификатору(Элементы.Наработки.ТекущаяСтрока);
	ТекущиеДанные.ПоказательНаработки = Справочники.ПоказателиНаработки.ПустаяСсылка();
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ПоказательНаработки
		|ИЗ
		|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(
		|			&Дата,
		|			ОсновноеСредство = &Объект
		|				И СпособНачисленияАмортизации = ЗНАЧЕНИЕ(Перечисление.СпособыНачисленияАмортизацииОС.ПропорциональноОбъемуПродукции)) КАК ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних"
	);
	Запрос.УстановитьПараметр("Дата", Объект.Дата);
	Запрос.УстановитьПараметр("Объект", ТекущиеДанные.ОбъектЭксплуатации);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		ТекущиеДанные.ПоказательНаработки = Выборка.ПоказательНаработки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаработкиУзелФормыПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Наработки.ТекущиеДанные;
	ТекущиеДанные.ОбъектЭксплуатации = ?(
		ЗначениеЗаполнено(ТекущиеДанные.УзелФормы),
		ТекущиеДанные.УзелФормы,
		ТекущиеДанные.ОбъектФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты


// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НаработкиОбъектФормы.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Наработки.ОбъектФормы");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);

КонецПроцедуры 

// Обрабочик при создании и чтении на сервере
//
&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ИспользоватьУзлыОбъектовЭксплуатации = ПолучитьФункциональнуюОпцию("ИспользоватьУзлыОбъектовЭксплуатации");
	ИспользоватьУправлениеРемонтами = ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеРемонтами");
	
	ЗаполнитьДополнительныеРеквизитыНаработок(Объект.Наработки);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДополнительныеРеквизитыНаработок(ДанныеЗаполнения, Строки=Неопределено)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	(ВЫРАЗИТЬ(ДанныеЗаполнения.НомерСтроки КАК ЧИСЛО)) - 1 КАК ИндексСтроки,
		|	ДанныеЗаполнения.ОбъектЭксплуатации КАК ОбъектЭксплуатации
		|ПОМЕСТИТЬ ДанныеЗаполнения
		|ИЗ
		|	&ДанныеЗаполнения КАК ДанныеЗаполнения
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеЗаполнения.ИндексСтроки,
		//++ НЕ УТКА
		|	ЕСТЬNULL(Узлы.Ссылка, НЕОПРЕДЕЛЕНО) КАК УзелФормы,
		|	ЕСТЬNULL(
		//-- НЕ УТКА
		|	Объекты.Ссылка
		//++ НЕ УТКА
		|	, Узлы.Владелец)
		//-- НЕ УТКА
		|		КАК ОбъектФормы
		|ИЗ
		|	ДанныеЗаполнения КАК ДанныеЗаполнения
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыЭксплуатации КАК Объекты
		|		ПО ДанныеЗаполнения.ОбъектЭксплуатации = Объекты.Ссылка
		//++ НЕ УТКА
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УзлыОбъектовЭксплуатации КАК Узлы
		|		ПО ДанныеЗаполнения.ОбъектЭксплуатации = Узлы.Ссылка И (&ИспользоватьУзлы)
		//-- НЕ УТКА
		|");
	
	Запрос.УстановитьПараметр("ИспользоватьУзлы", ИспользоватьУзлыОбъектовЭксплуатации);
	Запрос.УстановитьПараметр(
		"ДанныеЗаполнения",
		ДанныеЗаполнения.Выгрузить(
			Строки,
			"НомерСтроки, ОбъектЭксплуатации"));
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(Объект.Наработки[Выборка.ИндексСтроки], Выборка);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
