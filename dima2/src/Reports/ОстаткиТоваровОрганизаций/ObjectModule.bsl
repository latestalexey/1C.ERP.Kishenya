#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
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
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("Документ", Параметры.ПараметрКоманды);
		ЭтаФорма.ФормаПараметры.КлючНазначенияИспользования = Строка(Параметры.ПараметрКоманды);
		Параметры.КлючНазначенияИспользования = Строка(Параметры.ПараметрКоманды);
		
		ТипПараметра = ТипЗнч(Параметры.ПараметрКоманды);
		Если ТипПараметра = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда	
			Параметры.КлючВарианта = "ОстаткиТоваровДляПродажи";
			
		//++ НЕ УТ
		ИначеЕсли ТипПараметра = Тип("ДокументСсылка.ПередачаСырьяПереработчику") Тогда	
			Параметры.КлючВарианта = "ОстаткиТоваровДляПродажи";
			
		//-- НЕ УТ
		ИначеЕсли ТипПараметра = Тип("ДокументСсылка.ОтчетОРозничныхПродажах") Тогда
			Параметры.КлючВарианта = "ОстаткиТоваровДляПродажи";
			
		ИначеЕсли ТипПараметра = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями")
			Или ТипПараметра = Тип("ДокументСсылка.ВозвратТоваровМеждуОрганизациями")
		Тогда
			Если ПоТоварамКОформлению(Параметры.ПараметрКоманды) Тогда
				Параметры.КлючВарианта = "ОстаткиТоваровКПередаче";
			Иначе
				Параметры.КлючВарианта = "ОстаткиТоваровДляПродажи";
			КонецЕсли;
			
		Иначе
			Параметры.КлючВарианта = "ОстаткиТоваровДляДокумента";
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПоТоварамКОформлению(ДокументСсылка)
	ИмяДокумента = ДокументСсылка.Метаданные().Имя;
	Возврат
		Документы[ИмяДокумента].РеквизитыДокумента(ДокументСсылка).ПоТоварамКОформлению;
КонецФункции

// Процедура формирует временную таблицу доступных видов запасов.
//
// Параметры:
//	Сделки - массив элементов СправочникСсылка.Сделка или одна ссылка СправочникСсылка.Сделка - Сделка/сделки документа
//	Менеджер - СправочникСсылка.Пользователи - Менеджер документа
//	Подразделение - СправочникСсылка.СтруктураПредприятия - Подразделение документа
//	МенеджерВременныхТаблиц - Менеджер временных таблиц
//  ДоступнаПередачаНаКомиссию - Булево - Разрешается побирать запасы организаций со способом между организациями "передача на комиссию"
//
Процедура ВидыЗапасовНеОбособленныеИОбособленные(Сделки, Менеджер, Подразделение, МенеджерВременныхТаблиц, ДоступнаПередачаНаКомиссию = Ложь) Экспорт
	
	Запрос = Новый Запрос("
	|// Собственные виды запасов
	|ВЫБРАТЬ
	|	ВыбранныеОрганизации.Организация КАК ДляОрганизации,
	|	ВидыЗапасов.Ссылка КАК ВидЗапасов,
	|	ВидыЗапасов.Ссылка КАК ВидЗапасовПродавца,
	|	ВидыЗапасов.Предназначение КАК Предназначение,
	|	ВидыЗапасов.Сделка КАК Сделка,
	|	ВидыЗапасов.Менеджер КАК Менеджер,
	|	ВидыЗапасов.Подразделение КАК Подразделение,
	|	ВидыЗапасов.Назначение КАК Назначение
	|
	|ПОМЕСТИТЬ ВидыЗапасов
	|ИЗ
	|	ВыбранныеОрганизации КАК ВыбранныеОрганизации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК ВидыЗапасов
	|		ПО ВидыЗапасов.Организация = ВыбранныеОрганизации.Организация
	|
	|ГДЕ
	|	Не ВидыЗапасов.РеализацияЗапасовДругойОрганизации
	|	И Не ВидыЗапасов.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|// Виды запасов интеркомпани
	|ВЫБРАТЬ
	|	ВыбранныеОрганизации.Организация КАК ДляОрганизации,
	|	ВидыЗапасов.Ссылка КАК ВидЗапасов,
	|	ЕСТЬNULL(ВидыЗапасовПродавца.Ссылка, Неопределено) КАК ВидЗапасовПродавца,
	|	ВидыЗапасов.Предназначение КАК Предназначение,
	|	ВидыЗапасов.Сделка КАК Сделка,
	|	ВидыЗапасов.Менеджер КАК Менеджер,
	|	ВидыЗапасов.Подразделение КАК Подразделение,
	|	ВидыЗапасов.Назначение КАК Назначение
	|ИЗ
	|	ВыбранныеОрганизации КАК ВыбранныеОрганизации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК ВидыЗапасов
	|		ПО НЕ ВидыЗапасов.Организация = ВыбранныеОрганизации.Организация
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.НастройкаПередачиТоваровМеждуОрганизациями КАК Настройка
	|	ПО
	|		ВидыЗапасов.Организация = Настройка.ОрганизацияВладелец
	|		И ВидыЗапасов.ТипЗапасов = Настройка.ТипЗапасов
	|		И Настройка.СпособПередачиТоваров <> ЗНАЧЕНИЕ(Перечисление.СпособыПередачиТоваров.НеПередается)
	|		И Настройка.ОрганизацияПродавец = ВыбранныеОрганизации.Организация
	|		
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.ВидыЗапасов КАК ВидыЗапасовПродавца
	|	ПО
	|		ВидыЗапасов.Ссылка = ВидыЗапасовПродавца.ВидЗапасовВладельца
	|		И Настройка.ОрганизацияПродавец = ВидыЗапасовПродавца.Организация
	|		И Настройка.СпособПередачиТоваров = ВидыЗапасовПродавца.СпособПередачиТоваров
	|		И Настройка.Валюта = ВидыЗапасовПродавца.Валюта
	|ГДЕ
	|	&ИспользоватьПередачиТоваровМеждуОрганизациями
	|	И Не ВидыЗапасов.РеализацияЗапасовДругойОрганизации
	|	И Не ВидыЗапасов.ПометкаУдаления
	|	// при передаче на комиссию использование на собственные нужны  не поддерживается
	|	И (Настройка.СпособПередачиТоваров <> ЗНАЧЕНИЕ(Перечисление.СпособыПередачиТоваров.ПередачаНаКомиссию)
	|		ИЛИ &ДоступнаПередачаНаКомиссию)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Предназначение
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|
	|// Не обособленные виды запасов
	|ВЫБРАТЬ
	|	ВидыЗапасов.ДляОрганизации КАК ДляОрганизации,
	|	ВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ВидыЗапасов.ВидЗапасовПродавца КАК ВидЗапасовПродавца
	|
	|ПОМЕСТИТЬ ДоступныеВидыЗапасовДляОрганизаций
	|ИЗ
	|	ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	ВидыЗапасов.Предназначение = ЗНАЧЕНИЕ(Перечисление.ТипыПредназначенияВидовЗапасов.ПредназначениеНеОграничено)
	|	ИЛИ ВидыЗапасов.Предназначение = ЗНАЧЕНИЕ(Перечисление.ТипыПредназначенияВидовЗапасов.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|// Обособленные виды запасов по сделке
	|ВЫБРАТЬ
	|	ВидыЗапасов.ДляОрганизации КАК ДляОрганизации,
	|	ВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ВидыЗапасов.ВидЗапасовПродавца КАК ВидЗапасовПродавца
	|ИЗ
	|	ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	ВидыЗапасов.Предназначение = ЗНАЧЕНИЕ(Перечисление.ТипыПредназначенияВидовЗапасов.ПредназначенДляСделки)
	|	И ВидыЗапасов.Сделка В (&Сделки)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|// Обособленные виды запасов по менеджеру
	|ВЫБРАТЬ
	|	ВидыЗапасов.ДляОрганизации КАК ДляОрганизации,
	|	ВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ВидыЗапасов.ВидЗапасовПродавца КАК ВидЗапасовПродавца
	|ИЗ
	|	ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	ВидыЗапасов.Предназначение = ЗНАЧЕНИЕ(Перечисление.ТипыПредназначенияВидовЗапасов.ПредназначенДляМенеджера)
	|	И ВидыЗапасов.Менеджер = &Менеджер
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|// Обособленные виды запасов по подразделению
	|ВЫБРАТЬ
	|	ВидыЗапасов.ДляОрганизации КАК ДляОрганизации,
	|	ВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ВидыЗапасов.ВидЗапасовПродавца КАК ВидЗапасовПродавца
	|ИЗ
	|	ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	ВидыЗапасов.Предназначение = ЗНАЧЕНИЕ(Перечисление.ТипыПредназначенияВидовЗапасов.ПредназначенДляПодразделения)
	|	И ВидыЗапасов.Подразделение = &Подразделение
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|// Обособленные виды запасов по заказам
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВидыЗапасов.ДляОрганизации КАК ДляОрганизации,
	|	ВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ВидыЗапасов.ВидЗапасовПродавца КАК ВидЗапасовПродавца
	|ИЗ
	|	ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	ВидыЗапасов.Предназначение = ЗНАЧЕНИЕ(Перечисление.ТипыПредназначенияВидовЗапасов.ПредназначенДляЗаказа)
	|	И ВидыЗапасов.Назначение В (
	|		ВЫБРАТЬ
	|			ТаблицаТоваров.Назначение
	|		ИЗ
	|			ТаблицаТоваров КАК ТаблицаТоваров
	|	)
	|");
	Запрос.УстановитьПараметр("Сделки", ОбщегоНазначенияУТКлиентСервер.Массив(Сделки));
	Запрос.УстановитьПараметр("Менеджер", Менеджер);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ИспользоватьПередачиТоваровМеждуОрганизациями", ПолучитьФункциональнуюОпцию("ИспользоватьПередачиТоваровМеждуОрганизациями"));
	Запрос.УстановитьПараметр("ДоступнаПередачаНаКомиссию", ДоступнаПередачаНаКомиссию);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
 	УстановитьПривилегированныйРежим(Истина);
		
	ТаблицаВСтроке = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ТаблицаВСтроке").Значение;
	ДляПомощникаОформленияСкладскихАктов = ЗначениеЗаполнено(ТаблицаВСтроке);
	
	Документ = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Документ").Значение;
	Если Не ЗначениеЗаполнено(Документ) И НЕ ДляПомощникаОформленияСкладскихАктов Тогда
		Возврат;
	КонецЕсли;
	
	Если ДляПомощникаОформленияСкладскихАктов Тогда
		Склад = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Склад").Значение;
		ДокументОбъект = Новый Структура("Дата, Склад, Организация, ДополнительныеСвойства", ТекущаяДата(), Склад, Неопределено, Новый Структура());
		ТаблицаТоваровИзСтроки = ЗначениеИзСтрокиВнутр(ТаблицаВСтроке);
		МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
			
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("Склад", ДокументОбъект.Склад);
		Запрос.УстановитьПараметр("ТаблицаТоваров", ТаблицаТоваровИзСтроки);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	Товары.Серия,
		|	Товары.Количество,
		|	Товары.КоличествоКОприходованию,
		|	Товары.КоличествоКСписанию
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	&ТаблицаТоваров КАК Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	&Склад КАК Склад,
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	Товары.Серия,
		|	Товары.Количество,
		|	Товары.КоличествоКОприходованию,
		|	Товары.КоличествоКСписанию,
		|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
		|	Аналитика.КлючАналитики КАК АналитикаУчетаНоменклатуры
		|ПОМЕСТИТЬ ТаблицаТоваров
		|ИЗ
		|	Товары КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
		|		ПО Товары.Номенклатура = Аналитика.Номенклатура
		|			И Товары.Характеристика = Аналитика.Характеристика
		|			И Товары.Серия = Аналитика.Серия
		|			И (Аналитика.Склад = &Склад)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	АналитикаУчетаНоменклатуры
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НЕОПРЕДЕЛЕНО КАК Организация
		|ПОМЕСТИТЬ ВыбранныеОрганизации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВыбранныеОрганизации.Организация КАК Организация,
		|	НЕОПРЕДЕЛЕНО КАК Партнер,
		|	НЕОПРЕДЕЛЕНО КАК Контрагент,
		|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
		|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
		|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
		|	ЛОЖЬ КАК ЕстьСделкиВТабличнойЧасти
		|ПОМЕСТИТЬ ТаблицаДанныхДокумента
		|ИЗ
		|	ВыбранныеОрганизации КАК ВыбранныеОрганизации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка) КАК ВидЗапасов,
		|	ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка) КАК ВидЗапасовПродавца
		|ПОМЕСТИТЬ ДоступныеВидыЗапасов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаТоваров.*,
		|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
		|	ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) КАК Менеджер,
		|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
		|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
		|
		|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
		|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
		|	ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка) КАК НалоговоеНазначение
		|
		|ПОМЕСТИТЬ ТаблицаТоваровИАналитикиМод
		|ИЗ
		|	ТаблицаТоваров КАК ТаблицаТоваров";
		Запрос.Выполнить();
		
		ВидыЗапасовНеОбособленныеИОбособленные(
			Справочники.СделкиСКлиентами.ПустаяСсылка(),
			Справочники.Пользователи.ПустаяСсылка(),
			Справочники.СтруктураПредприятия.ПустаяСсылка(),
			МенеджерВременныхТаблиц);
		
	Иначе
			
		ДокументОбъект = Документ.ПолучитьОбъект();
			
		МенеджерВременныхТаблиц = ДокументОбъект.ВременныеТаблицыДанныхДокумента();
		ДокументОбъект.СформироватьВременнуюТаблицуТоваровИАналитики(МенеджерВременныхТаблиц);
		ДокументОбъект.СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц);
	
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("Организация", ДокументОбъект.Организация);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	&Организация КАК Организация
		|ПОМЕСТИТЬ ВыбранныеОрганизации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	&Организация КАК ДляОрганизации,
		|	ДоступныеВидыЗапасов.*
		|ПОМЕСТИТЬ ДоступныеВидыЗапасовДляОрганизаций
		|ИЗ ДоступныеВидыЗапасов КАК ДоступныеВидыЗапасов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаТоваровИАналитики.*,
		|	0 КАК КоличествоКОприходованию,
		|	0 КАК КоличествоКСписанию
		|ПОМЕСТИТЬ ТаблицаТоваровИАналитикиМод
		|ИЗ ТаблицаТоваровИАналитики КАК ТаблицаТоваровИАналитики
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|";
		Запрос.Выполнить();
	КонецЕсли;
	
	ТипДокумента = ТипЗнч(Документ);
	Если ТипДокумента = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями") Тогда
		Реквизиты = Документы.ПередачаТоваровМеждуОрганизациями.РеквизитыДокумента(Документ);
		ДатаОстатков = 
			?(Реквизиты.ПоТоварамКОформлению И ЗначениеЗаполнено(ДокументОбъект.КонецПериода),
				КонецДня(ДокументОбъект.КонецПериода),
				Перечисления.ВидыКонтроляТоваровОрганизаций.ДатаКонтроля(ДокументОбъект.Дата));
		Владелец = ?(Реквизиты.ПоТоварамКОформлению, Реквизиты.ОрганизацияПолучатель, Реквизиты.Организация);
		ПоТоварамКОформлению = Реквизиты.ПоТоварамКОформлению;
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ВозвратТоваровМеждуОрганизациями") Тогда
		Реквизиты = Документы.ВозвратТоваровМеждуОрганизациями.РеквизитыДокумента(Документ);
		ДатаОстатков = Перечисления.ВидыКонтроляТоваровОрганизаций.ДатаКонтроля(ДокументОбъект.Дата);
		Владелец = ?(Реквизиты.ПоТоварамКОформлению, Реквизиты.ОрганизацияПолучатель, Реквизиты.Организация);
		ПоТоварамКОформлению = Реквизиты.ПоТоварамКОформлению;
	Иначе
		ПоТоварамКОформлению = Ложь;
		ДатаОстатков = Перечисления.ВидыКонтроляТоваровОрганизаций.ДатаКонтроля(ДокументОбъект.Дата);
	КонецЕсли;
	
	Если ПоТоварамКОформлению Тогда
		ЗапасыСервер.ТаблицаОстатковТоваровКПередаче(
			Документ,
			Владелец,
			ДокументОбъект.Склад,
			ДатаОстатков,
			МенеджерВременныхТаблиц,
			Истина);
	Иначе
		ЗапасыСервер.ТаблицаОстатковТоваровОрганизаций(
			Документ,
			ДокументОбъект.Организация,
			ДатаОстатков,
			ДокументОбъект.ДополнительныеСвойства,
			МенеджерВременныхТаблиц,
			Истина);
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Настройка.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяХозДеятельность) КАК НалоговоеНазначение
	|	
	|ПОМЕСТИТЬ НалогообложениеОрганизаций
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаОрганизаций.СрезПоследних(&Дата,) КАК Настройка
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УчетныеПолитикиОрганизаций КАК СпрУчетнаяПолитика
	|	ПО Настройка.УчетнаяПолитика = СпрУчетнаяПолитика.Ссылка
	|		И СпрУчетнаяПолитика.СистемаНалогообложения В (
	|			ЗНАЧЕНИЕ(Перечисление.СистемыНалогообложения.НалогНаПрибыль),
	|			ЗНАЧЕНИЕ(Перечисление.СистемыНалогообложения.ЕдиныйНалог),
	|			ЗНАЧЕНИЕ(Перечисление.СистемыНалогообложения.Неплательщик)
	|		)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВыбранныеОрганизации.Организация,//&Организация КАК Организация,
	|	ТаблицаТоваров.НалоговоеНазначение,
	|	(ВЫБОР КОГДА ТаблицаТоваров.АналитикаУчетаНоменклатуры <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка) ТОГДА
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры
	|	ИНАЧЕ
	|		ЕСТЬNULL(Аналитика.КлючАналитики, ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка))
	|	КОНЕЦ) КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ТаблицаТоваров.Серия,
	|	ТаблицаТоваров.Склад,
	|	СУММА(ТаблицаТоваров.Количество) КАК Количество,
	|	СУММА(ТаблицаТоваров.КоличествоКОприходованию) КАК КоличествоКОприходованию,
	|	СУММА(ТаблицаТоваров.КоличествоКСписанию) КАК КоличествоКСписанию,
	|
	|	ТаблицаТоваров.Подразделение,
	|	ТаблицаТоваров.Менеджер,
	|	ТаблицаТоваров.Сделка,
	|	ТаблицаТоваров.Назначение,
	|	ТаблицаТоваров.Партнер,
	|	ТаблицаТоваров.Соглашение
	|
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	ВыбранныеОрганизации КАК ВыбранныеОрганизации
	|	ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаТоваровИАналитикиМод КАК ТаблицаТоваров
	|		ПО ИСТИНА
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|		ПО Аналитика.Номенклатура = ТаблицаТоваров.Номенклатура
	|		И Аналитика.Характеристика = ТаблицаТоваров.Характеристика
	|		И Аналитика.Серия = ТаблицаТоваров.Серия
	|		И Аналитика.Склад = ТаблицаТоваров.Склад
	|
	|СГРУППИРОВАТЬ ПО
	|	ВыбранныеОрганизации.Организация,
	|	ТаблицаТоваров.НалоговоеНазначение,
	|	(ВЫБОР КОГДА ТаблицаТоваров.АналитикаУчетаНоменклатуры <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка) ТОГДА
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры
	|	ИНАЧЕ
	|		ЕСТЬNULL(Аналитика.КлючАналитики, ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка))
	|	КОНЕЦ),
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ТаблицаТоваров.Серия,
	|	ТаблицаТоваров.Склад,
	|	ТаблицаТоваров.Подразделение,
	|	ТаблицаТоваров.Менеджер,
	|	ТаблицаТоваров.Сделка,
	|	ТаблицаТоваров.Назначение,
	|	ТаблицаТоваров.Партнер,
	|	ТаблицаТоваров.Соглашение
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.Организация КАК ДляОрганизации,
	|	ТаблицаТоваров.Организация КАК Организация,//&Организация КАК Организация,
	|	ТаблицаТоваров.НалоговоеНазначение,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ТаблицаТоваров.Серия,
	|	ТаблицаТоваров.Склад,
	|	ТаблицаТоваров.Количество,
	|	ТаблицаТоваров.КоличествоКОприходованию,
	|	ТаблицаТоваров.КоличествоКСписанию,
	|
	|	ТаблицаТоваров.Подразделение,
	|	ТаблицаТоваров.Менеджер,
	|	ТаблицаТоваров.Сделка,
	|	ТаблицаТоваров.Назначение,
	|	ТаблицаТоваров.Партнер,
	|	ТаблицаТоваров.Соглашение
	|ИЗ
	|	Товары КАК ТаблицаТоваров
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.Организация КАК ДляОрганизации,
	|	ВЫБОР КОГДА &ВозвратПередач ТОГДА
	|		ТаблицаОстатков.ВидЗапасов.Организация
	|	ИНАЧЕ
	|		ТаблицаОстатков.Организация
	|	КОНЕЦ КАК Организация,
	|	ТаблицаОстатков.АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура,
	|	Аналитика.Характеристика,
	|	Аналитика.Серия,
	|	Аналитика.Склад,
	|	ВЫБОР КОГДА &ВозвратПередач ТОГДА
	|		ТаблицаОстатков.ВидЗапасов
	|	ИНАЧЕ
	|		ТаблицаОстатков.ВидЗапасовВладельца
	|	КОНЕЦ КАК ВидЗапасов,
	|
	|	ТаблицаОстатков.НомерГТД КАК НомерГТД,
	|	ТаблицаОстатков.НомерГТД.КодУКТВЭД КАК КодУКТВЭД,
	|	ТаблицаОстатков.НомерГТД.НомерГТД КАК Номер_ГТД,
	|	ТаблицаОстатков.НомерГТД.НомерГТД.Дата КАК ДатаГТД,
	|	ТаблицаОстатков.ДатаПоступления КАК ДатаПоступления,
	|	ТаблицаОстатков.НаДатуКонтроля,
	|	ТаблицаОстатков.НаДатуАктуальности,
	|	ТаблицаОстатков.КоличествоОстаток,
	|	ВЫБОР КОГДА Не ДоступныеВидыЗапасовДляОрганизаций.ВидЗапасов ЕСТЬ NULL ТОГДА
	|		ВЫБОР КОГДА &ЗапретитьОперацииСТоварамиБезНомеровГТД
	|			И Аналитика.Номенклатура.ВестиУчетПоГТД
	|			И ТаблицаОстатков.НомерГТД = ЗНАЧЕНИЕ(Справочник.НоменклатураГТД.ПустаяСсылка)
	|		ТОГДА
	|			0
	|		ИНАЧЕ
	|			ТаблицаОстатков.КоличествоОстаток
	|		КОНЕЦ
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК ДоступныйОстаток,
	|
	|	ВЫБОР КОГДА Не ДоступныеВидыЗапасовДляОрганизаций.ВидЗапасов ЕСТЬ NULL ТОГДА
	|		ВЫБОР КОГДА &ЗапретитьОперацииСТоварамиБезНомеровГТД
	|			И Аналитика.Номенклатура.ВестиУчетПоГТД
	|			И ТаблицаОстатков.НомерГТД = ЗНАЧЕНИЕ(Справочник.НоменклатураГТД.ПустаяСсылка)
	|		ТОГДА
	|			0
	|		ИНАЧЕ
	|			ВЫБОР КОГДА ДоступныеВидыЗапасовДляОрганизаций.ВидЗапасов.Организация = ТаблицаТоваров.Организация ТОГДА ТаблицаОстатков.КоличествоОстаток ИНАЧЕ 0 КОНЕЦ
	|		КОНЕЦ
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК ДоступныйОстатокБезИнтеркампани,
	|
	|	ТаблицаОстатков.ВидЗапасовВладельца.Подразделение КАК Подразделение,
	|	ТаблицаОстатков.ВидЗапасовВладельца.Менеджер КАК Менеджер,
	|	ТаблицаОстатков.ВидЗапасовВладельца.Сделка КАК Сделка,
	|	ТаблицаОстатков.ВидЗапасовВладельца.Соглашение КАК Соглашение,
	|
	|	ВЫБОР КОГДА ТаблицаОстатков.ВидЗапасовВладельца.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар) ТОГДА
	|		ТаблицаОстатков.ВидЗапасовВладельца.Комитент
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)
	|	КОНЕЦ КАК Партнер,
	|
	|	ВЫБОР КОГДА ТаблицаОстатков.ВидЗапасовВладельца.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар) ТОГДА
	|		ТаблицаОстатков.ВидЗапасовВладельца.НалоговоеНазначение 
	|	ИНАЧЕ
	|		ТаблицаОстатков.НалоговоеНазначение 
	|	КОНЕЦ КАК НалоговоеНазначение,
	|
	|	ВЫБОР КОГДА Не ДоступныеВидыЗапасовДляОрганизаций.ВидЗапасов ЕСТЬ NULL И Не ТаблицаТоваров.Назначение ЕСТЬ NULL ТОГДА
	|		ВЫБОР КОГДА &ЗапретитьОперацииСТоварамиБезНомеровГТД
	|			И Аналитика.Номенклатура.ВестиУчетПоГТД
	|			И ТаблицаОстатков.НомерГТД = ЗНАЧЕНИЕ(Справочник.НоменклатураГТД.ПустаяСсылка)
	|		ТОГДА
	|			Ложь
	|		ИНАЧЕ
	|			Истина
	|		КОНЕЦ
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ КАК ДоступенДляДокумента
	|ИЗ
	|	ТаблицаОстатков КАК ТаблицаОстатков
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		ТаблицаОстатков.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Товары КАК ТаблицаТоваров
	|	ПО  
	|		ТаблицаОстатков.АналитикаУчетаНоменклатуры = ТаблицаТоваров.АналитикаУчетаНоменклатуры
	|		И ТаблицаОстатков.Назначение = ТаблицаТоваров.Назначение
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ДоступныеВидыЗапасовДляОрганизаций КАК ДоступныеВидыЗапасовДляОрганизаций
	|	ПО  ТаблицаТоваров.Организация = ДоступныеВидыЗапасовДляОрганизаций.ДляОрганизации И (
	|		(Не &ПоТоварамКОформлению И ТаблицаОстатков.ВидЗапасовВладельца = ДоступныеВидыЗапасовДляОрганизаций.ВидЗапасов)
	|		ИЛИ
	|		(&ПоТоварамКОформлению
	|			И (&ПередачаТоваров И ТаблицаОстатков.ВидЗапасовПолучателя = ДоступныеВидыЗапасовДляОрганизаций.ВидЗапасовПродавца
	|				ИЛИ &ВозвратПередач И ТаблицаОстатков.ВидЗапасов = ДоступныеВидыЗапасовДляОрганизаций.ВидЗапасовПродавца)))
	|		
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		НалогообложениеОрганизаций КАК НалогообложениеОрганизаций
	|	ПО
	|		ТаблицаОстатков.Организация = НалогообложениеОрганизаций.Организация
	|ГДЕ
	|	ТаблицаОстатков.КоличествоОстаток > 0
	|	ИЛИ ТаблицаОстатков.НаДатуКонтроля <> 0
	|	ИЛИ ТаблицаОстатков.НаДатуАктуальности <> 0
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|");
	Запрос.УстановитьПараметр("Дата", ДокументОбъект.Дата);
	Запрос.УстановитьПараметр("ПоТоварамКОформлению", ПоТоварамКОформлению);
	Запрос.УстановитьПараметр("ЗапретитьОперацииСТоварамиБезНомеровГТД", ПолучитьФункциональнуюОпцию("ЗапретитьОформлениеОперацийСИмпортнымиТоварамиБезНомеровГТД"));
	Запрос.УстановитьПараметр("ПередачаТоваров", ТипДокумента = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями"));
	Запрос.УстановитьПараметр("ВозвратПередач", ТипДокумента = Тип("ДокументСсылка.ВозвратТоваровМеждуОрганизациями"));
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// МассивРезультатов[0] - НалогообложениеОрганизаций
	// МассивРезультатов[1] - Товары
	ТаблицаТоваров = МассивРезультатов[2].Выгрузить();
	ТаблицаОстатков = МассивРезультатов[3].Выгрузить();
	
	ВнешниеНаборыДанных = Новый Структура("ТаблицаТоваров, ТаблицаОстатков",
		ТаблицаТоваров,
		ТаблицаОстатков);
	
	ПараметрНаДату = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НаДату");
	Если ПараметрНаДату <> Неопределено Тогда
		ПараметрПользовательскойНастройки = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ПараметрНаДату.ИдентификаторПользовательскойНастройки);
		Если ПараметрПользовательскойНастройки <> Неопределено Тогда
			ПараметрПользовательскойНастройки.Значение = ДатаОстатков;
		Иначе
			ПараметрНаДату.Значение = ДатаОстатков;
		КонецЕсли;
	КонецЕсли;
	
	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(ПолучитьСтруктуруЗаголовковПолей(ДатаОстатков), МакетКомпоновки);
	 	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ТаблицаВСтроке = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ТаблицаВСтроке").Значение;	
 	Если ЭтоАдресВременногоХранилища(ТаблицаВСтроке) Тогда
		МассивНепроверяемыхРеквизитов = Новый Массив;
		МассивНепроверяемыхРеквизитов.Добавить("Документ");		
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруЗаголовковПолей(ДатаКонтроля)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Движения.Период
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизаций КАК Движения
	|УПОРЯДОЧИТЬ ПО
	|	Движения.Период УБЫВ
	|");
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДатаАктуальности = Выборка.Период;
	Иначе
		ДатаАктуальности = ТекущаяДатаСеанса();
	КонецЕсли;
	
	
	СтруктураЗаголовков = Новый Структура;
	
	СтруктураЗаголовков.Вставить("ДатаКонтроля", формат(ДатаКонтроля, "ДЛФ=Д"));
	СтруктураЗаголовков.Вставить("ДатаАктуальности", формат(ДатаАктуальности, "ДЛФ=Д"));

	Возврат СтруктураЗаголовков;
	
КонецФункции

#КонецОбласти

#КонецЕсли
