////////////////////////////////////////////////////////////////////////////////
// ОУП: Процедуры подсистемы оперативного учета производства
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует системные оповещения о записи маршрутных листов
//
// Параметры:
//  Источник						- УникальныйИдентификатор - идентификатор формы в которой выполнена запись
//									- Строка - идентификатор функции в которой выполнена запись
//  ВызватьОповеститьОбИзменении	- Булево - Истина, если нужно вызвать ОповеститьОбИзменении
//  ИзмененныеДокументы				- Массив, ДокументСсылка.МаршрутныйЛистПроизводства  - список измененных маршрутных листов
//
Процедура ОповеститьОЗаписиМаршрутныхЛистов(Источник = Неопределено, ВызватьОповеститьОбИзменении = Истина, ИзмененныеДокументы = Неопределено) Экспорт

	Оповестить("Запись_МаршрутныйЛистПроизводства", ИзмененныеДокументы, Источник);
	
	Если ВызватьОповеститьОбИзменении Тогда
		ОповеститьОбИзменении(Тип("ДокументСсылка.МаршрутныйЛистПроизводства"));
	КонецЕсли; 
	
КонецПроцедуры

// Формирует системное оповещение об изменении расписания рабочих центров
//
// Параметры:
//  ВидРабочегоЦентра	- СправочникСсылка.ВидыРабочихЦентров - вид рабочего центра для которого изменилось расписание
//  Подразделение		- СправочникСсылка.СтруктураПредприятия - подразделение для которого изменилось расписание
//  ДатаИнтервала		- Дата - дата интервала планирования в котором изменилось расписание
//  Форма				- Форма - форма в которой было изменено расписание
//
Процедура ОповеститьОбИзмененииРасписанияВидаРабочегоЦентра(ВидРабочегоЦентра, Подразделение, ДатаИнтервала, Форма) Экспорт

	ПараметрыСобытия = Новый Структура("ВидРабочегоЦентра,Подразделение,ДатаИнтервала", 
								ВидРабочегоЦентра, Подразделение, ДатаИнтервала);
								
	Оповестить("РасписаниеРабочихЦентров_Изменение", ПараметрыСобытия, Форма);
	
КонецПроцедуры

// Формирует системное оповещение об изменении ключевого вида рабочего центра
//
Процедура ОповеститьОбИзмененииКлючевогоВидаРабочегоЦентра() Экспорт

	Оповестить("КлючевыеВидыРабочихЦентров_Изменение");
	
КонецПроцедуры

// Определяет, что указанное событие - это событие об изменении расписания
//
// Параметры:
//  ИмяСобытия	- Строка - имя события
//
// Возвращаемое значение:
//  Булево   - Истина, если расписание изменилось
//
Функция СобытиеРасписаниеВидаРабочегоЦентраИзменилось(ИмяСобытия) Экспорт

	Возврат (ИмяСобытия = "РасписаниеРабочихЦентров_Изменение");

КонецФункции

// Определяет, что указанное событие - это событие об изменении расписания операций
//
// Параметры:
//  ИмяСобытия	- Строка - имя события
//
// Возвращаемое значение:
//  Булево   - Истина, если расписание изменилось
//
Функция СобытиеРасписаниеОперацийИзменилось(ИмяСобытия) Экспорт

	Возврат (ИмяСобытия = "РасписаниеОперацийРабочихЦентров_Изменение");

КонецФункции

// Определяет, что указанное событие - это событие об изменении ключевого вида рабочего центра
//
// Параметры:
//  ИмяСобытия	- Строка - имя события
//
// Возвращаемое значение:
//  Булево   - Истина, если ключевой вид рабочего центра изменился
//
Функция СобытиеКлючевойВидРабочегоЦентраИзменился(ИмяСобытия) Экспорт

	Возврат (ИмяСобытия = "КлючевыеВидыРабочихЦентров_Изменение");

КонецФункции

// Увеличивает или уменьшает количество согласно кратности
//
// Параметры:
//  Количество				- Число - количество которое нужно изменить
//  Кратность				- Число - какому значению должно быть кратно количество
//  Направление 			- Число - "1" если нужно увеличить, "-1" если нужно уменьшить
//  МинимальноеЗначение		- Число - Минимальное значение
//  МаксимальноеЗначение	- Число - Максимальное значение
//
// Возвращаемое значение:
//   Число   - полученное количество
//
Функция РегулированиеКоличества(Количество, Кратность, Направление, МинимальноеЗначение = Неопределено, МаксимальноеЗначение = Неопределено) Экспорт
	
 	НовоеКоличество = Цел(Количество / Кратность) * Кратность + Кратность * Направление;
	
	Если НовоеКоличество < МинимальноеЗначение 
		ИЛИ НовоеКоличество > МаксимальноеЗначение Тогда
		НовоеКоличество = Количество + Направление;
	КонецЕсли;
	
	Если МинимальноеЗначение <> Неопределено И НовоеКоличество < МинимальноеЗначение 
		ИЛИ МаксимальноеЗначение <> Неопределено И НовоеКоличество > МаксимальноеЗначение Тогда
		
		Возврат Количество;
	КонецЕсли;
	
	Возврат НовоеКоличество;

КонецФункции

// Формирует маршрутные листы по заказам на производство
//
// Параметры:
//  СписокРаспоряжений	- Массив - заказы на производство для которого требуется сформировать МЛ
//  Источник			- УникальныйИдентификатор - идентификатор формы в которой выполняется формирование МЛ
//						- Строка - идентификатор функции в которой выполняется формирование МЛ
//
Процедура СформироватьМаршрутныеЛистыПоЗаказам(СписокРаспоряжений, Источник = Неопределено) Экспорт
	
	Результат = ОперативныйУчетПроизводстваВызовСервера.СформироватьМаршрутныеЛистыПоЗаказам(СписокРаспоряжений);
	Если Результат.Выполнено Тогда
		ОповеститьПользователяОФормированииМаршрутныхЛистов(
				Результат.КоличествоОбработанных, 
				Результат.КоличествоВсего,
				Источник);
	Иначе
		ПоказатьПредупреждение(,Результат.ТекстПредупреждения); 
	КонецЕсли; 
	
КонецПроцедуры

// Формирует маршрутные листы необходимые для формирования расписания на указанном виде РЦ
//
// Параметры:
//  Подразделение		- СправочникСсылка.СтруктураПредприятия - подразделение для которого требуется сформировать МЛ
//  ВидРабочегоЦентра	- СправочникСсылка.ВидыРабочихЦентров - вид рабочего центра для которого формируется расписание
//	ДатаИнтервала		- Дата - начало интервала планирования
//  Источник			- УникальныйИдентификатор - идентификатор формы в которой выполняется формирование МЛ
//						- Строка - идентификатор функции в которой выполняется формирование МЛ
//
Процедура СформироватьМаршрутныеЛистыПоРасписанию(Подразделение, ВидРабочегоЦентра, ДатаИнтервала, Источник = Неопределено) Экспорт

	ДанныеМаршрутныхЛистов = ОперативныйУчетПроизводстваВызовСервера.ДанныеДляФормированияМаршрутныхЛистовПоРасписанию(
										Подразделение, 
										ВидРабочегоЦентра, 
										ДатаИнтервала);
									
	Если ДанныеМаршрутныхЛистов.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Формировать маршрутные листы не требуется.';uk='Формувати маршрутні листи не потрібно.'"));
		Возврат;
	КонецЕсли;
	
	КоличествоОбработанных = ОперативныйУчетПроизводстваВызовСервера.СформироватьМаршрутныеЛисты(ДанныеМаршрутныхЛистов);
	ОповеститьПользователяОФормированииМаршрутныхЛистов(КоличествоОбработанных, ДанныеМаршрутныхЛистов.Количество(), Источник);
	
КонецПроцедуры

// Оформляет документ выработки сотрудников на основании распоряжений
//
// Параметры:
//  СписокРаспоряжений	- Массив - список распоряжений
//  ВидНаряда	- ПеречислениеСсылка.ВидыБригадныхНарядов - характер выполненных работ
//
Процедура ОформитьВыработкуСотрудниковПоРаспоряжениям(СписокРаспоряжений, ВидНаряда) Экспорт

	ТекстПредупреждения = Неопределено;
	
	ПараметрыОформления = ОперативныйУчетПроизводстваВызовСервера.ПараметрыОформленияВыработкиСотрудников(
									СписокРаспоряжений,
									ТекстПредупреждения);
									
	Если ПараметрыОформления <> Неопределено Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СписокРаспоряжений", СписокРаспоряжений);
		ПараметрыФормы.Вставить("ВидНаряда", ВидНаряда);
		ПараметрыФормы.Вставить("Организация", ПараметрыОформления.Организация);
		ПараметрыФормы.Вставить("Подразделение", ПараметрыОформления.Подразделение);
		ОткрытьФорму("Документ.ВыработкаСотрудников.Форма.ФормаВыбораБригады", ПараметрыФормы);
		
	ИначеЕсли ТекстПредупреждения <> Неопределено Тогда
		
		ПоказатьПредупреждение(,ТекстПредупреждения);
		
	КонецЕсли; 
	
КонецПроцедуры

#Область ПооперационноеПланирование

// Определяет имя события, которое используется для оповещения об изменении пооперационного расписания.
//
// Возвращаемое значение:
//  Строка - имя события.
//
Функция ИмяСобытияИзменениеПооперационногоРасписания() Экспорт
	
	Возврат "РасчетПооперационногоРасписанияПроизводства";
	
КонецФункции

// Определяет имя события, которое используется для оповещения об изменении статуса выполнения операций расписания.
//
// Возвращаемое значение:
//  Строка - имя события.
//
Функция ИмяСобытияИзменениеСтатусаОпераций() Экспорт
	
	Возврат "ИзменениеСтатусаОперацийРасписанияПроизводства";
	
КонецФункции

// Открывает форму для формирования сменно-суточных заданий.
//
// Параметры:
//  Владелец - УправляемаяФорма или элемент управляемой формы - владелец открываемой формы.
//  ПараметрыФормы - Структура - параметры открытия формы.
//
Процедура ОткрытьФормуДляПечатиСменноСуточныхЗаданий(Знач Владелец, Знач ПараметрыФормы) Экспорт
	
	ОткрытьФорму("Обработка.ДиспетчированиеПроизводстваПооперационное.Форма.ПечатьСменноСуточныхЗаданий", 
						ПараметрыФормы, Владелец,,,,,
						РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Выполняет обработку расшифровки интервала диаграммы Ганта, содержащего данные о параллельной
// загрузке рабочего центра.
//
// Параметры:
//  Владелец 			 - Управляемая форма - форма, в которой выполнена расшифровка.
//  ПараметрыФормы		 - Структура - параметры выбранного интервала.
//  СтандартнаяОбработка - Булево - флаг стандартной обработки расшифровки.
//
Процедура ОбработкаРасшифровкиИнтервалаСПараллельнойЗагрузкой(Знач Владелец, Знач ПараметрыФормы, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму(
		"Отчет.ДиаграммаПооперационногоРасписания.Форма.РасшифровкаПараллельнойЗагрузки",
		ПараметрыФормы,
		Владелец,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Открывает форму для диспетчирования маршрутных листов, принадлежащих подразделениям с
//	методиками управления "Пооперационное планирование" и "Регистрация операций".
//
// Параметры:
//  МетодикаУправления - ПеречислениеСсылка.УправлениеМаршрутнымиЛистами - методика, в соответствии с которой
//		должна быть настроена форма диспетчирования.
//  Подразделение - СправочникСсылка.СтруктураПредприятия - подразделение, по которому необходимо установить отбор.
//	СписокЭтапов - Массив - cодержит данные этапов производства для установки отбора.
//		Элементами являются структуры со свойствами:
//		* Распоряжение - ДокументСсылка.ЗаказНаПроизводство;
//		* КодСтрокиЭтапыГрафик - Число.
//
Процедура ОткрытьФормуДиспетчированиеПооперационное(МетодикаУправления, Подразделение = Неопределено, СписокЭтапов = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УправлениеМаршрутнымиЛистами", МетодикаУправления);
	Если ЗначениеЗаполнено(Подразделение) Тогда
		ПараметрыФормы.Вставить("Подразделение", Подразделение);
	КонецЕсли;
	Если ЗначениеЗаполнено(СписокЭтапов) Тогда
		ПараметрыФормы.Вставить("СписокЭтапов", СписокЭтапов);
	КонецЕсли;
	
	ОткрытьФорму(
		"Обработка.ДиспетчированиеПроизводстваПооперационное.Форма",
		ПараметрыФормы,,
		МетодикаУправления);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Оповещает пользователя о завершении процесса создания маршрутных листов.
//
// Параметры:
//  КоличествоОбработанных	 - Число - количество созданных документов.
//  КоличествоВсего			 - Число - количество документов, которые могут быть созданы.
//  Источник				 - УникальныйИдентификатор - идентификатор формы, инициировавшей создание документов.
//
Процедура ОповеститьПользователяОФормированииМаршрутныхЛистов(КоличествоОбработанных, КоличествоВсего, Источник = Неопределено) Экспорт
	
	Если КоличествоОбработанных > 0 Тогда
		
		ТекстСообщения = НСтр("ru='Сформировано %КоличествоОбработанных% из %КоличествоВсего% документов';uk='Сформовано %КоличествоОбработанных% з %КоличествоВсего% документів'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоОбработанных%", КоличествоОбработанных);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоВсего%",        КоличествоВсего);
		ТекстЗаголовка = НСтр("ru='Маршрутные листы сформированы';uk='Маршрутні листи сформовані'");
		ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
		
		ОперативныйУчетПроизводстваКлиент.ОповеститьОЗаписиМаршрутныхЛистов(Источник);
		
	Иначе
		
		ТекстСообщения = НСтр("ru='Не сформирован ни один документ';uk='Не сформовано жодний документ'");
		ТекстЗаголовка = НСтр("ru='Маршрутные листы не сформированы';uk='Маршрутні листи не сформовані'");
		ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
