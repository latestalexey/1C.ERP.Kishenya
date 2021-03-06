
#Область ПрограммныйИнтерфейс

// Процедура проверяет правильность заполнения начала и конца периода.
//
// Параметры:
//	ДокументОбъект - Текущий документ
//	Отказ - Булево - Признак отказа от продолжения работы
//
Процедура ПроверитьКорректностьПериода(ДокументОбъект, Отказ) Экспорт
	
	Если ЗначениеЗаполнено(ДокументОбъект.НачалоПериода)
	 И ДокументОбъект.НачалоПериода > ДокументОбъект.КонецПериода Тогда
	 
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Дата начала периода не должна быть больше окончания периода %1';uk='Дата початку періоду не повинна бути більше закінчення періоду %1'"),
			Формат(ДокументОбъект.КонецПериода, "ДЛФ=DD"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ДокументОбъект,
			"КонецПериода",
			, // ПутьКДанным
			Отказ);
	 
	КонецЕсли;
	
КонецПроцедуры

// Процедура проверяет корректность указания услуги по комиссионному вознаграждению.
//
// Параметры:
//	ДокументОбъект - Текущий документ
//	Отказ - Булево - Признак отказа от продолжения работы
//
Процедура ПроверитьУслугуПоКомиссионномуВознаграждению(ДокументОбъект, Отказ) Экспорт
	
	Если ЗначениеЗаполнено(ДокументОбъект.Услуга) Тогда
		
		ХарактеристикиИспользуются = Справочники.Номенклатура.ХарактеристикиИспользуются(ДокументОбъект.Услуга);
		Если ХарактеристикиИспользуются Тогда
			ТекстОшибки = НСтр("ru='Необходимо указать услугу для которой не используются характеристики';uk='Необхідно вказати послугу для якої не використовуються характеристики'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ДокументОбъект,
				"Услуга",
				, // ПутьКДанным
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполнения документа по остаткам товаров к оформлению отчетов комитенту о списании.
//
Процедура ЗаполнитьТоварыПоОстаткамКОформлениюОтчетовКомитентуОСписании(Объект, НалогообложениеНДС) Экспорт	
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ВидыЗапасов.Ссылка КАК ВидЗапасов
	|
	|ПОМЕСТИТЬ ВидыЗапасов
	|ИЗ
	|	Справочник.ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	ВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	|	И ВидыЗапасов.Организация = &Организация
	|	И ВидыЗапасов.Комитент = &Комитент
	|	И (ВидыЗапасов.Соглашение = &Соглашение
	|		ИЛИ &Соглашение = Неопределено)
	|	И ВидыЗапасов.Валюта = &Валюта
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Обороты.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	Обороты.НалоговоеНазначение КАК НалоговоеНазначениеСписания,
	|	Обороты.КоличествоСписаноПриход - Обороты.КоличествоСписаноРасход КАК Количество
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТоварыКОформлению.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТоварыКОформлению.НалоговоеНазначение КАК НалоговоеНазначение,
	|		СУММА(ВЫБОР КОГДА ТоварыКОформлению.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|			ТоварыКОформлению.КоличествоСписано
	|		ИНАЧЕ
	|			0
	|		КОНЕЦ) КАК КоличествоСписаноПриход,
	|		СУММА(ВЫБОР КОГДА ТоварыКОформлению.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|			ТоварыКОформлению.КоличествоСписано
	|		ИНАЧЕ
	|			0
	|		КОНЕЦ) КАК КоличествоСписаноРасход
	|	ИЗ
	|		РегистрНакопления.ТоварыКОформлениюОтчетовКомитенту КАК ТоварыКОформлению
	|	ГДЕ
	|		ТоварыКОформлению.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|		И ТоварыКОформлению.Активность
	|		И ТоварыКОформлению.ВидЗапасов В (
	|			ВЫБРАТЬ
	|				ВидЗапасов
	|			ИЗ
	|				ВидыЗапасов КАК ВидыЗапасов
	|			)
	|		И ТоварыКОформлению.АналитикаУчетаНоменклатуры.Склад = &Комитент
	|	СГРУППИРОВАТЬ ПО
	|		ТоварыКОформлению.АналитикаУчетаНоменклатуры,
	|		ТоварыКОформлению.НалоговоеНазначение
	|	) КАК Обороты
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		Обороты.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|ГДЕ
	|	(Обороты.КоличествоСписаноПриход - Обороты.КоличествоСписаноРасход) <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Аналитика.Номенклатура,
	|	Аналитика.Характеристика,
	|	Аналитика.Серия
	|");
	ДатаДокумента = ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДата());
	Запрос.УстановитьПараметр("Валюта", Объект.Валюта);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Комитент", Объект.Партнер);
	Запрос.УстановитьПараметр("Соглашение", Объект.Соглашение);
	Запрос.УстановитьПараметр("НачалоПериода", ?(ЗначениеЗаполнено(Объект.НачалоПериода), Объект.НачалоПериода, '00010101'));
	Запрос.УстановитьПараметр("КонецПериода", ?(ЗначениеЗаполнено(Объект.КонецПериода), КонецДня(Объект.КонецПериода), КонецМесяца(ДатаДокумента)));
	
	Объект.Товары.Очистить();
	
	КэшированныеЗначения = Неопределено;
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС",  НалогообложениеНДС);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.КоличествоУпаковок = НоваяСтрока.Количество;
		
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(НоваяСтрока, СтруктураДействий, КэшированныеЗначения);
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Объект.Соглашение) Тогда
		СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект);
		ЗакупкиСервер.ЗаполнитьЦены(
			Объект.Товары,
			, // Массив строк
			Новый Структура( // Параметры заполнения
				"ПоляЗаполнения, Дата, Валюта, Соглашение",
				"Цена, СтавкаНДС",
				Объект.Дата,
				Объект.Валюта,
				Объект.Соглашение
			),
			Новый Структура( // Структура действий с измененныими строками
				"ПересчитатьСумму, ПересчитатьСуммуСНДС, ПересчитатьСуммуНДС",
				"КоличествоУпаковок", СтруктураПересчетаСуммы, СтруктураПересчетаСуммы));
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполнения документа по результатам продаж за период товаров к оформлению отчетов комитенту.
//
Процедура ЗаполнитьПоТоварамКОформлениюОтчетовКомитентуЗаПериод(Объект, НачалоПериода, КонецПериода, ЕстьСуммаПродажиНДС, НалогообложениеНДС) Экспорт	
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Валюта", Объект.Валюта);
	СтруктураПараметров.Вставить("Организация", Объект.Организация);
	СтруктураПараметров.Вставить("Партнер", Объект.Партнер);
	СтруктураПараметров.Вставить("Соглашение", Объект.Соглашение);
	СтруктураПараметров.Вставить("НачалоПериода", НачалоПериода);
	СтруктураПараметров.Вставить("КонецПериода", КонецДня(?(ЗначениеЗаполнено(КонецПериода), КонецПериода, ТекущаяДата())));
	СтруктураПараметров.Вставить("ЕстьСуммаПродажиНДС", ЕстьСуммаПродажиНДС);
	
	ЗапросПоТоварамКОформлениюОтчетовКомитентуЗаПериод(СтруктураПараметров, МенеджерВременныхТаблиц);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТоварыКОформлению.Номенклатура КАК Номенклатура,
	|	ТоварыКОформлению.Характеристика КАК Характеристика,
	|	ТоварыКОформлению.СтавкаНДСПродажи КАК СтавкаНДСПродажи,
	|	ТоварыКОформлению.Знак КАК Знак,
	|	СУММА(ТоварыКОформлению.Количество) КАК Количество,
	|	СУММА(ТоварыКОформлению.СуммаВыручки) КАК СуммаПродажи,
	|	СУММА(ТоварыКОформлению.КоличествоОстаток) КАК КоличествоОстаток,
	|	(ВЫБОР
	|		КОГДА ТоварыКОформлению.КоличествоОстаток >= 0 ТОГДА 1
	|		ИНАЧЕ -1 КОНЕЦ) КАК ОстатокЗнак,
	|	ТоварыКОформлению.ЕстьСуммаПродажиНДС КАК ЕстьСуммаПродажиНДС
	|ИЗ
	|	ТоварыКОформлению КАК ТоварыКОформлению
	|СГРУППИРОВАТЬ ПО
	|	ТоварыКОформлению.Номенклатура,
	|	ТоварыКОформлению.Характеристика,
	|	ТоварыКОформлению.СтавкаНДСПродажи,
	|	ТоварыКОформлению.ЕстьСуммаПродажиНДС,
	|	ТоварыКОформлению.Знак,
	|	(ВЫБОР
	|		КОГДА ТоварыКОформлению.КоличествоОстаток >= 0 ТОГДА 1
	|		ИНАЧЕ -1 КОНЕЦ)
	|
	|ИТОГИ
	|	СУММА(Количество),
	|	СУММА(КоличествоОстаток)
	|ПО
	|	Номенклатура,
	|	Характеристика
	|");

	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ЗаполнитьТЧПоТоварамКОформлениюОтчетовКомитентуЗаПериод(Объект.Товары, РезультатЗапроса, НалогообложениеНДС);
	ЗакупкиСервер.ЗаполнитьНоменклатуруПоставщикаВТаблице(Объект.Товары, Объект.Партнер);
	
	Если ЗначениеЗаполнено(Объект.Соглашение) Тогда
		
		СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект);
		ЗакупкиСервер.ЗаполнитьЦены(
			Объект.Товары,
			, // Массив строк
			Новый Структура( // Параметры заполнения
				"ПоляЗаполнения, Дата, Валюта, Соглашение",
				"Цена, СтавкаНДС",
				Объект.Дата,
				Объект.Валюта,
				Объект.Соглашение
			),
			Новый Структура( // Структура действий с измененными строками
				"ПересчитатьСумму, ПересчитатьСуммуСНДС, ПересчитатьСуммуНДС",
				"КоличествоУпаковок", СтруктураПересчетаСуммы, СтруктураПересчетаСуммы));
		
	Иначе
		
		ЗаполнитьСуммуСНДС(
			Объект.Товары,
			Объект.ЦенаВключаетНДС);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура формирования временной таблицы "ТоварыКОформлению" по результатам продаж за период
//
Процедура ЗапросПоТоварамКОформлениюОтчетовКомитентуЗаПериод(СтруктураПараметров, МенеджерВременныхТаблиц) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ВидыЗапасов.Ссылка КАК ВидЗапасов
	|
	|ПОМЕСТИТЬ ВидыЗапасов
	|ИЗ
	|	Справочник.ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	ВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	|	И ВидыЗапасов.Организация = &Организация
	|	И ВидыЗапасов.Комитент = &Комитент
	|	И (ВидыЗапасов.Соглашение = &Соглашение
	|		ИЛИ &Соглашение = Неопределено)
	|	И ВидыЗапасов.Валюта = &Валюта
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыКОформлению.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТоварыКОформлению.НомерГТД КАК НомерГТД,
	|	ТоварыКОформлению.СтавкаНДС КАК СтавкаНДС,
	|	(ВЫБОР
	|		КОГДА ТоварыКОформлению.Количество >= 0 ТОГДА 1
	|		ИНАЧЕ -1 КОНЕЦ) КАК Знак,
	|	
	|	СУММА(ВЫБОР КОГДА ТоварыКОформлению.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|		ТоварыКОформлению.Количество
	|	ИНАЧЕ
	|		-ТоварыКОформлению.Количество
	|	КОНЕЦ) КАК Количество,
	|	
	|	СУММА(ВЫБОР КОГДА ТоварыКОформлению.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|		ТоварыКОформлению.СуммаВыручки
	|	ИНАЧЕ
	|		-ТоварыКОформлению.СуммаВыручки
	|	КОНЕЦ) КАК СуммаВыручки
	|
	|ПОМЕСТИТЬ ТоварыКОформлениюЗаПериод
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюОтчетовКомитенту КАК ТоварыКОформлению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ВидыЗапасов КАК ВидыЗапасов
	|	ПО
	|		ТоварыКОформлению.ВидЗапасов = ВидыЗапасов.ВидЗапасов
	|	
	|	
	|ГДЕ
	|	ТоварыКОформлению.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|	И ТоварыКОформлению.Активность
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыКОформлению.АналитикаУчетаНоменклатуры,
	|	ТоварыКОформлению.НомерГТД,
	|	ТоварыКОформлению.СтавкаНДС,
	|	(ВЫБОР
	|		КОГДА ТоварыКОформлению.Количество >= 0 ТОГДА 1
	|		ИНАЧЕ -1 КОНЕЦ)
	|
	|ИМЕЮЩИЕ
	|	СУММА(ВЫБОР КОГДА ТоварыКОформлению.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|		ТоварыКОформлению.Количество
	|	ИНАЧЕ
	|		-ТоварыКОформлению.Количество
	|	КОНЕЦ) <> 0
	|	И
	|	СУММА(ВЫБОР КОГДА ТоварыКОформлению.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
	|		ТоварыКОформлению.СуммаВыручки
	|	ИНАЧЕ
	|		-ТоварыКОформлению.СуммаВыручки
	|	КОНЕЦ) <> 0
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	ТоварыКОформлениюЗаПериод.СтавкаНДС КАК СтавкаНДСПродажи,
	|	ТоварыКОформлениюЗаПериод.Знак КАК Знак,
	|	ТоварыКОформлениюЗаПериод.Количество КАК Количество,
	|	ТоварыКОформлениюЗаПериод.НомерГТД КАК НомерГТД,
	|	ТоварыКОформлениюЗаПериод.СуммаВыручки КАК СуммаВыручки,
	|	ТоварыКОформлениюЗаПериод.Количество КАК КоличествоОстаток,
	|	&ЕстьСуммаПродажиНДС КАК ЕстьСуммаПродажиНДС,
	|	ТоварыКОформлениюЗаПериод.АналитикаУчетаНоменклатуры
	|
	|ПОМЕСТИТЬ ТоварыКОформлению
	|ИЗ
	|	ТоварыКОформлениюЗаПериод КАК ТоварыКОформлениюЗаПериод
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		ТоварыКОформлениюЗаПериод.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Аналитика.Номенклатура,
	|	Аналитика.Характеристика
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТоварыКОформлениюЗаПериод
	|");
	Запрос.УстановитьПараметр("НачалоПериода", СтруктураПараметров.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", СтруктураПараметров.КонецПериода);
	
	Запрос.УстановитьПараметр("Валюта", СтруктураПараметров.Валюта);
	Запрос.УстановитьПараметр("Организация", СтруктураПараметров.Организация);
	Запрос.УстановитьПараметр("Комитент", СтруктураПараметров.Партнер);
	Запрос.УстановитьПараметр("Соглашение", СтруктураПараметров.Соглашение);
	Запрос.УстановитьПараметр("ЕстьСуммаПродажиНДС", СтруктураПараметров.ЕстьСуммаПродажиНДС);
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Выполнить();
	
КонецПроцедуры

// Процедура заполнения табличной части по данным временной таблицы "ТоварыКОформлению"
//
Процедура ЗаполнитьТЧПоТоварамКОформлениюОтчетовКомитентуЗаПериод(ТабличнаяЧасть, РезультатЗапроса, НалогообложениеНДС) Экспорт
	
	ТабличнаяЧасть.Очистить();
	
	КэшированныеЗначения = Неопределено;
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", НалогообложениеНДС);
	
	ВыборкаПоНоменклатуре = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоНоменклатуре.Следующий() Цикл
		
		ВыборкаПоХарактеристике = ВыборкаПоНоменклатуре.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоХарактеристике.Следующий() Цикл
			
			Если ВыборкаПоХарактеристике.КоличествоОстаток >= ВыборкаПоХарактеристике.Количество
			 ИЛИ ВыборкаПоХарактеристике.ОстатокЗнак <> ВыборкаПоХарактеристике.Знак Тогда
			
				Выборка = ВыборкаПоХарактеристике.Выбрать();
				Пока Выборка.Следующий() Цикл
					ДобавитьСтрокуПоТоварамКОформлениюОтчетовКомитентуЗаПериод(ТабличнаяЧасть, Выборка, Выборка.Количество, СтруктураДействий, КэшированныеЗначения);
				КонецЦикла;
			
			Иначе
			
				КоличествоКРаспределению = ВыборкаПоХарактеристике.КоличествоОстаток;
			
				Выборка = ВыборкаПоХарактеристике.Выбрать();
				Пока Выборка.Следующий() Цикл
				
					Если Выборка.Количество <= КоличествоКРаспределению Тогда
						ДобавитьСтрокуПоТоварамКОформлениюОтчетовКомитентуЗаПериод(ТабличнаяЧасть, Выборка, Выборка.Количество, СтруктураДействий, КэшированныеЗначения);
						КоличествоКРаспределению = КоличествоКРаспределению - Выборка.Количество;
					Иначе
						ДобавитьСтрокуПоТоварамКОформлениюОтчетовКомитентуЗаПериод(ТабличнаяЧасть, Выборка, КоличествоКРаспределению, СтруктураДействий, КэшированныеЗначения);
						КоличествоКРаспределению = 0;
					КонецЕсли;
					Если КоличествоКРаспределению = 0 Тогда
						Прервать;
					КонецЕсли;
				
				КонецЦикла;
			
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура заполнения документа по остаткам товаров переданных на комиссию
//
// Параметры:
//	Объект - ДокументОбъект - Текущий документ
//	КонецПериода - Дата - Дата заполнения
//	ЕстьСуммаПродажи - Булево - В документе есть данные о сумме продажи
//
Процедура ЗаполнитьТоварыПоОстаткамПереданныхНаКомиссию(Объект, КонецПериода, ЕстьСуммаПродажи) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТоварыПереданные.АналитикаУчетаНоменклатуры	КАК АналитикаУчетаНоменклатуры,
	|	ТоварыПереданные.КоличествоОстаток			КАК КоличествоОстаток
	|
	|ПОМЕСТИТЬ ТоварыПереданные
	|
	|ИЗ
	|	РегистрНакопления.ТоварыПереданныеНаКомиссию.Остатки(&Граница,
	|		Организация = &Организация
	|		И (ВЫРАЗИТЬ(АналитикаУчетаНоменклатуры.Склад КАК Справочник.Партнеры)) = &Партнер
	|		И Соглашение = &Соглашение
	|	) КАК ТоварыПереданные
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыПереданные.АналитикаУчетаНоменклатуры	КАК АналитикаУчетаНоменклатуры,
	|	ТоварыПереданные.КоличествоОстаток			КАК КоличествоОстаток,
	|
	|	ВЫБОР КОГДА ТоварыПереданные.КоличествоОстаток < 0 ТОГДА
	|		-1
	|	ИНАЧЕ
	|		1
	|	КОНЕЦ КАК Знак
	|
	|ПОМЕСТИТЬ ТоварыПереданныеОстатки
	|
	|ИЗ
	|	РегистрНакопления.ТоварыПереданныеНаКомиссию.Остатки(,
	|		Организация = &Организация
	|		И (ВЫРАЗИТЬ(АналитикаУчетаНоменклатуры.Склад КАК Справочник.Партнеры)) = &Партнер
	|		И Соглашение = &Соглашение
	|	) КАК ТоварыПереданные
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыПереданные.АналитикаУчетаНоменклатуры	КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура						КАК Номенклатура,
	|	Аналитика.Характеристика					КАК Характеристика,
	|	Аналитика.Серия								КАК Серия,
	|
	|	ВЫБОР КОГДА ЕСТЬNULL(ТоварыПереданныеОстатки.КоличествоОстаток * ТоварыПереданныеОстатки.Знак, 0)
	|		< (ТоварыПереданные.КоличествоОстаток * ЕСТЬNULL(ТоварыПереданныеОстатки.Знак, 1))
	|	ТОГДА
	|		ЕСТЬNULL(ТоварыПереданныеОстатки.КоличествоОстаток, 0)
	|	ИНАЧЕ
	|		ТоварыПереданные.КоличествоОстаток
	|	КОНЕЦ КАК Количество
	|
	|ИЗ
	|	ТоварыПереданные КАК ТоварыПереданные
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТоварыПереданныеОстатки КАК ТоварыПереданныеОстатки
	|	ПО
	|		ТоварыПереданные.АналитикаУчетаНоменклатуры = ТоварыПереданныеОстатки.АналитикаУчетаНоменклатуры
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		ТоварыПереданные.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|ГДЕ
	|	ТоварыПереданные.КоличествоОстаток <> 0
	|	И ЕСТЬNULL(ТоварыПереданныеОстатки.КоличествоОстаток, 0) <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТоварыПереданные.АналитикаУчетаНоменклатуры
	|");
	
	ДатаЗаполнения = ?(ЗначениеЗаполнено(КонецПериода), КонецПериода, ТекущаяДата());
	Граница = Новый Граница(КонецДня(ДатаЗаполнения), ВидГраницы.Включая);
	Запрос.УстановитьПараметр("Граница",		Граница);
	Запрос.УстановитьПараметр("Организация",	Объект.Организация);
	Запрос.УстановитьПараметр("Партнер",		Объект.Партнер);
	Запрос.УстановитьПараметр("Соглашение",		Объект.Соглашение);
	
	Объект.Товары.Очистить();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		НоваяСтрока.КоличествоУпаковокУчет = НоваяСтрока.Количество;
		НоваяСтрока.КоличествоУпаковок = НоваяСтрока.Количество;
	КонецЦикла;
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект);
	ПродажиСервер.ЗаполнитьЦены(
		Объект.Товары,
		, // Массив строк или структура отбора
		Новый Структура( // Параметры заполнения
			"Дата, Валюта, Соглашение, ПоляЗаполнения",
			ДатаЗаполнения,
			Объект.Валюта,
			Объект.Соглашение,
			"Цена, СтавкаНДС, ВидЦены"
		),
		Новый Структура( // Структура действий с измененными строками
			"ПересчитатьСумму, ПересчитатьСуммуСНДС, ПересчитатьСуммуНДС",
			"КоличествоУпаковок", СтруктураПересчетаСуммы, СтруктураПересчетаСуммы));
	
	Для Каждого СтрокаТаблицы Из Объект.Товары Цикл
		СтрокаТаблицы.СуммаСНДС = СтрокаТаблицы.Сумма + ?(Объект.ЦенаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
		Если ЕстьСуммаПродажи Тогда
			СтрокаТаблицы.СуммаПродажи = СтрокаТаблицы.СуммаСНДС;
			СтрокаТаблицы.СуммаПродажиНДС = СуммаПродажиНДС(СтрокаТаблицы.СуммаПродажи, СтрокаТаблицы.СтавкаНДС);
			СтрокаТаблицы.ЦенаПродажи = ?(СтрокаТаблицы.КоличествоУпаковок <> 0, СтрокаТаблицы.СуммаПродажи / СтрокаТаблицы.КоличествоУпаковок, 0);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Процедура заполнения колонки документа по данным учета.
//
// Параметры:
//	Объект - ДокументОбъект - Текущий документ
//	КонецПериода - Дата - Дата заполнения
//	ЕстьСуммаПродажи - Булево - В документе есть данные о сумме продажи
//	РассчитыватьВознаграждение - Булево - Признак необходимости расчета комиссионного вознаграждения
//
Процедура ПересчитатьОстаткиПоДаннымУчета(Объект, КонецПериода, ЕстьСуммаПродажи, РассчитыватьВознаграждение = Ложь, НомерСтроки  = Неопределено) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) КАК Серия,
	|	Товары.Упаковка КАК Упаковка
	|
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|ГДЕ
	|	&НомерСтроки = Неопределено
	|	ИЛИ Товары.НомерСтроки = &НомерСтроки
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Аналитика.КлючАналитики КАК КлючАналитики
	|
	|ПОМЕСТИТЬ ВтАналитика
	|ИЗ
	|	РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Товары КАК Товары
	|	ПО
	|		Аналитика.Номенклатура = Товары.Номенклатура
	|		И Аналитика.Характеристика = Товары.Характеристика
	|		И Аналитика.Серия = Товары.Серия
	|ГДЕ
	|	Аналитика.Склад = &Партнер
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	Остатки.КоличествоОстаток КАК КоличествоУпаковокУчет
	|
	|ПОМЕСТИТЬ ТоварыПереданные
	|ИЗ
	|	РегистрНакопления.ТоварыПереданныеНаКомиссию.Остатки(&Граница,
	|		Организация = &Организация
	|		И Соглашение = &Соглашение
	|		И АналитикаУчетаНоменклатуры В (
	|			ВЫБРАТЬ
	|				Аналитика.КлючАналитики
	|			ИЗ
	|				ВтАналитика КАК Аналитика
	|			)
	|	) КАК Остатки
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО
	|		Остатки.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Серия КАК Серия,
	|	ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1) КАК Коэффициент,
	|	ЕСТЬNULL(ТоварыПереданные.КоличествоУпаковокУчет, 0) КАК КоличествоУпаковокУчет
	|ИЗ
	|	Товары КАК Товары
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТоварыПереданные КАК ТоварыПереданные
	|	ПО
	|		Товары.Номенклатура = ТоварыПереданные.Номенклатура
	|		И Товары.Характеристика = ТоварыПереданные.Характеристика
	|		И Товары.Серия = ТоварыПереданные.Серия
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.УпаковкиЕдиницыИзмерения КАК Упаковки
	|	ПО
	|		Товары.Упаковка = Упаковки.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"Упаковки",
		"Товары.Номенклатура"));

	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Партнер", Объект.Партнер);
	Запрос.УстановитьПараметр("Соглашение", Объект.Соглашение);
	Запрос.УстановитьПараметр("НомерСтроки", НомерСтроки);
	
	ДатаЗаполнения = ?(ЗначениеЗаполнено(КонецПериода), КонецПериода, ТекущаяДата());
	Граница = Новый Граница(КонецДня(ДатаЗаполнения), ВидГраницы.Включая);
	Запрос.УстановитьПараметр("Граница", Граница);
	
	Товары = Объект.Товары.Выгрузить();
	Запрос.УстановитьПараметр("Товары", Товары);
	
	КэшированныеЗначения = Неопределено;
	ТабличнаяЧастьОбновлена = Ложь;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаТаблицы = Объект.Товары[Выборка.НомерСтроки - 1];
		КоличествоУпаковокУчет = ?(Выборка.Коэффициент <> 0, Окр(Выборка.КоличествоУпаковокУчет / Выборка.Коэффициент, 2, 1), 0);
		Если СтрокаТаблицы.КоличествоУпаковокУчет <> КоличествоУпаковокУчет Тогда
			
			СтрокаТаблицы.КоличествоУпаковокУчет = КоличествоУпаковокУчет;
			СтрокаТаблицы.КоличествоУпаковок = Выборка.КоличествоУпаковокУчет - СтрокаТаблицы.КоличествоУпаковокФакт;
			
			СтруктураДействий = Новый Структура;
			СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
			СтруктураДействий.Вставить("ПересчитатьСуммуНДС", Новый Структура("ЦенаВключаетНДС", Объект.ЦенаВключаетНДС));
			СтруктураДействий.Вставить("ПересчитатьСумму");

			ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТаблицы, СтруктураДействий, КэшированныеЗначения);
			
			СтрокаТаблицы.СуммаСНДС = СтрокаТаблицы.Сумма + ?(Объект.ЦенаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
			Если ЕстьСуммаПродажи Тогда
				СтрокаТаблицы.СуммаПродажи = СтрокаТаблицы.ЦенаПродажи * СтрокаТаблицы.КоличествоУпаковок;
				СтрокаТаблицы.СуммаПродажиНДС = СуммаПродажиНДС(СтрокаТаблицы.СуммаПродажи, СтрокаТаблицы.СтавкаНДС);
			КонецЕсли;
			
			РассчитыватьВознаграждение = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура заполяет сумму с НДС в строках табличной части "Товары".
//
Процедура ЗаполнитьСуммуСНДС(Товары, ЦенаВключаетНДС) Экспорт
	
	Для Каждого СтрокаТаблицы Из Товары Цикл
		СтрокаТаблицы.СуммаСНДС = СтрокаТаблицы.Сумма
			+ ?(ЦенаВключаетНДС, 0, СтрокаТаблицы.СуммаНДС);
	КонецЦикла;
	
КонецПроцедуры

// Процедура рассчитывает комиссионное вознаграждение.
//
// Параметры:
//	Объект - ДанныеФормыСтруктура - Текущий документ
//	ПроцентНДС - Число - Процент НДС
//
Процедура РассчитатьСуммуНДСВознаграждения(Объект, ПроцентНДС) Экспорт
	
	Объект.СуммаНДСВознаграждения = Окр(Объект.СуммаВознаграждения * ПроцентНДС / (1 + ПроцентНДС), 2, РежимОкругления.Окр15как20);
	
КонецПроцедуры

// Процедура рассчитывает комиссионное вознаграждение.
//
Процедура РассчитатьСуммуВознаграждения(Объект) Экспорт
	
	Для Каждого СтрокаТоваров Из Объект.Товары Цикл
		
		Если Объект.СпособРасчетаВознаграждения = Перечисления.СпособыРасчетаКомиссионногоВознаграждения.ПроцентОтРазностиСуммыПродажиИСуммыКомитента Тогда
			СтрокаТоваров.СуммаВознаграждения = (СтрокаТоваров.СуммаПродажи - СтрокаТоваров.СуммаСНДС) * Объект.ПроцентВознаграждения / 100;
			
		ИначеЕсли Объект.СпособРасчетаВознаграждения = Перечисления.СпособыРасчетаКомиссионногоВознаграждения.ПроцентОтСуммыПродажи Тогда
			СтрокаТоваров.СуммаВознаграждения = СтрокаТоваров.СуммаПродажи * Объект.ПроцентВознаграждения / 100;
			
		Иначе
			СтрокаТоваров.СуммаВознаграждения = 0;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Объект.СуммаВознаграждения = Объект.Товары.Итог("СуммаВознаграждения");
	
	ПроцентНДС = ЦенообразованиеКлиентСервер.ПолучитьСтавкуНДСЧислом(Объект.СтавкаНДСВознаграждения);
	РассчитатьСуммуНДСВознаграждения(Объект, ПроцентНДС);
	
КонецПроцедуры

// Процедура заполняет ставку НДС для комиссионного вознаграждения.
//
// Параметры:
//	Объект - ДанныеФормыСтруктура - Текущий документ
//	ПроцентНДС - Число - Процент НДС
//
Процедура ЗаполнитьСтавкуНДСкомиссионногоВознаграждения(Объект, ПроцентНДС, ЭтоПродажа = Ложь) Экспорт
	
	НалогообложениеНДС = НДСОбщегоНазначенияСервер.ПолучитьНалогообложениеНДС(Объект.Организация, Объект.Контрагент, Объект.Дата, ЭтоПродажа);	
	
	Если НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС Тогда
		Объект.СтавкаНДСВознаграждения = Справочники.Номенклатура.ЗначенияРеквизитовНоменклатуры(Объект.Услуга).СтавкаНДС;
	Иначе
		Объект.СтавкаНДСВознаграждения = Перечисления.СтавкиНДС.НеНДС;
	КонецЕсли;
	ПроцентНДС = ЦенообразованиеКлиентСервер.ПолучитьСтавкуНДСЧислом(Объект.СтавкаНДСВознаграждения);
	РассчитатьСуммуНДСВознаграждения(Объект, ПроцентНДС);
	
КонецПроцедуры

// Процедура заполняет сумму НДС комиссионного вознаграждения в табличной части документа.
//
Процедура ЗаполнитьСуммуНДСВознагражденияВТабличнойЧасти(Товары, Знач СуммаНДСВознаграждения) Экспорт
	
	ВсегоСуммаВознаграждения = Товары.Итог("СуммаВознаграждения");
	
	Для Каждого СтрокаТаблицы Из Товары Цикл
		
		СтрокаТаблицы.СуммаНДСВознаграждения = ?(ВсегоСуммаВознаграждения <> 0, Окр(СуммаНДСВознаграждения * СтрокаТаблицы.СуммаВознаграждения / ВсегоСуммаВознаграждения, 2, 1), 0);
		
		ВсегоСуммаВознаграждения = ВсегоСуммаВознаграждения - СтрокаТаблицы.СуммаВознаграждения;
		СуммаНДСВознаграждения = СуммаНДСВознаграждения - СтрокаТаблицы.СуммаНДСВознаграждения;
			
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьСтрокуПоТоварамКОформлениюОтчетовКомитентуЗаПериод(ТабличнаяЧасть, ДанныеСтроки, Количество, СтруктураДействий, КэшированныеЗначения)
	
	НоваяСтрока = ТабличнаяЧасть.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеСтроки);
	
	НоваяСтрока.Количество         = Количество;
	НоваяСтрока.КоличествоУпаковок = Количество;
	
	Если ДанныеСтроки.Количество < Количество Тогда
		НоваяСтрока.СуммаПродажи = ДанныеСтроки.СуммаПродажи / ДанныеСтроки.Количество * Количество;
	КонецЕсли;
	
	НоваяСтрока.ЦенаПродажи = ?(НоваяСтрока.Количество <> 0, НоваяСтрока.СуммаПродажи / НоваяСтрока.Количество, 0);
	
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(НоваяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	Если ДанныеСтроки.ЕстьСуммаПродажиНДС Тогда
		НоваяСтрока.СуммаПродажиНДС = СуммаПродажиНДС(НоваяСтрока.СуммаПродажи, НоваяСтрока.СтавкаНДСПродажи);
	КонецЕсли;
	
КонецПроцедуры

Функция СуммаПродажиНДС(СуммаПродажи, СтавкаНДС)
	
	ТекущийПроцентНДС = ЦенообразованиеКлиентСервер.ПолучитьСтавкуНДСЧислом(СтавкаНДС);
	СуммаПродажиНДС = Окр(СуммаПродажи * ТекущийПроцентНДС / (1 + ТекущийПроцентНДС), 2, РежимОкругления.Окр15как20);
	
	Возврат СуммаПродажиНДС;
	
КонецФункции

#КонецОбласти
