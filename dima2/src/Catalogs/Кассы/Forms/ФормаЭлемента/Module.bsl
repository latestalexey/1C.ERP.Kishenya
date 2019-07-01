
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ИспользоватьНесколькоВалют = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	
	Если ИспользоватьНесколькоВалют Тогда
		// подсистема запрета редактирования ключевых реквизитов объектов	
		ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	КонецЕсли; 
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		НеИспользоватьЗаявкиНаРасходованиеДенежныхСредств = ПолучитьФункциональнуюОпцию("НеИспользоватьЗаявкиНаРасходованиеДенежныхСредств");
		
	КонецЕсли;
	
	ОпределитьРазрешениеПлатежейБезУказанияРаспоряжений();
	
	ПризнакКассовойКнигиОбособленногоПодразделения = ?(Объект.ПоОбособленномуПодразделению, 1, 0);
	
	УправлениеЭлементамиФормы();
	
	СформироватьАвтоНаименование();
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	//++ НЕ УТ
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ИнициализироватьСчетаУчета();
	УстановитьПараметрыВыбораСчетаУчета();
	//-- НЕ УТ

	// Обработчик механизма "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда
		
		Объект.ПолучателиПлатежейПриПеремещенииДС.Очистить();
		Для Каждого ПолучательПлатежа Из ВыбранноеЗначение Цикл
			Если ПолучательПлатежа.Значение.Пустая() Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаПолучательПлатежа = Объект.ПолучателиПлатежейПриПеремещенииДС.Добавить();
			СтрокаПолучательПлатежа.ПолучательПлатежа = ПолучательПлатежа.Значение;
		КонецЦикла;
		
		УправлениеЭлементамиФормы();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	НеИспользоватьЗаявкиНаРасходованиеДенежныхСредств = ПолучитьФункциональнуюОпцию("НеИспользоватьЗаявкиНаРасходованиеДенежныхСредств");
	
	ОпределитьРазрешениеПлатежейБезУказанияРаспоряжений();
	
	СформироватьАвтоНаименование();
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = СформироватьАвтоНаименование();
	КонецЕсли;
	
	Если НЕ (РазрешитьПлатежиБезУказанияРаспоряжений ИЛИ НеИспользоватьЗаявкиНаРасходованиеДенежныхСредств) Тогда
		Объект.ПолучателиПлатежейПриПеремещенииДС.Очистить();
	ИначеЕсли Объект.ПолучателиПлатежейПриПеремещенииДС.Количество() = 0 И НЕ НеИспользоватьЗаявкиНаРасходованиеДенежныхСредств Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не заполнен список касс-получателей для передачи денежных средств без ""распоряжений на перемещение"".';uk='Не заповнений список кас-одержувачів для передачі грошових коштів без ""розпоряджень на переміщення"".'"),
			,
			"СписокКассПолучателейСтрокой",
			,
			Отказ);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ИспользоватьНесколькоВалют Тогда
		// подсистема запрета редактирования ключевых реквизитов объектов	
		ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	КонецЕсли; 

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_Кассы", ПараметрыЗаписи, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик механизма "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Обработчик механизма "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	Объект.ПолучателиПлатежейПриПеремещенииДС.Очистить();
	ОпределитьРазрешениеПлатежейБезУказанияРаспоряжений();
	ПроверитьУправленческаяОрганизация();
	СформироватьАвтоНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаДенежныхСредствПриИзменении(Элемент)
	
	ВалютаДенежныхСредствПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	СформироватьАвтоНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ПризнакКассовойКнигиОбособленногоПодразделенияПриИзменении(Элемент)
	
	
	ПризнакКассовойКнигиОбособленногоПодразделенияПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПризнакКассовойКнигиОбособленногоПодразделенияПриИзмененииСервер()
	
	Объект.ПоОбособленномуПодразделению = (ПризнакКассовойКнигиОбособленногоПодразделения = 1);
	Если Не Объект.ПоОбособленномуПодразделению Тогда
		Объект.ОбособленноеПодразделениеОрганизации = Справочники.ОбособленныеПодразделенияОрганизаций.ПустаяСсылка();
	КонецЕсли;
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьПлатежиБезУказанияРаспоряженийПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы();

КонецПроцедуры

&НаКлиенте
Процедура СписокКассПолучателейНажатие(Кнопка)
	
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Владелец) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Поле ""Организация"" не заполнено';uk='Поле ""Організація"" не заповнене'"),
			,
			"Владелец",
			"Объект",
			Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ВалютаДенежныхСредств) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Поле ""Валюта"" не заполнено';uk='Поле ""Валюта"" не заповнено'"),
			,
			"ВалютаДенежныхСредств",
			"Объект",
			Отказ);
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Касса", Объект.Ссылка);
		ПараметрыФормы.Вставить("Владелец", Объект.Владелец);
		ПараметрыФормы.Вставить("ВалютаДенежныхСредств", Объект.ВалютаДенежныхСредств);
		ПараметрыФормы.Вставить("СписокПолучателейПлатежей", Новый СписокЗначений);
		Для Каждого СтрокаПолучательПлатежа Из Объект.ПолучателиПлатежейПриПеремещенииДС Цикл
			ПараметрыФормы.СписокПолучателейПлатежей.Добавить(СтрокаПолучательПлатежа.ПолучательПлатежа)
		КонецЦикла;
		
		ОткрытьФорму("Справочник.Кассы.Форма.ФормаПолучателиПлатежейПриПеремещенииДС",
			ПараметрыФормы,
			ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВКассовойКнигеПриИзменении(Элемент)
	
	Если НЕ Объект.ИспользоватьВКассовойКниге И Объект.ПоОбособленномуПодразделению Тогда
		Объект.ПоОбособленномуПодразделению = Ложь;
		ПризнакКассовойКнигиОбособленногоПодразделения = 0;
	КонецЕсли; 
	УправлениеЭлементамиФормы();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если ИспользоватьНесколькоВалют И (Не Объект.Ссылка.Пустая()) Тогда
		ОткрытьФорму("Справочник.Кассы.Форма.РазблокированиеРеквизитов",,,,,, 
			Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
        ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
    КонецЕсли;

КонецПроцедуры

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

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств(Команда)
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	ИспользоватьНесколькоКасс = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	
	Если НЕ ИспользоватьНесколькоКасс Тогда
		
		Элементы.РазрешитьПлатежиБезУказанияРаспоряжений.Видимость			= Ложь;
		Элементы.ДекорацияРазрешитьПлатежиБезУказанияРаспоряжений.Видимость	= Ложь;
		Элементы.ГруппаСписокКассПолучателей.Видимость						= Ложь;
		
	Иначе
		
		Если РазрешитьПлатежиБезУказанияРаспоряжений ИЛИ НеИспользоватьЗаявкиНаРасходованиеДенежныхСредств Тогда
			СписокКассПолучателейСтрокой = ПолучитьСписокКассПолучателей();
			Элементы.РедактироватьСписокКассПолучателей.Заголовок = СписокКассПолучателейСтрокой;
			Элементы.ГруппаСписокКассПолучателей.Видимость = Истина;
		Иначе
			Элементы.ГруппаСписокКассПолучателей.Видимость = Ложь;
		КонецЕсли;
		
		Элементы.ДекорацияРазрешитьПлатежиБезУказанияРаспоряжений.Видимость = НеИспользоватьЗаявкиНаРасходованиеДенежныхСредств;
		
	КонецЕсли;
	
	ИспользоватьОбособленноеПодразделениеОрганизации = ПолучитьФункциональнуюОпцию("ИспользоватьУчетДенежныхСредствПоОбособленнымПодразделениямОрганизация", Новый Структура("Организация", Объект.Владелец));
	
	Элементы.ГруппаОбособленноеПодразделениеОрганизации.Видимость =  ИспользоватьОбособленноеПодразделениеОрганизации;
	
	Элементы.ОбособленноеПодразделениеОрганизации.Видимость   = Объект.ПоОбособленномуПодразделению;
	Элементы.ОбособленноеПодразделениеОрганизации.Доступность = Объект.ПоОбособленномуПодразделению;
	
	Элементы.ГруппаОбособленноеПодразделениеОрганизации.Доступность = Объект.ИспользоватьВКассовойКниге;
	
	Элементы.ИспользоватьВКассовойКниге.Видимость = НЕ(Объект.Владелец = Справочники.Организации.УправленческаяОрганизация);
	
	Элементы.Владелец.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	Элементы.НаправлениеДеятельности.АвтоОтметкаНезаполненного = ЗначениеНастроекПовтИсп.УказыватьНаправлениеНаБанковскихСчетахИКассах();
	
	Элементы.ПояснениеРазрешениеПлатежейБезЗаявок.Видимость = 
		ПолучитьФункциональнуюОпцию("ИспользоватьЗаявкиНаРасходованиеДенежныхСредств")
		И ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюДанных");
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Функция СформироватьАвтоНаименование()
	
	Элементы.Наименование.СписокВыбора.Очистить();
	
	СтрокаНаименования =
		СокрЛП(Объект.Владелец) + 
		?(ЗначениеЗаполнено(Объект.Подразделение), " - " + СокрЛП(Объект.Подразделение), "") + 
		" (" + Строка(объект.ВалютаДенежныхСредств) + ")";
	СтрокаНаименования = Лев(СтрокаНаименования, 100);
	
	Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
	
	Возврат СтрокаНаименования;

КонецФункции

&НаСервере
Процедура ОпределитьРазрешениеПлатежейБезУказанияРаспоряжений()
	
	РазрешитьПлатежиБезУказанияРаспоряжений = Объект.ПолучателиПлатежейПриПеремещенииДС.Количество() > 0;
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокКассПолучателей()

	Если НЕ (РазрешитьПлатежиБезУказанияРаспоряжений ИЛИ НеИспользоватьЗаявкиНаРасходованиеДенежныхСредств)
		ИЛИ Объект.ПолучателиПлатежейПриПеремещенииДС.Количество() = 0 Тогда
		 СписокКасс = НСтр("ru='<Указать кассы>';uk='<Зазначити каси>'");
	Иначе
		СписокКасс = "";
		Для Каждого СтрокаПолучательПлатежа Из Объект.ПолучателиПлатежейПриПеремещенииДС Цикл
			СписокКасс = СписокКасс + ?(СписокКасс="","",", ") + СтрокаПолучательПлатежа.ПолучательПлатежа.Наименование;
		КонецЦикла; 
	КонецЕсли; 
	
	Возврат СписокКасс;

КонецФункции

&НаСервере
Процедура ВалютаДенежныхСредствПриИзмененииСервер()
	
	Объект.ПолучателиПлатежейПриПеремещенииДС.Очистить();
	ОпределитьРазрешениеПлатежейБезУказанияРаспоряжений();
	СформироватьАвтоНаименование();
	
	//++ НЕ УТ
	Валютный = ?(Объект.ВалютаДенежныхСредств = ВалютаРеглУчета, Ложь, Истина);
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СчетУчета, "Валютный") <> Валютный Тогда
		Объект.СчетУчета = Неопределено;
		УстановитьПараметрыВыбораСчетаУчета();
	КонецЕсли;
	//-- НЕ УТ
	
КонецПроцедуры

//++ НЕ УТ

&НаСервере
Процедура ИнициализироватьСчетаУчета()
	
	СчетаУчета = Новый ФиксированныйМассив(Новый Массив);
	
	Если НЕ ПравоДоступа("Просмотр",  Метаданные.ПланыСчетов.Хозрасчетный) Тогда
		Возврат;
	КонецЕсли;
	
	СчетаУчетаДенежныхСредств = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаДенежныхСредств();
	СчетаУчета = Новый ФиксированныйМассив(СчетаУчетаДенежныхСредств.СчетаНаличныхДенежныхСредств);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораСчетаУчета()
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", СчетаУчета));
	
	Если ЗначениеЗаполнено(Объект.ВалютаДенежныхСредств) Тогда
		Валютный = ?(Объект.ВалютаДенежныхСредств = ВалютаРеглУчета, Ложь, Истина);
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Валютный", Валютный));
	КонецЕсли;
	
	Элементы.СчетУчета.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
КонецПроцедуры
//-- НЕ УТ

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьУправленческаяОрганизация()
	
	Если Объект.Владелец = Справочники.Организации.УправленческаяОрганизация Тогда
		Объект.ИспользоватьВКассовойКниге = Ложь;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти
