#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт



КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	 
	Если ПравоДоступа("Добавление", Метаданные.Документы.РегистрацияНаработок) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.РегистрацияНаработок.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.РегистрацияНаработок);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);

КонецПроцедуры

// Производит запись движений в регистр "Наработки объектов эксплуатации"
//
Процедура ОтразитьНаработкиОбъектовЭксплуатации(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаНаработкиОбъектовЭксплуатации = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаНаработкиОбъектовЭксплуатации;
	
	Если Отказ Или ТаблицаНаработкиОбъектовЭксплуатации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаДвижений = Движения.НаработкиОбъектовЭксплуатации;
	ТаблицаДвижений.Записывать = Истина;
	ТаблицаДвижений.Загрузить(ТаблицаНаработкиОбъектовЭксплуатации);
	
КонецПроцедуры

// Производит проверку таблицы наработок документов регистрации и установки значений наработок
//
// Праметры:
// 		Объект - ДанныеФормыСтруктура, ДокументОбъект.РегистрацияНаработки, ДокументОбъект.УстановкаЗначенийНаработки - Документ вызывающий проверку
// 		Таблица - ТабличнаяЧасть, ДанныеФормыКоллекция - Таблица документа для проверки
// 		Отказ - Булево - Возвращаемый параметр, признак наличия ошибок в ходе проверки
//
Процедура ПроверкаТаблицыНаработок(Объект, Таблица, Отказ = Ложь) Экспорт
	
	// Проверка дублей строк
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	(ВЫРАЗИТЬ(Данные.НомерСтроки КАК ЧИСЛО)) - 1 КАК ИндексСтроки,
		|	Данные.ОбъектЭксплуатации КАК ОбъектЭксплуатации,
		|	Данные.ПоказательНаработки КАК ПоказательНаработки
		|ПОМЕСТИТЬ ДанныеТабличнойЧасти
		|ИЗ
		|	&Данные КАК Данные
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеТабличнойЧасти1.ИндексСтроки КАК ИндексСтроки
		|ИЗ
		|	ДанныеТабличнойЧасти КАК ДанныеТабличнойЧасти1
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДанныеТабличнойЧасти КАК ДанныеТабличнойЧасти2
		|		ПО ДанныеТабличнойЧасти1.ОбъектЭксплуатации = ДанныеТабличнойЧасти2.ОбъектЭксплуатации
		|			И ДанныеТабличнойЧасти1.ПоказательНаработки = ДанныеТабличнойЧасти2.ПоказательНаработки
		|			И ДанныеТабличнойЧасти1.ИндексСтроки <> ДанныеТабличнойЧасти2.ИндексСтроки");
	
	Запрос.УстановитьПараметр("Данные", Таблица.Выгрузить());
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	ШаблонОшибки = НСтр("ru='Показатель наработки ""%ПоказательНаработки%"" для ""%ОбъектИлиУзел%"" в строке %НомерСтроки% повторяется в других строках табличной части';uk='Показник напрацювання ""%ПоказательНаработки%"" ""%ОбъектИлиУзел%"" в рядку %НомерСтроки% повторюється в інших рядках табличної частини'");
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаТаблицы = Таблица[Выборка.ИндексСтроки];
		ТекстОшибки = СтрЗаменить(ШаблонОшибки, "%ПоказательНаработки%", СтрокаТаблицы.ПоказательНаработки);
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ОбъектИлиУзел%", СтрокаТаблицы.ОбъектЭксплуатации);
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", СтрокаТаблицы.НомерСтроки);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			Объект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Наработки", СтрокаТаблицы.НомерСтроки, "ПоказательНаработки"),,
			Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт
	
	ИсточникиДанных = Новый Соответствие;
	Возврат ИсточникиДанных;
	
КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	НаработкиОбъектовЭксплуатации(ТекстыЗапроса, Регистры);
	ПериодыАктуальностиОбъектовЭксплуатации(ТекстыЗапроса, Регистры);
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Ложь, Истина, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РегистрацияНаработок.Дата КАК ДатаРегистрации
	|ИЗ
	|	Документ.РегистрацияНаработок КАК РегистрацияНаработок
	|ГДЕ
	|	РегистрацияНаработок.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("ДатаРегистрации", Реквизиты.ДатаРегистрации);
	Запрос.УстановитьПараметр("ИспользоватьУзлы", ПолучитьФункциональнуюОпцию("ИспользоватьУзлыОбъектовЭксплуатации"));
	
КонецПроцедуры

Процедура НаработкиОбъектовЭксплуатации(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "НаработкиОбъектовЭксплуатации";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// НаработкиОбъектовЭксплуатации
	|"+
	"ВЫБРАТЬ
	|	&ДатаРегистрации КАК Период,
	//++ НЕ УТКА
	|	ЕСТЬNULL(
	|		Узлы.Ссылка,
	//-- НЕ УТКА
	|		Объекты.Ссылка
	//++ НЕ УТКА
	|	) 
	//-- НЕ УТКА
	|			КАК ОбъектЭксплуатации,
	|	Наработки.ПоказательНаработки КАК ПоказательНаработки,
	|	Наработки.Значение КАК Значение,
	|	Наработки.СреднесуточноеЗначение КАК СреднесуточноеЗначение,
	|	ЛОЖЬ КАК КорректировочнаяЗапись
	|ИЗ
	|	Документ.РегистрацияНаработок.Наработки КАК Наработки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыЭксплуатации КАК Объекты
	|		ПО Наработки.ОбъектЭксплуатации = Объекты.Ссылка
	//++ НЕ УТКА
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УзлыОбъектовЭксплуатации КАК Узлы
	|		ПО Наработки.ОбъектЭксплуатации = Узлы.Ссылка
	|			И (&ИспользоватьУзлы)
	//-- НЕ УТКА
	|ГДЕ
	|	Наработки.Ссылка = &Ссылка
	//++ НЕ УТКА
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&ДатаРегистрации,
	|	ЕСТЬNULL(Узлы.Ссылка, Объекты.Ссылка),
	|	Наработки.ПоказательНаработки,
	|	Наработки.Значение,
	|	Наработки.СреднесуточноеЗначение,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.РегистрацияНаработок.РасчетныеНаработки КАК Наработки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыЭксплуатации КАК Объекты
	|		ПО Наработки.ОбъектЭксплуатации = Объекты.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УзлыОбъектовЭксплуатации КАК Узлы
	|		ПО Наработки.ОбъектЭксплуатации = Узлы.Ссылка
	|			И (&ИспользоватьУзлы)
	|ГДЕ
	|	Наработки.Ссылка = &Ссылка
	//-- НЕ УТКА
	|" + ";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

Процедура ПериодыАктуальностиОбъектовЭксплуатации(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПериодыАктуальностиОбъектовЭксплуатации";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// ПериодыАктуальностиОбъектовЭксплуатации
	|"+
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&ДатаРегистрации КАК Период,
	|	ВЫБОР
	|		КОГДА Наработки.ОбъектЭксплуатации ССЫЛКА Справочник.ОбъектыЭксплуатации
	|			ТОГДА Наработки.ОбъектЭксплуатации
	|		ИНАЧЕ Наработки.ОбъектЭксплуатации.Владелец
	|	КОНЕЦ КАК ОбъектЭксплуатации
	|ИЗ
	|	Документ.РегистрацияНаработок.Наработки КАК Наработки
	|ГДЕ
	|	Наработки.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&ДатаРегистрации,
	|	ВЫБОР
	|		КОГДА Наработки.ОбъектЭксплуатации ССЫЛКА Справочник.ОбъектыЭксплуатации
	|			ТОГДА Наработки.ОбъектЭксплуатации
	|		ИНАЧЕ Наработки.ОбъектЭксплуатации.Владелец
	|	КОНЕЦ
	|ИЗ
	|	Документ.РегистрацияНаработок.РасчетныеНаработки КАК Наработки
	|ГДЕ
	|	Наработки.Ссылка = &Ссылка" + ";";
	
	Если Не ПолучитьФункциональнуюОпцию("УправлениеПредприятием") Тогда
		Текст = СтрЗаменить(Текст, "ВЫБОР
		|		КОГДА Наработки.ОбъектЭксплуатации ССЫЛКА Справочник.ОбъектыЭксплуатации
		|			ТОГДА Наработки.ОбъектЭксплуатации
		|		ИНАЧЕ Наработки.ОбъектЭксплуатации.Владелец
		|	КОНЕЦ", "Наработки.ОбъектЭксплуатации");
	КонецЕсли;
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли