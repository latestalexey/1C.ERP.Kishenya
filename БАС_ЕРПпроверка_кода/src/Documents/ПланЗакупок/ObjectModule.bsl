#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура заполняет табличную часть документа по правилу заполнения из различных источников
//
Процедура ЗаполнитьПоПравилуЗаполнения() Экспорт 
	
	Параметры = Новый Структура("Ссылка, Сценарий, КроссТаблица, ИзменитьРезультатНа, ЗаполненоАвтоматически, ТочностьОкругления, 
		|Подразделение, Склад, Партнер, Соглашение, Статус, Периодичность, НачалоПериода, ОкончаниеПериода");
	
	ЗаполнитьЗначенияСвойств(Параметры, ЭтотОбъект);
	
	Параметры.Вставить("ЗаполнятьПоПравилу", Истина);
	Параметры.Вставить("ПравилоЗаполнения", ПравилоЗаполнения.Выгрузить());
	Параметры.Вставить("ПользовательскиеНастройки", ПользовательскиеНастройки.Получить());
	
	ЗаполняемаяТЧ = Товары.Выгрузить();
	Если ОбновитьДополнить = 0 Тогда
		ЗаполняемаяТЧ.Очистить();
	КонецЕсли;
	
	Параметры.Вставить("ЗаполняемаяТЧ", ЗаполняемаяТЧ);
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено);
	Документы.ПланЗакупок.ЗаполнитьПоПравилуЗаполнения(Параметры, АдресХранилища);
	
	ЗаполняемаяТЧ = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Товары.Загрузить(ЗаполняемаяТЧ);
	
	ЗаполненоАвтоматически = Истина;
	
КонецПроцедуры

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	ЗначениеНовогоСтатуса = Перечисления.СтатусыПланов[НовыйСтатус];
	
	Статус = ЗначениеНовогоСтатуса;
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Ответственный = Пользователи.ТекущийПользователь();
	ЗаполнитьДанныеПоУмолчанию();
	
	РеквизитыСценария = "Периодичность, Валюта, ПланЗакупокПланироватьПоСумме";
	//++ НЕ УТ
	РеквизитыСценария = РеквизитыСценария + ", СценарийБюджетирования";
	//-- НЕ УТ
	ПараметрыСценария = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Сценарий, РеквизитыСценария);
	Если НЕ ЗначениеЗаполнено(ВидПлана) Тогда
		ВидПлана = Планирование.ПолучитьВидПланаПоУмолчанию(Перечисления.ТипыПланов.ПланЗакупок, Сценарий);
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыСценария);
	
	//++ НЕ УТ
	Если ЗначениеЗаполнено(ВидПлана) Тогда
		РеквизитыВидаПлана = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидПлана, "ОтражаетсяВБюджетировании, СтатьяБюджетов");
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыВидаПлана);
	КонецЕсли;
	//-- НЕ УТ
	
	ПланироватьПоСумме = ПараметрыСценария.ПланЗакупокПланироватьПоСумме;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		
		Возврат;

	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	СуммаДокумента = 0;
	
	Для каждого СтрокаТЧ Из Товары Цикл
		Если ПланироватьПоСумме Тогда
			
			Если НЕ СтрокаТЧ.Отменено Тогда
			
				СуммаДокумента = СуммаДокумента + СтрокаТЧ.Сумма;
			
			КонецЕсли; 
			
		Иначе
			
			СтрокаТЧ.Цена = 0;
			СтрокаТЧ.Сумма = 0;
			
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(Партнер) Тогда
			СтрокаТЧ.Партнер = Партнер;
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(Соглашение) Тогда
			СтрокаТЧ.Соглашение = Соглашение;
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(Склад) Тогда
			СтрокаТЧ.Склад = Склад;
		КонецЕсли; 
		
	КонецЦикла;
	
	Если НЕ ПланироватьПоСумме Тогда
		ЗаполнятьПланОплат = Ложь;
	КонецЕсли;
	Если НЕ ЗаполнятьПланОплат Тогда
		
		ПланОплаты.Очистить();
		
	КонецЕсли;  
	
	//++ НЕ УТ
	Если НЕ ОтражаетсяВБюджетировании Тогда
		СтатьяБюджетов = Неопределено;
	КонецЕсли;
	
	Если НЕ ОтражаетсяВБюджетированииОплаты Тогда
		СтатьяБюджетовОплат = Неопределено;
	КонецЕсли;
	
	Если НЕ ОтражаетсяВБюджетированииОплатыКредит Тогда
		СтатьяБюджетовОплатКредит = Неопределено;
	КонецЕсли;
	
	Если НЕ ОтражаетсяВБюджетировании И НЕ ОтражаетсяВБюджетированииОплаты Тогда
		СценарийБюджетирования = Неопределено;
	КонецЕсли;
	//-- НЕ УТ
	
	ПроведениеСервер.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Статус = Метаданные().Реквизиты.Статус.ЗначениеЗаполнения;
	
	Для каждого СтрокаТовары из Товары Цикл

		СтрокаТовары.Отменено = Ложь;

	КонецЦикла;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.ПланЗакупок.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	Планирование.ОтразитьПланЗакупок(ДополнительныеСвойства, Движения, Отказ);
	
	Планирование.ОтразитьПланыОплатПоставщикам(ДополнительныеСвойства, Движения, Отказ);
	//++ НЕ УТ
	РегистрыНакопления.ОборотыБюджетов.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	//-- НЕ УТ
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст =  
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Товары.ДатаПоступления КАК Период,
		|	&Подразделение         КАК Подразделение,
		|	&Сценарий              КАК Сценарий,
		|	Товары.Номенклатура    КАК Номенклатура,
		|	Товары.Характеристика  КАК Характеристика,
		|	Товары.Партнер         КАК Партнер,
		|	Товары.Соглашение      КАК Соглашение,
		|	Товары.Склад           КАК Склад
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	&Товары КАК Товары
		|ГДЕ
		|	Товары.КоличествоУпаковок <> 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДвиженияДокумента.Период         КАК Период,
		|	ДвиженияДокумента.Подразделение  КАК Подразделение,
		|	ДвиженияДокумента.Сценарий       КАК Сценарий,
		|	ДвиженияДокумента.Номенклатура   КАК Номенклатура,
		|	ДвиженияДокумента.Характеристика КАК Характеристика,
		|	ВЫБОР
		|		КОГДА ДвиженияДокумента.Партнер = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ                            КАК УказаниеПартнера,
		|	ВЫБОР
		|		КОГДА ДвиженияДокумента.Соглашение = ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ                            КАК УказаниеСоглашения,
		|	ВЫБОР
		|		КОГДА ДвиженияДокумента.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ                            КАК УказаниеСклада
		|ПОМЕСТИТЬ ДвиженияДокумента
		|ИЗ
		|	Товары КАК ДвиженияДокумента
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДвиженияДокумента.Период,
		|	ДвиженияДокумента.Подразделение,
		|	ДвиженияДокумента.Сценарий,
		|	ДвиженияДокумента.Номенклатура,
		|	ДвиженияДокумента.Характеристика,
		|	ВЫБОР
		|		КОГДА ПланыЗакупок.Партнер = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ПланыЗакупок.Соглашение = ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА ПланыЗакупок.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ
		|ИЗ
		|	Товары КАК ДвиженияДокумента
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ПланыЗакупок КАК ПланыЗакупок
		|		ПО ДвиженияДокумента.Период = ПланыЗакупок.Период
		|			И ДвиженияДокумента.Номенклатура = ПланыЗакупок.Номенклатура
		|			И ДвиженияДокумента.Характеристика = ПланыЗакупок.Характеристика
		|			И ДвиженияДокумента.Подразделение = ПланыЗакупок.Подразделение
		|			И ДвиженияДокумента.Сценарий = ПланыЗакупок.Сценарий
		|ГДЕ
		|	ПланыЗакупок.Регистратор <> &Ссылка
		|	И ПланыЗакупок.Количество <> 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияДокумента.Период                                   КАК Период,
		|	ДвиженияДокумента.Подразделение                            КАК Подразделение,
		|	ДвиженияДокумента.Сценарий                                 КАК Сценарий,
		|	ДвиженияДокумента.Номенклатура                             КАК Номенклатура,
		|	ДвиженияДокумента.Характеристика                           КАК Характеристика,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДвиженияДокумента.УказаниеПартнера)   КАК УказаниеПартнера,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДвиженияДокумента.УказаниеСоглашения) КАК УказаниеСоглашения,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДвиженияДокумента.УказаниеСклада)     КАК УказаниеСклада
		|ИЗ
		|	ДвиженияДокумента КАК ДвиженияДокумента
		|
		|СГРУППИРОВАТЬ ПО
		|	ДвиженияДокумента.Период,
		|	ДвиженияДокумента.Подразделение,
		|	ДвиженияДокумента.Сценарий,
		|	ДвиженияДокумента.Номенклатура,
		|	ДвиженияДокумента.Характеристика
		|
		|ИМЕЮЩИЕ
		|	(КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДвиженияДокумента.УказаниеПартнера) > 1
		|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДвиженияДокумента.УказаниеСоглашения) > 1
		|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДвиженияДокумента.УказаниеСклада) > 1)";

	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Сценарий", Сценарий);
	Запрос.УстановитьПараметр("Товары", Товары.Выгрузить(, "ДатаПоступления, Номенклатура, Характеристика, Партнер, 
		|Соглашение, Склад, КоличествоУпаковок"));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	ШаблонСообщения1 = НСтр("ru='Для номенклатуры %НоменклатураХарактеристика% 
        |нельзя одновременно использовать в одном периоде и подразделении планы с пустым и планы с заполненным значением поля:'
        |;uk='Для номенклатури %НоменклатураХарактеристика% 
        |не можна одночасно використовувати в одному періоді і підрозділі плани з порожнім і плани з заповненим полем:'") + " ";
	ШаблонСообщения2 = НСтр("ru='%Поле%';uk='%Поле%'");
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл

		ТекстСообщения = СтрЗаменить(ШаблонСообщения1, "%НоменклатураХарактеристика%",
						НоменклатураКлиентСервер.ПредставлениеНоменклатуры(Выборка.Номенклатура, Выборка.Характеристика));
		Если Выборка.УказаниеПартнера > 1 Тогда
			ТекстСообщения = ТекстСообщения + СтрЗаменить(ШаблонСообщения2, "%Поле%",  "Поставщик");
		КонецЕсли; 
		Если Выборка.УказаниеСоглашения > 1 Тогда
			ТекстСообщения = ТекстСообщения + СтрЗаменить(ШаблонСообщения2, "%Поле%", ?(Выборка.УказаниеПартнера>1,", ","")+"Соглашение");
		КонецЕсли; 
		Если Выборка.УказаниеСоглашения > 1 Тогда
			ТекстСообщения = ТекстСообщения + СтрЗаменить(ШаблонСообщения2, "%Поле%",  ?(Выборка.УказаниеПартнера>1 ИЛИ Выборка.УказаниеСоглашения>1,", ","")+"Склад");
		КонецЕсли; 
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, ,, Отказ);

	КонецЦикла;

	Если КроссТаблица Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоУпаковок");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	Иначе
	    ПараметрыПроверки = ОбщегоНазначенияУТ.ПараметрыПроверкиЗаполненияКоличества();
		ПараметрыПроверки.ПроверитьВозможностьОкругления = Ложь;
	    ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	КонецЕсли; 
	
	ПараметрыПроверки = Новый Структура;
	ПараметрыПроверки.Вставить("ИмяТЧ",                    "Товары");
	ПараметрыПроверки.Вставить("ПредставлениеТЧ",          НСтр("ru='Товары';uk='Товари'"));
	ПараметрыПроверки.Вставить("Периодичность",            Периодичность);
	ПараметрыПроверки.Вставить("ДатаНачала",               НачалоПериода);
	ПараметрыПроверки.Вставить("ДатаОкончания",            ОкончаниеПериода);
	ПараметрыПроверки.Вставить("ИмяПоляДатыПериода",       "ДатаПоступления");
	ПараметрыПроверки.Вставить("ПредставлениеДатыПериода", НСтр("ru='Дата поступления';uk='Дата надходження'"));
	
	ПланированиеКлиентСервер.ПроверитьДатуПериодаТЧ(ЭтотОбъект, Отказ, ПараметрыПроверки);
	
	Если КроссТаблица Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Характеристика");
	Иначе
		НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	КонецЕсли; 
	
	Планирование.ОбработкаПроверкиЗаполненияПоСценариюВидуПлана(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	Если ЗаполнятьПланОплат Тогда
		
		Если СуммаДокумента > 0 И ПланОплаты.Количество() = 0 Тогда
		
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Необходимо заполнить план оплаты.';uk='Необхідно заповнити план оплати.'"),
				ЭтотОбъект,
				"ПланОплаты",
				, 
				Отказ);
			
		ИначеЕсли СуммаДокумента <> ПланОплаты.Итог("СуммаПлатежа") Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Сумма отгрузок по документу не совпадает с суммой оплат. Необходимо обновить план оплаты.';uk='Сума відвантажень по документу не збігається з сумою оплат. Необхідно оновити план оплати.'"),
				ЭтотОбъект,
				"ПланОплаты",
				, 
				Отказ);
				
		КонецЕсли; 
		
	КонецЕсли;
	
	//++ НЕ УТ
	ПроверятьЗаполнениеПрогнозныхКурсовВалют = Ложь;
	ВалютыПроверкиКурсов = Новый Массив;
	
	Если Не ОтражаетсяВБюджетировании Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяБюджетов");
	КонецЕсли;
	
	Если Не ОтражаетсяВБюджетированииОплаты Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяБюджетовОплат");
	КонецЕсли;
	
	Если Не ОтражаетсяВБюджетированииОплатыКредит Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяБюджетовОплатКредит");
	КонецЕсли;
	
	Если Не ОтражаетсяВБюджетировании И Не ОтражаетсяВБюджетированииОплаты Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СценарийБюджетирования");
	КонецЕсли;
	
	Если ОтражаетсяВБюджетировании ИЛИ ОтражаетсяВБюджетированииОплаты Тогда
		
		Если ЗначениеЗаполнено(СценарийБюджетирования) Тогда
			ПроверятьЗаполнениеПрогнозныхКурсовВалют = 
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СценарийБюджетирования, "ТребоватьУказанияКурсовДляКаждогоПериода");
		КонецЕсли;
		
		ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
		ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
		
		ВалютыПроверкиКурсов = Новый Массив;
		Если Валюта <> ВалютаРегламентированногоУчета Тогда
			ВалютыПроверкиКурсов.Добавить(Валюта);
		КонецЕсли;
		Если ВалютаУправленческогоУчета <> ВалютаРегламентированногоУчета Тогда
			ВалютыПроверкиКурсов.Добавить(ВалютаУправленческогоУчета);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПроверятьЗаполнениеПрогнозныхКурсовВалют И ВалютыПроверкиКурсов.Количество() <> 0 Тогда
		
		ТаблицаКурсов = Справочники.Сценарии.ТаблицаКурсовСценария(
			СценарийБюджетирования, ВалютыПроверкиКурсов, НачалоПериода, ОкончаниеПериода);
		
		Периоды = БюджетнаяОтчетностьВыводСервер.ПолучитьМассивПериодов(НачалоПериода, ОкончаниеПериода, Периодичность);
		НеНайденныеКурсы = ТаблицаКурсов.СкопироватьКолонки("Период, Валюта");
		
		Для Каждого Период из Периоды Цикл
			Для Каждого ВалютаКурсов из ВалютыПроверкиКурсов Цикл
				СтруктураПоиска = Новый Структура("Валюта, Период", ВалютаКурсов, Период);
				Если Не ТаблицаКурсов.НайтиСтроки(СтруктураПоиска).Количество() Тогда
					НоваяСтрока = НеНайденныеКурсы.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураПоиска);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Если НеНайденныеКурсы.Количество() <> 0 Тогда
			НеНайденныеКурсы.Свернуть("Валюта");
			МассивВалют = НеНайденныеКурсы.ВыгрузитьКолонку("Валюта");
			ТекстСообщения = 
				НСтр("ru='План закупок отражается в бюджетировании. 
                |Необходимо задать прогнозные курсы валют %1 в сценарии бюджетирования ""%2"" для каждого периода плана.'
                |;uk='План купівель відображається в бюджетуванні. 
                |Необхідно визначити прогнозні курси валют %1 в сценарії бюджетування ""%2"" для кожного періоду плану.'");
			ТекстСообщения = 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ТекстСообщения, 
					СтрСоединить(МассивВалют, ", "), 
					СценарийБюджетирования);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Сценарий", , Отказ);
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ УТ
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет подразделение, сценарий, вид плана и признак кросс-таблицы в документе, значением по умолчанию.
//
Процедура ЗаполнитьДанныеПоУмолчанию()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ДанныеДокумента.Сценарий КАК Сценарий,
	|	ДанныеДокумента.ВидПлана КАК ВидПлана,
	|	ДанныеДокумента.ЗаполнятьПоФормуле КАК ЗаполнятьПоФормуле,
	|	ДанныеДокумента.КроссТаблица КАК КроссТаблица,
	|	ЕСТЬNULL(ВидыПланов.ЗаполнятьПланОплат, ЛОЖЬ) КАК ЗаполнятьПланОплат
	|ИЗ
	|	Документ.ПланЗакупок КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыПланов КАК ВидыПланов
	|		ПО ДанныеДокумента.ВидПлана = ВидыПланов.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ответственный = &Ответственный
	|	И ДанныеДокумента.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеДокумента.Дата УБЫВ");
	
	Запрос.УстановитьПараметр("Ответственный", Ответственный);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		
	КонецЕсли;
	
	Сценарий = ЗначениеНастроекПовтИсп.ПолучитьСценарийПоУмолчанию(Перечисления.ТипыПланов.ПланЗакупок, Сценарий);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
