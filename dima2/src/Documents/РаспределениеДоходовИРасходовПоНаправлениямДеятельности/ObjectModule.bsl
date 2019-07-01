#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Доходы.Очистить();
	Расходы.Очистить();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если РаспределениеПоВсемОрганизациям Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Организация");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("Доходы.Организация");
		МассивНепроверяемыхРеквизитов.Добавить("Расходы.Организация");
	КонецЕсли;
	
	// Если есть строка, в которой не требуется способ распределения,
	// выполним специальную проверку заполнения способа распределения.
		
	МассивНепроверяемыхРеквизитов.Добавить("Доходы.СпособРаспределения");
	
	Для Каждого СтрокаТаблицы Из Доходы Цикл
		
		ВыводитьСообщение = Ложь;
		Если СтрокаТаблицы.ТребуетсяСпособРаспределения
		   И Не ЗначениеЗаполнено(СтрокаТаблицы.СпособРаспределения) Тогда
			ВыводитьСообщение = Истина;
			
		ИначеЕсли Не СтрокаТаблицы.ТребуетсяСпособРаспределения
			И Не ЗначениеЗаполнено(СтрокаТаблицы.АналитикаДоходов)
			И Не ЗначениеЗаполнено(СтрокаТаблицы.СпособРаспределения) Тогда
			ВыводитьСообщение = Истина;
			
		КонецЕсли;
		Если ВыводитьСообщение Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не заполнена колонка ""Способ распределения"" в строке %1 списка ""Доходы"".';uk='Не заповнена колонка ""Спосіб розподілу"" в рядку %1 списку ""Доходи"".'"),
				СтрокаТаблицы.НомерСтроки);
			Если НЕ ДополнительныеСвойства.Свойство("ВыводитьСообщенияВЖурналРегистрации") Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					Текст,
					ЭтотОбъект,
					"Доходы[" + (СтрокаТаблицы.НомерСтроки - 1) + "].СпособРаспределения",
					,
					Отказ);
			Иначе
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
			
	КонецЦикла;
	
	МассивНепроверяемыхРеквизитов.Добавить("Расходы.СпособРаспределения");
	
	Для Каждого СтрокаТаблицы Из Расходы Цикл
		
		ВыводитьСообщение = Ложь;
		Если СтрокаТаблицы.ТребуетсяСпособРаспределения
		   И Не ЗначениеЗаполнено(СтрокаТаблицы.СпособРаспределения) Тогда
			ВыводитьСообщение = Истина;
			
		ИначеЕсли Не СтрокаТаблицы.ТребуетсяСпособРаспределения
			И Не ЗначениеЗаполнено(СтрокаТаблицы.АналитикаРасходов)
			И Не ЗначениеЗаполнено(СтрокаТаблицы.СпособРаспределения) Тогда
			ВыводитьСообщение = Истина;
			
		КонецЕсли;
		Если ВыводитьСообщение Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не заполнена колонка ""Способ распределения"" в строке %1 списка ""Расходы"".';uk='Не заповнена колонка ""Спосіб розподілу"" в рядку %1 списку ""Витрати"".'"),
				СтрокаТаблицы.НомерСтроки);
    		Если НЕ ДополнительныеСвойства.Свойство("ВыводитьСообщенияВЖурналРегистрации") Тогда
    			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
    				Текст,
    				ЭтотОбъект,
    				"Расходы[" + (СтрокаТаблицы.НомерСтроки - 1) + "].СпособРаспределения",
    				,
    				Отказ);
    		Иначе
    			Отказ = Истина;
    		КонецЕсли;
        КонецЕсли;
        Если СтрокаТаблицы.Сумма = 0 И СтрокаТаблицы.СуммаРегл = 0 И СтрокаТаблицы.СуммаРеглБезНДС = 0 И СтрокаТаблицы.НДСРегл = 0 Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не заполнена ни одна сумма в строке %1 списка ""Расходы"".';uk= 'Не заповнена жодна сума в рядку %1 списку ""Витрати"".'"),
				СтрокаТаблицы.НомерСтроки);
    		Если НЕ ДополнительныеСвойства.Свойство("ВыводитьСообщенияВЖурналРегистрации") Тогда
    			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
    				Текст,
    				ЭтотОбъект,
    				"Расходы[" + (СтрокаТаблицы.НомерСтроки - 1) + "].Сумма",
    				,
    				Отказ);
    		Иначе
    			Отказ = Истина;
    		КонецЕсли;
        КонецЕсли; 
    
			
	КонецЦикла;
	
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, Новый Структура("Расходы"), МассивНепроверяемыхРеквизитов, Отказ);
	
	ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, Новый Структура("Доходы"), МассивНепроверяемыхРеквизитов, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если РаспределениеПоВсемОрганизациям Тогда
		Если ЗначениеЗаполнено(Организация) Тогда
			Организация = Неопределено;
		КонецЕсли;
		ОбновитьПредставлениеОрганизации();
	Иначе
		Для Каждого СтрокаТаблицы Из Доходы Цикл
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.Организация) Тогда
				СтрокаТаблицы.Организация = Организация;
			КонецЕсли;
		КонецЦикла;
		Для Каждого СтрокаТаблицы Из Расходы Цикл
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.Организация) Тогда
				СтрокаТаблицы.Организация = Организация;
			КонецЕсли;
		КонецЦикла;
		ПредставлениеОрганизаций = Строка(Организация);
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из Доходы Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.АналитикаДоходов)
			И ТипЗнч(СтрокаТаблицы.АналитикаДоходов) = Тип("СправочникСсылка.НаправленияДеятельности") Тогда
			СтрокаТаблицы.СпособРаспределения = Справочники.СпособыРаспределенияПоНаправлениямДеятельности.ПустаяСсылка();
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из Расходы Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.АналитикаРасходов)
			И ТипЗнч(СтрокаТаблицы.АналитикаРасходов) = Тип("СправочникСсылка.НаправленияДеятельности") Тогда
			СтрокаТаблицы.СпособРаспределения = Справочники.СпособыРаспределенияПоНаправлениямДеятельности.ПустаяСсылка();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.РаспределениеДоходовИРасходовПоНаправлениямДеятельности.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения по прочим доходам и расходам.
	ДоходыИРасходыСервер.ОтразитьПрочиеДоходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьФинансовыеРезультаты(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#Область ЗаполнениеДокумента

Процедура ЗаполнитьДоходыПоОстаткам() Экспорт

	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Доходы.Организация КАК Организация,
	|	Доходы.Подразделение КАК Подразделение,
	|	Доходы.СтатьяДоходов КАК СтатьяДоходов,
	|	Доходы.АналитикаДоходов КАК АналитикаДоходов,
	|	Доходы.СпособРаспределения КАК СпособРаспределения
	|
	|ПОМЕСТИТЬ Доходы
	|ИЗ
	|	&Доходы КАК Доходы
	|ГДЕ
	|	Доходы.СпособРаспределения <> ЗНАЧЕНИЕ(Справочник.СпособыРаспределенияПоНаправлениямДеятельности.ПустаяСсылка)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Доходы.Организация КАК Организация,
	|	Доходы.Подразделение КАК Подразделение,
	|	Доходы.СтатьяДоходов КАК СтатьяДоходов,
	|	Доходы.АналитикаДоходов КАК АналитикаДоходов,
	|	МАКСИМУМ(Доходы.СпособРаспределения) КАК СпособРаспределения
	|
	|ПОМЕСТИТЬ Аналитика
	|ИЗ
	|	Доходы КАК Доходы
	|
	|СГРУППИРОВАТЬ ПО
	|	Доходы.Организация,
	|	Доходы.Подразделение,
	|	Доходы.СтатьяДоходов,
	|	Доходы.АналитикаДоходов
	|;
	|/////////////////////////////////////////////////////////////////////////////
	| ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПрочиеДоходы.Организация КАК Организация,
	|	ПрочиеДоходы.Подразделение КАК Подразделение,
	|	ПрочиеДоходы.СтатьяДоходов КАК СтатьяДоходов,
	|	ПрочиеДоходы.АналитикаДоходов КАК АналитикаДоходов,
	|	ЕСТЬNULL(Аналитика.СпособРаспределения,
	|	(ВЫБОР
	|		КОГДА ПрочиеДоходы.СтатьяДоходов.СпособРаспределения
	|			<> ЗНАЧЕНИЕ(Справочник.СпособыРаспределенияПоНаправлениямДеятельности.ПустаяСсылка)
	|		ТОГДА ПрочиеДоходы.СтатьяДоходов.СпособРаспределения
	|		ИНАЧЕ &СпособРаспределения КОНЕЦ)) КАК СпособРаспределения,
	|	ПрочиеДоходы.СуммаОстаток КАК Сумма,
	|
	|	ВЫБОР КОГДА ПрочиеДоходы.АналитикаДоходов ССЫЛКА Справочник.НаправленияДеятельности ТОГДА
	|		Ложь
	|	ИНАЧЕ
	|		Истина
	|	КОНЕЦ КАК ТребуетсяСпособРаспределения
	|ИЗ
	|	РегистрНакопления.ПрочиеДоходы.Остатки(&Граница, 
	|		Организация = &Организация
	|		ИЛИ &ПоВсемОрганизациям
	|	) КАК ПрочиеДоходы
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Аналитика КАК Аналитика
	|	ПО
	|		ПрочиеДоходы.Организация = Аналитика.Организация
	|		И ПрочиеДоходы.Подразделение = Аналитика.Подразделение
	|		И ПрочиеДоходы.СтатьяДоходов  = Аналитика.СтатьяДоходов
	|		И ПрочиеДоходы.АналитикаДоходов = Аналитика.АналитикаДоходов
	|ГДЕ
	|	ПрочиеДоходы.СуммаОстаток <> 0
	|");
	Граница = Новый Граница(КонецМесяца(Дата), ВидГраницы.Включая);
	Запрос.УстановитьПараметр("Граница", Граница);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", РаспределениеПоВсемОрганизациям);
	Запрос.УстановитьПараметр("Доходы", Доходы.Выгрузить(,));
	Запрос.УстановитьПараметр("СпособРаспределения",
		Справочники.СпособыРаспределенияПоНаправлениямДеятельности.СпособРаспределенияПоУмолчанию(Неопределено));
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаЗапроса = РезультатЗапроса.Выгрузить();
	
	Доходы.Загрузить(ТаблицаЗапроса);

КонецПроцедуры

Процедура ЗаполнитьРасходыПоОстаткам() Экспорт

	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Расходы.Организация КАК Организация,
	|	Расходы.Подразделение КАК Подразделение,
	|	Расходы.СтатьяРасходов КАК СтатьяРасходов,
	|	Расходы.АналитикаРасходов КАК АналитикаРасходов,
	|	Расходы.СпособРаспределения КАК СпособРаспределения
	|
	|ПОМЕСТИТЬ Расходы
	|ИЗ
	|	&Расходы КАК Расходы
	|ГДЕ
	|	Расходы.СпособРаспределения <> ЗНАЧЕНИЕ(Справочник.СпособыРаспределенияПоНаправлениямДеятельности.ПустаяСсылка)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Расходы.Организация КАК Организация,
	|	Расходы.Подразделение КАК Подразделение,
	|	Расходы.СтатьяРасходов КАК СтатьяРасходов,
	|	Расходы.АналитикаРасходов КАК АналитикаРасходов,
	|	МАКСИМУМ(Расходы.СпособРаспределения) КАК СпособРаспределения
	|
	|ПОМЕСТИТЬ Аналитика
	|ИЗ
	|	Расходы КАК Расходы
	|
	|СГРУППИРОВАТЬ ПО
	|	Расходы.Организация,
	|	Расходы.Подразделение,
	|	Расходы.СтатьяРасходов,
	|	Расходы.АналитикаРасходов
	|;
	|/////////////////////////////////////////////////////////////////////////////
	| ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПрочиеРасходы.Организация КАК Организация,
	|	ПрочиеРасходы.Подразделение КАК Подразделение,
	|	ПрочиеРасходы.СтатьяРасходов КАК СтатьяРасходов,
	|	ПрочиеРасходы.АналитикаРасходов КАК АналитикаРасходов,
	|	ЕСТЬNULL(Аналитика.СпособРаспределения,
	|	(ВЫБОР
	|		КОГДА ПрочиеРасходы.СтатьяРасходов.СпособРаспределенияПоНаправлениямДеятельности
	|			<> ЗНАЧЕНИЕ(Справочник.СпособыРаспределенияПоНаправлениямДеятельности.ПустаяСсылка)
	|		ТОГДА ПрочиеРасходы.СтатьяРасходов.СпособРаспределенияПоНаправлениямДеятельности
	|		ИНАЧЕ &СпособРаспределения КОНЕЦ)) КАК СпособРаспределения,
	|	ПрочиеРасходы.СуммаОстаток КАК Сумма,
    //++ НЕ УТ
    |	ПрочиеРасходы.НалоговоеНазначение КАК НалоговоеНазначение,
	|	ПрочиеРасходы.СуммаРеглОстаток КАК СуммаРегл,
	|	ПрочиеРасходы.СуммаРеглБезНДСОстаток КАК СуммаРеглБезНДС,
	|	ПрочиеРасходы.НДСРеглОстаток КАК НДСРегл,
    //-- НЕ УТ
	|
	|	ВЫБОР КОГДА ПрочиеРасходы.АналитикаРасходов ССЫЛКА Справочник.НаправленияДеятельности ТОГДА
	|		Ложь
	|	ИНАЧЕ
	|		Истина
	|	КОНЕЦ КАК ТребуетсяСпособРаспределения
	|ИЗ
	|	РегистрНакопления.ПрочиеРасходы.Остатки(&Граница, 
	|		(Организация = &Организация
	|			ИЛИ &ПоВсемОрганизациям)
	|		И СтатьяРасходов.ВариантРаспределенияРасходов = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаНаправленияДеятельности)
	|	) КАК ПрочиеРасходы
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Аналитика КАК Аналитика
	|	ПО
	|		ПрочиеРасходы.Организация = Аналитика.Организация
	|		И ПрочиеРасходы.Подразделение = Аналитика.Подразделение
	|		И ПрочиеРасходы.СтатьяРасходов  = Аналитика.СтатьяРасходов
	|		И ПрочиеРасходы.АналитикаРасходов = Аналитика.АналитикаРасходов
	|ГДЕ
	|	ПрочиеРасходы.СуммаОстаток <> 0
    //++ НЕ УТ
	|	ИЛИ ПрочиеРасходы.СуммаРеглОстаток <> 0
	|	ИЛИ ПрочиеРасходы.СуммаРеглБезНДСОстаток <> 0
	|	ИЛИ ПрочиеРасходы.НДСРеглОстаток <> 0
    //-- НЕ УТ
	|	ИЛИ ПрочиеРасходы.СтатьяРасходов = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.ПогрешностьРасчетаСебестоимости)
	|");
	Граница = Новый Граница(КонецМесяца(Дата), ВидГраницы.Включая);
	Запрос.УстановитьПараметр("Граница", Граница);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", РаспределениеПоВсемОрганизациям);
	Запрос.УстановитьПараметр("Расходы", Расходы.Выгрузить(,));
	Запрос.УстановитьПараметр("СпособРаспределения",
		Справочники.СпособыРаспределенияПоНаправлениямДеятельности.СпособРаспределенияПоУмолчанию(Неопределено));
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаЗапроса = РезультатЗапроса.Выгрузить();
	
	Расходы.Загрузить(ТаблицаЗапроса);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Организация = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущаяОрганизация", "");
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ОбновитьПредставлениеОрганизации()

	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеСправочника.Наименование КАК ОрганизацияПредставление
	|ИЗ
	|	Справочник.Организации КАК ДанныеСправочника
	|ГДЕ
	|	ДанныеСправочника.Ссылка В (&МассивОрганизацийДоходы)
	|	ИЛИ ДанныеСправочника.Ссылка В (&МассивОрганизацийРасходы)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОрганизацияПредставление
	|");
	
	МассивОрганизацийДоходы = Доходы.ВыгрузитьКолонку("Организация");
	МассивОрганизацийРасходы = Расходы.ВыгрузитьКолонку("Организация");
	Запрос.УстановитьПараметр("МассивОрганизацийДоходы", МассивОрганизацийДоходы);
	Запрос.УстановитьПараметр("МассивОрганизацийРасходы", МассивОрганизацийРасходы);
	
	ТекстПредставлениеОрганизаций = "";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекстПредставлениеОрганизаций = ТекстПредставлениеОрганизаций
			+ ?(ПустаяСтрока(ТекстПредставлениеОрганизаций), "", ", ")
			+ Выборка.ОрганизацияПредставление;
	КонецЦикла;

	Если ПустаяСтрока(ТекстПредставлениеОрганизаций) Тогда 
		ТекстПредставлениеОрганизаций = НСтр("ru='Укажите организацию';uk='Зазначте організацію'");
	КонецЕсли;

	Если ПредставлениеОрганизаций <> ТекстПредставлениеОрганизаций Тогда
		ПредставлениеОрганизаций = ТекстПредставлениеОрганизаций;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
