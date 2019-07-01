&НаКлиенте
Перем ИмяРедактируемогоРеквизита;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	ИспользоватьНесколькоВалют = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	
	Если ИспользоватьНесколькоВалют Тогда
		// подсистема запрета редактирования ключевых реквизитов объектов	
		ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	КонецЕсли;
	
	Элементы.Владелец.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Элементы.НаправлениеДеятельности.АвтоОтметкаНезаполненного = ЗначениеНастроекПовтИсп.УказыватьНаправлениеНаБанковскихСчетахИКассах();
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	//++ НЕ УТ
	ИнициализироватьСчетаУчета();
	УстановитьПараметрыВыбораСчетаУчета();
	//-- НЕ УТ
	
	// Обработчик механизма "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	НадписьСоздатьПравило = НСтр("ru='Объединять данные счетов банка в один файл';uk='Об''єднувати дані рахунків банку в один файл'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
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
Процедура ПередЗаписью(Отказ)
	
	Если Объект.РучноеИзменениеРеквизитовБанка Тогда
		Если КодБанка <> Объект.КодБанка Тогда
			Объект.КодБанка = КодБанка;
		КонецЕсли;
		Если НаименованиеБанка <> Объект.НаименованиеБанка Тогда
			Объект.НаименованиеБанка = НаименованиеБанка;
		КонецЕсли;
		Если ГородБанка <> Объект.ГородБанка Тогда
			Объект.ГородБанка = ГородБанка;
		КонецЕсли;
	КонецЕсли;
	
	
	Если ИспользоватьТекстКорреспондента Тогда
		Объект.ТекстКорреспондента = ТекстКорреспондента;
	Иначе
		Объект.ТекстКорреспондента = "";
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = СформироватьАвтоНаименование();
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		ДубльБанковскогоСчета = НайтиДубльБанковскогоСчета(Объект.Ссылка, Объект.НомерСчета, Объект.Владелец, Объект.ВалютаДенежныхСредств, Объект.Банк);
		
		Если ДубльБанковскогоСчета <> Неопределено Тогда
			
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Найден банковский счет ""%1"", с аналогичным номером в указанном банке.
                    |Продолжить запись текущего элемента?'
                    |;uk='Знайдено банківський рахунок ""%1"", з аналогічним номером в зазначеному банку.
                    |Продовжити запис поточного елемента?'"),
				ДубльБанковскогоСчета);
				
			ОписаниеОповещения = Новый ОписаниеОповещения("ПроверкаДублейЗавершение", ЭтаФорма);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
			Отказ = Истина;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаДублейЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Модифицированность = Ложь;
		Записать();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_БанковскиеСчетаОрганизаций", ПараметрыЗаписи, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик механизма "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	Если (ИсточникВыбора.ИмяФормы = "Справочник.БанковскиеСчетаОрганизаций.Форма.РеквизитыБанка") Тогда
		Если Не ПустаяСтрока(РезультатВыбора) Тогда
			Если РезультатВыбора.Реквизит = "КодБанка" Тогда	
				Объект.РучноеИзменениеРеквизитовБанка = РезультатВыбора.РучноеИзменение;
				Если РезультатВыбора.РучноеИзменение Тогда
					Объект.Банк              = "";
					Объект.КодБанка          = РезультатВыбора.ЗначенияПолей.КодБанка;
					Объект.НаименованиеБанка = РезультатВыбора.ЗначенияПолей.Наименование;
					Объект.ГородБанка        = РезультатВыбора.ЗначенияПолей.Город;
					Объект.АдресБанка        = РезультатВыбора.ЗначенияПолей.Адрес;
					Объект.ТелефоныБанка     = РезультатВыбора.ЗначенияПолей.Телефоны;
					
					КодБанка                 = РезультатВыбора.ЗначенияПолей.КодБанка;
					НаименованиеБанка        = РезультатВыбора.ЗначенияПолей.Наименование;
					ГородБанка               = РезультатВыбора.ЗначенияПолей.Город;
				Иначе
					Объект.Банк              = РезультатВыбора.Банк;
					Объект.КодБанка          = "";
					Объект.НаименованиеБанка = "";
					Объект.КоррСчетБанка     = "";
					Объект.ГородБанка        = "";
					Объект.АдресБанка        = "";
					Объект.ТелефоныБанка     = "";
					
					ЗаполнитьРеквизитыБанкаПоБанку(Объект.Банк, "Банк", Ложь);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли (ИсточникВыбора.ИмяФормы = "Справочник.КлассификаторБанков.Форма.ФормаВыбора") Тогда	
		Если ТипЗнч(РезультатВыбора) = Тип("СправочникСсылка.КлассификаторБанков") Тогда
			Если ИмяРедактируемогоРеквизита = "КодБанка" Тогда
				Объект.Банк              = РезультатВыбора;
				Объект.КодБанка          = "";
				Объект.НаименованиеБанка = "";
				Объект.ГородБанка        = "";
				Объект.АдресБанка        = "";
				Объект.ТелефоныБанка     = "";
				
				ЗаполнитьРеквизитыБанкаПоБанку(РезультатВыбора, "Банк", Ложь);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;
	
	БанкПриИзменении();
	
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
Процедура НомерСчетаПриИзменении(Элемент)
	
	Если Не ПустаяСтрока(Объект.НомерСчета) Тогда
		НомерСчетаПриИзмененииСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользуетсяБанкДляРасчетовПриИзменении(Элемент)
	
	Элементы.СчетВБанкеДляРасчетов.Доступность			= ИспользуетсяБанкДляРасчетов;
	Элементы.СВИФТБанкаДляРасчетов.Доступность			= ИспользуетсяБанкДляРасчетов;
	Элементы.НаименованиеБанкаДляРасчетов.Доступность	= ИспользуетсяБанкДляРасчетов;
	Элементы.АдресБанкаДляРасчетов.Доступность			= ИспользуетсяБанкДляРасчетов;
	Элементы.ТелефоныБанкаДляРасчетов.Доступность		= ИспользуетсяБанкДляРасчетов;

	Если НЕ ИспользуетсяБанкДляРасчетов Тогда
		Объект.НаименованиеБанкаДляРасчетов				 = "";
		Объект.АдресБанкаДляРасчетов					 = "";
		Объект.ТелефоныБанкаДляРасчетов					 = "";
		Объект.СчетВБанкеДляРасчетов						 = "";
		Объект.СВИФТБанкаДляРасчетов						 = "";
	КонецЕсли;
	
	ИспользуетсяБанкДляРасчетовПриИзмененииНаСервере();
	
КонецПроцедуры

Процедура ИспользуетсяБанкДляРасчетовПриИзмененииНаСервере()
	
	УстановитьПараметрыРедактированияРеквизитов();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры


&НаКлиенте
Процедура ИспользоватьТекстКорреспондентаПриИзменении(Элемент)

	Элементы.ТекстКорреспондента.Доступность = ИспользоватьТекстКорреспондента;
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	ЗаполнитьТекстКорреспондента();
	СформироватьАвтоНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыборФайла(Истина, НСтр("ru='Выберите файл для загрузки данных из клиента банка';uk='Виберіть файл для завантаження даних із клієнта банка'"));
		
КонецПроцедуры

&НаКлиенте
Процедура ФайлВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыборФайла(Ложь, НСтр("ru='Выберите файл для выгрузки данных в клиента банка';uk='Виберіть файл для вивантаження даних в клієнта банку'"));
		
КонецПроцедуры

&НаКлиенте
Процедура ФайлЗагрузкиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФайлДляПросмотра(Элемент, НСтр("ru='Файл загрузки';uk='Файл завантаження'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлВыгрузкиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФайлДляПросмотра(Элемент, НСтр("ru='Файл выгрузки';uk='Файл вивантаження'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаДенежныхСредствПриИзменении(Элемент)
	
	ВалютныйСчет = (ЗначениеЗаполнено(Объект.ВалютаДенежныхСредств) И Объект.ВалютаДенежныхСредств <> ВалютаРеглУчета);
	
	ВалютаДенежныхСредствПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеБанкаПриИзменении(Элемент)
	
	СформироватьАвтоНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимОбменаВключенПриИзменении(Элемент)
	
	Объект.ИспользоватьОбменСБанком = Объект.ОбменСБанкомВключен;
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура НомерСчетаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ТекстОшибки = "";
	ОчиститьСообщения();
	Валютный = (Объект.ВалютаДенежныхСредств <> ВалютаРеглУчета);
	
	Если Не ПустаяСтрока(Текст)
		И Не Объект.ИностранныйБанк
		И Не РегламентированныеДанныеКлиентСервер.ПроверитьКорректностьНомераСчета(Текст, Валютный, ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "НомерСчета", "Объект");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИностранныйБанкПриИзменении(Элемент)
	
	Объект.ИностранныйБанк = (ИностранныйБанк = 1);
	
	ИностранныйБанкПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ИностранныйБанкПриИзмененииНаСервере()
	
	УстановитьПараметрыРедактированияРеквизитов();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если ИспользоватьНесколькоВалют И (Не Объект.Ссылка.Пустая()) Тогда
		ОткрытьФорму("Справочник.БанковскиеСчетаОрганизаций.Форма.РазблокированиеРеквизитов",,,,,, 
			Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
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

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТекстКорреспондента.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьТекстКорреспондента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.FormBackColor);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.BorderColor);
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТекстКорреспондента.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьТекстКорреспондента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.FormBackColor);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.BorderColor);

КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ЗаполнитьТекстКорреспондента()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	НаименованиеСокращенное КАК Наименование
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.Ссылка = &Ссылка
	|";
	Запрос.УстановитьПараметр("Ссылка", Объект.Владелец);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		ТекстКорреспондента = СокрЛП(Выборка.Наименование);
	Иначе
		ТекстКорреспондента = "";
	КонецЕсли;
	

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлДляПросмотра(Элемент, Заголовок)
	
	ФайлНаДиске = Новый Файл;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОткрытьФайлДляПросмотраНачатьИнициализацию",
		ЭтотОбъект,
		Новый Структура("Элемент, Заголовок", Элемент, Заголовок));
		
	ФайлНаДиске.НачатьИнициализацию(ОписаниеОповещения, Элемент.ТекстРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлДляПросмотраНачатьИнициализацию(Файл, ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОткрытьФайлДляПросмотраФайлСуществует",
		ЭтотОбъект,
		ДополнительныеПараметры);
		
	Файл.НачатьПроверкуСуществования(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлДляПросмотраФайлСуществует(Существует, ДополнительныеПараметры) Экспорт
	
	Если НЕ Существует Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Не найден файл!';uk='Не знайдений файл!'"));
		Возврат;
	КонецЕсли;
	
	Текст = Новый ТекстовыйДокумент;
	Если Объект.Кодировка = "DOS" Тогда
		Кодир = КодировкаТекста.OEM;
	ИначеЕсли Объект.Кодировка = "Windows" Тогда
		Кодир = КодировкаТекста.ANSI;
	Иначе	
		Кодир = КодировкаТекста.UTF8;
	КонецЕсли;
	
	Текст.Прочитать(ДополнительныеПараметры.Элемент.ТекстРедактирования, Кодир);
	Текст.Показать(ДополнительныеПараметры.Заголовок, ДополнительныеПараметры.Элемент.ТекстРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайла(Загрузка, Заголовок);
	
	ИмяФайла = ?(Загрузка, Объект.ФайлЗагрузки, Объект.ФайлВыгрузки);
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		
	ДиалогВыбораФайла.Заголовок = Заголовок;
	ДиалогВыбораФайла.ПредварительныйПросмотр = Ложь;
	ДиалогВыбораФайла.Фильтр = НСтр("ru='XML файл (*.xml)|*.xml';uk='XML файл (*.xml)|*.xml'");
	ДиалогВыбораФайла.Расширение = "xml";
	ДиалогВыбораФайла.ИндексФильтра = 0;
	ДиалогВыбораФайла.ПолноеИмяФайла = ИмяФайла;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВыборФайлаЗавершение",
		ЭтотОбъект,
		Новый Структура("Загрузка", Загрузка));
	
	ДиалогВыбораФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.Загрузка Тогда
		Объект.ФайлЗагрузки = ВыбранныеФайлы[0];
	Иначе
		Объект.ФайлВыгрузки = ВыбранныеФайлы[0];
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция ЗаполнитьРеквизитыБанкаПоКоду(Код = "", ТипБанка, ПеренестиЗначенияРеквизитов = Ложь)	
	
	НашлиПоКоду   = Ложь;
	ЗаписьОБанке = "";
	
	Если ТипБанка = "Банк" Тогда
		КодБанка          = "";
		НаименованиеБанка = "";
		ГородБанка        = "";
		РаботаСБанками.ПолучитьДанныеКлассификатора(Код,,ЗаписьОБанке);
		Если НЕ ПустаяСтрока(ЗаписьОБанке) Тогда
			КодБанка		  = ЗаписьОБанке.Код;
			НаименованиеБанка = ЗаписьОБанке.Наименование;
			ГородБанка		  = ЗаписьОБанке.Город;
			НашлиПоКоду		  = Истина;
			Если ПеренестиЗначенияРеквизитов Тогда
				Объект.КодБанка			 = "";
				Объект.НаименованиеБанка = "";
				Объект.ГородБанка		 = "";
				Объект.АдресБанка		 = "";
				Объект.ТелефоныБанка	 = "";
				Объект.Банк				 = ЗаписьОБанке;
			КонецЕсли;
			Если Не Объект.ИностранныйБанк Тогда
				Объект.СВИФТБанка = СВИФТпоМФО(КодБанка);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат НашлиПоКоду;
	
КонецФункции

&НаСервере
Функция ЗаполнитьРеквизитыБанкаПоБанку(Банк = "", ТипБанка, ПеренестиЗначенияРеквизитов = Ложь)
	
	Если ТипЗнч(Банк) = Тип("СправочникСсылка.КлассификаторБанков") Тогда	
		Если ТипБанка = "Банк" Тогда
			
			КодБанка		  = Банк.Код;
			НаименованиеБанка = Банк.Наименование;
			ГородБанка		  = Банк.Город;
			Если ПеренестиЗначенияРеквизитов Тогда
				Объект.КодБанка			 = Банк.Код;
				Объект.НаименованиеБанка = Банк.Наименование;
				Объект.ГородБанка		 = Банк.Город;
				Объект.АдресБанка		 = Банк.Адрес;
				Объект.ТелефоныБанка	 = Банк.Телефоны;
				Объект.Банк				 = "";
			КонецЕсли;
			
			Если Не Объект.ИностранныйБанк Тогда
				Объект.СВИФТБанка = СВИФТпоМФО(КодБанка);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура НомерСчетаПриИзмененииСервер()
	
	
	СформироватьАвтоНаименование();
	
КонецПроцедуры 

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.ВалютаДенежныхСредств.ТолькоПросмотр = Истина;
		Элементы.Владелец.ТолькоПросмотр = Истина;
	Иначе
		Элементы.ВалютаДенежныхСредств.ТолькоПросмотр = Ложь;
		Элементы.Владелец.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
	
	Элементы.ИспользуетсяБанкДляРасчетов.Доступность = ВалютныйСчет;
	
	
	// Банковские реквизиты
	Элементы.ИностранныйБанк.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	
	Элементы.НаименованиеБанка.Доступность = Объект.РучноеИзменениеРеквизитовБанка;
	Элементы.ГородБанка.Доступность        = Объект.РучноеИзменениеРеквизитовБанка;
	Элементы.АдресБанка.Доступность        = Объект.РучноеИзменениеРеквизитовБанка;
	
	
	
	Элементы.СчетВБанкеДляРасчетов.Доступность        = ВалютныйСчет И ИспользуетсяБанкДляРасчетов;
	Элементы.СВИФТБанкаДляРасчетов.Доступность        = ВалютныйСчет И ИспользуетсяБанкДляРасчетов;
	Элементы.НаименованиеБанкаДляРасчетов.Доступность = ВалютныйСчет И ИспользуетсяБанкДляРасчетов;
	Элементы.АдресБанкаДляРасчетов.Доступность        = ВалютныйСчет И ИспользуетсяБанкДляРасчетов;
	Элементы.ТелефоныБанкаДляРасчетов.Доступность     = ВалютныйСчет И ИспользуетсяБанкДляРасчетов;
	
	Если Не Объект.ИностранныйБанк Тогда
		
		
		Элементы.РучноеИзменениеРеквизитовБанка.Видимость = Истина;
		
		Элементы.КодБанка.Заголовок = НСтр("ru='МФО';uk='МФО'");
		Элементы.КодБанка.КнопкаОткрытия = Истина;
		
		
		Элементы.АдресБанка.Видимость = ВалютныйСчет;
		Элементы.ГородБанка.Видимость = Не ВалютныйСчет;
		
		
		Элементы.ВариантВыводаМесяца.Видимость = Не ВалютныйСчет;
		
		Элементы.Переместить(Элементы.КодБанка, Элементы.КодБанка.Родитель, Элементы.СВИФТБанка);
		
	Иначе
		
		
		Элементы.РучноеИзменениеРеквизитовБанка.Видимость = Ложь;
		
		Элементы.КодБанка.Заголовок = НСтр("ru='Национальный код банка';uk='Національний код банку'");
		Элементы.КодБанка.КнопкаОткрытия = Ложь;
		
		
		Элементы.АдресБанка.Видимость = Истина;
		Элементы.ГородБанка.Видимость = Ложь;
		
		
		Элементы.ВариантВыводаМесяца.Видимость = Ложь;
		
		Элементы.Переместить(Элементы.СВИФТБанка, Элементы.СВИФТБанка.Родитель, Элементы.КодБанка);
		
	КонецЕсли;
	
	Элементы.ИспользуетсяБанкДляРасчетов.Видимость = ВалютныйСчет;
	Элементы.ГруппаБанкДляРасчетов.Видимость       = ВалютныйСчет;
	
	// Редактирование текста наименования организации
	ИспользоватьТекстКорреспондента = ЗначениеЗаполнено(Объект.ТекстКорреспондента);
	Элементы.ТекстКорреспондента.Доступность = ИспользоватьТекстКорреспондента;
	
	Если ИспользоватьТекстКорреспондента Тогда
		ТекстКорреспондента = Объект.ТекстКорреспондента;
	Иначе
		ЗаполнитьТекстКорреспондента();
	КонецЕсли;
	
	// Обмен с банками
	Элементы.ФайлВыгрузки.Доступность  = Объект.ИспользоватьОбменСБанком И Объект.ОбменСБанкомВключен;
	Элементы.Кодировка.Доступность     = Объект.ИспользоватьОбменСБанком И Объект.ОбменСБанкомВключен;
	Элементы.ФайлЗагрузки.Доступность  = Объект.ИспользоватьОбменСБанком И Объект.ОбменСБанкомВключен;

	Элементы.СтраницаОбменСБанком.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Настройка обмена с банком %1';uk='Настройка обміну з банком %1'"),
		?(Объект.ОбменСБанкомВключен, НСтр("ru='(включен)';uk='(включений)'"), НСтр("ru='(не включен)';uk='(не включений)'")));
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютныйСчет = (ЗначениеЗаполнено(Объект.ВалютаДенежныхСредств) И Объект.ВалютаДенежныхСредств <> ВалютаРеглУчета);
	
	ИностранныйБанк = ?(Объект.ИностранныйБанк, 1, 0);
	
	ПрочитатьТаблицуСоответствияМФОСВИФТ();
	ЗаполнитьСписокВидовСчета();
	ЗаполнитьРеквизитыБанка();
	УправлениеЭлементамиФормы();
	СформироватьАвтоНаименование();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыБанка()
	
	КодБанка		  = "";
	НаименованиеБанка = "";
	ГородБанка		  = "";
	
	
	Если Объект.РучноеИзменениеРеквизитовБанка Тогда
		КодБанка		  = Объект.КодБанка;
		НаименованиеБанка = Объект.НаименованиеБанка;
		ГородБанка		  = Объект.ГородБанка;
	Иначе
		Если НЕ Объект.Банк.Пустая() Тогда
			ЗаполнитьРеквизитыБанкаПоБанку(Объект.Банк, "Банк", Ложь);
		КонецЕсли;
	КонецЕсли;
	
	
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если ЗначениеЗаполнено(Объект.СВИФТБанкаДляРасчетов) Тогда
			ИспользуетсяБанкДляРасчетов = Истина;
		Иначе
			ИспользуетсяБанкДляРасчетов = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Программа    = "";
		Объект.Кодировка    = "Windows";
		Объект.ВидСчета = Элементы.ВидСчета.СписокВыбора[0];
		Объект.ТипФайла = "XML";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьАвтоНаименование()
	
	Элементы.Наименование.СписокВыбора.Очистить();
	
	Если Объект.РучноеИзменениеРеквизитовБанка Тогда
		СтрокаНаименования = Прав(СокрЛП(Объект.НомерСчета), 4) 
		+ ?(ЗначениеЗаполнено(НаименованиеБанка), " в " + Строка(НаименованиеБанка), "")
		+ ", " + СокрЛП(Объект.Владелец);
		СтрокаНаименования = Лев(СтрокаНаименования, 150);
		
		Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
		
		СтрокаНаименования = ?(ЗначениеЗаполнено(НаименованиеБанка), Строка(НаименованиеБанка), "")
		+ ", " + СокрЛП(объект.Владелец)
		+ " (" + Строка(Объект.ВалютаДенежныхСредств) + ")";
		СтрокаНаименования = Лев(СтрокаНаименования, 150);
		
		Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
		
	Иначе	
		
		СтрокаНаименования = Прав(СокрЛП(Объект.НомерСчета), 4) 
		+ ?(ЗначениеЗаполнено(Объект.Банк), " в " + Строка(Объект.Банк), "")
		+ ", " + СокрЛП(Объект.Владелец);
		СтрокаНаименования = Лев(СтрокаНаименования, 150);
		
		Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
		
		СтрокаНаименования = ?(ЗначениеЗаполнено(Объект.Банк), Строка(Объект.Банк), "")
		+ ", " + СокрЛП(объект.Владелец)
		+ " (" + Строка(Объект.ВалютаДенежныхСредств) + ")";
		СтрокаНаименования = Лев(СтрокаНаименования, 150);
		
		Элементы.Наименование.СписокВыбора.Добавить(СтрокаНаименования);
		
	КонецЕсли;
	
	Возврат СтрокаНаименования;

КонецФункции

&НаСервере
Процедура ЗаполнитьСписокВидовСчета()
	
	СписокВидСчета = Элементы.ВидСчета.СписокВыбора;
	СписокВидСчета.Очистить();
	
	СписокВидСчета.Добавить("Текущий");
	СписокВидСчета.Добавить("Депозитный");
	СписокВидСчета.Добавить("Инвестиционный");
	
КонецПроцедуры

&НаКлиенте
Процедура КодБанкаПриИзменении(Элемент)	
	
	ИмяРедактируемогоРеквизита = "КодБанка";
	РеквизитБанкаПриИзменении("КодБанка");
	
КонецПроцедуры

&НаКлиенте
Процедура КодБанкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)	
	
	ИмяРедактируемогоРеквизита = "КодБанка";
	РеквизитБанкаПриВыборе("КодБанка", ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КодБанкаОткрытие(Элемент, СтандартнаяОбработка)	
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(КодБанка) Тогда
		ИмяРедактируемогоРеквизита = "КодБанка";
		РеквизитБанкаОткрытие("КодБанка");
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура РучноеИзменениеРеквизитовБанкаПриИзменении(Элемент)
	
	ЗаписьОБанке = "";
	Если Объект.РучноеИзменениеРеквизитовБанка Тогда
		Если НЕ Объект.Банк.Пустая() Тогда
			ЗаполнитьРеквизитыБанкаПоБанку(Объект.Банк, "Банк", Истина);
		КонецЕсли;	
		Объект.Банк = "";
	Иначе
		ЗаполнитьРеквизитыБанкаПоКоду(Объект.КодБанка, "Банк", Истина);
		Объект.КодБанка			 = "";
		Объект.НаименованиеБанка = "";
		Объект.КоррСчетБанка	 = "";
		Объект.ГородБанка		 = "";
		Объект.АдресБанка		 = "";
		Объект.ТелефоныБанка	 = "";
	КонецЕсли;
	
	БанкПриИзменении();
	
КонецПроцедуры


&НаКлиенте
Процедура РеквизитБанкаПриВыборе(ИмяЭлемента, Форма)
	
	Если ИмяЭлемента = "КодБанка" Тогда
		Если Не Объект.РучноеИзменениеРеквизитовБанка Тогда
			СтруктураПараметров = Новый Структура;
			СтруктураПараметров.Вставить("Реквизит", ИмяЭлемента);
			ОткрытьФорму("Справочник.КлассификаторБанков.Форма.ФормаВыбора", СтруктураПараметров, Форма);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитБанкаОткрытие(ИмяЭлемента)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Реквизит", ИмяЭлемента);
	ЗначенияПараметров = Новый Структура;
	
	Если ИмяЭлемента = "КодБанка" Тогда	
		
		СтруктураПараметров.Вставить("РучноеИзменение", Объект.РучноеИзменениеРеквизитовБанка);
		
		Если Объект.РучноеИзменениеРеквизитовБанка Тогда
			ЗначенияПараметров.Вставить("КодБанка", КодБанка);
			ЗначенияПараметров.Вставить("Наименование", НаименованиеБанка);
			ЗначенияПараметров.Вставить("Город", ГородБанка);
			ЗначенияПараметров.Вставить("Адрес", Объект.АдресБанка);
			ЗначенияПараметров.Вставить("Телефоны", Объект.ТелефоныБанка);
		Иначе
			СтруктураПараметров.Вставить("Банк", Объект.Банк);
		КонецЕсли;
		

	КонецЕсли;
	
	СтруктураПараметров.Вставить("ЗначенияПолей", ЗначенияПараметров);
	ОткрытьФорму("Справочник.БанковскиеСчетаОрганизаций.Форма.РеквизитыБанка",СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитБанкаПриИзменении(ИмяЭлемента)
	
	Если ИмяЭлемента = "КодБанка" Тогда	
		Если Не Объект.РучноеИзменениеРеквизитовБанка И Не Объект.ИностранныйБанк Тогда
			Если Не ЗаполнитьРеквизитыБанкаПоКоду(КодБанка, "Банк", Истина) Тогда	
				
				СписокВариантовОтветовНаВопрос = Новый СписокЗначений;
				СписокВариантовОтветовНаВопрос.Добавить("ВыбратьИзСписка",  НСтр("ru='Выбрать из списка';uk='Вибрати зі списку'"));
				СписокВариантовОтветовНаВопрос.Добавить("ПродолжитьВвод",   НСтр("ru='Продолжить ввод';uk='Продовжити введення'"));
				СписокВариантовОтветовНаВопрос.Добавить("ОтменитьВвод",     НСтр("ru='Отменить ввод';uk='Скасувати введення'"));
				
				ТекстВопроса = НСтр("ru='Банк с МФО %Значение% не найден в классификаторе банков.';uk='Банк з МФО %Значение% не найдено у класифікаторі банків.'");
				ТекстВопроса = СтрЗаменить(ТекстВопроса, "%Значение%", КодБанка);
				
				Ответ = Неопределено;

				
				ПоказатьВопрос(
					Новый ОписаниеОповещения("РеквизитБанкаПриИзмененииПослеВопроса",
					ЭтотОбъект,
					Новый Структура("ИмяЭлемента, СписокВариантовОтветовНаВопрос, ТекстВопроса",
						ИмяЭлемента, СписокВариантовОтветовНаВопрос, ТекстВопроса)),
					ТекстВопроса,
					СписокВариантовОтветовНаВопрос,
					0,,
					НСтр("ru='Выбор банка из классификатора';uk='Вибір банку з класифікатора'"));
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	БанкПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитБанкаПриИзмененииПослеВопроса(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ИмяЭлемента = ДополнительныеПараметры.ИмяЭлемента;
	СписокВариантовОтветовНаВопрос = ДополнительныеПараметры.СписокВариантовОтветовНаВопрос;
	ТекстВопроса = ДополнительныеПараметры.ТекстВопроса;
	
	Ответ = РезультатВопроса;
	
	Если Ответ = "ОтменитьВвод" Тогда
		КодБанка = "";
	ИначеЕсли Ответ = "ПродолжитьВвод" Тогда
		Объект.РучноеИзменениеРеквизитовБанка = Истина;
		Объект.КодБанка = КодБанка;
	ИначеЕсли Ответ = "ВыбратьИзСписка" Тогда
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Реквизит", "КодБанка");
		ОткрытьФорму("Справочник.КлассификаторБанков.Форма.ФормаВыбора", СтруктураПараметров, ЭтаФорма);
	КонецЕсли;
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры


&НаСервере
Процедура ВалютаДенежныхСредствПриИзмененииСервер()
	
	СформироватьАвтоНаименование();
	
	УстановитьПараметрыРедактированияРеквизитов();
	
	//++ НЕ УТ
	Валютный = ?(Объект.ВалютаДенежныхСредств = ВалютаРеглУчета, Ложь, Истина);
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СчетУчета, "Валютный") <> Валютный Тогда
		Объект.СчетУчета = Неопределено;
		УстановитьПараметрыВыбораСчетаУчета();
	КонецЕсли;
	//-- НЕ УТ
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыРедактированияРеквизитов()
	
	Если Объект.ИностранныйБанк Тогда
		Объект.РучноеИзменениеРеквизитовБанка = Истина;
	КонецЕсли;
	
КонецПроцедуры

//++ НЕ УТ
&НаСервере
Процедура ИнициализироватьСчетаУчета()
	
	СчетаУчета = Новый ФиксированныйМассив(Новый Массив);
	
	Если НЕ ПравоДоступа("Просмотр",  Метаданные.ПланыСчетов.Хозрасчетный) Тогда
		Возврат;
	КонецЕсли;
	
	СчетаУчетаДенежныхСредств = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаДенежныхСредств();
	СчетаУчета = Новый ФиксированныйМассив(СчетаУчетаДенежныхСредств.СчетаБезналичныхДенежныхСредств);
	
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

&НаСервереБезКонтекста
Функция НайтиДубльБанковскогоСчета(Ссылка, НомерСчета, Организация, Валюта, Банк)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	БанковскиеСчета.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчета
	|ГДЕ
	|	Не БанковскиеСчета.ПометкаУдаления
	|	И БанковскиеСчета.Ссылка <> &Ссылка
	|	И БанковскиеСчета.НомерСчета = &НомерСчета
	|	И БанковскиеСчета.Владелец = &Организация
	|	И БанковскиеСчета.ВалютаДенежныхСредств = &Валюта
	|	И БанковскиеСчета.Банк = &Банк
	|");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("НомерСчета", НомерСчета);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("Банк", Банк);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ПрочитатьТаблицуСоответствияМФОСВИФТ()	
	
	СоответствиеМФОСВИФТXML = Справочники.БанковскиеСчетаОрганизаций.ПолучитьМакет("СоответствиеМФОSWIFT").ПолучитьТекст();
	СоответствиеМФОСВИФТ.Загрузить(ОбщегоНазначения.ПрочитатьXMLВТаблицу(СоответствиеМФОСВИФТXML).Данные);
	
КонецПроцедуры

&НаСервере
Функция СВИФТпоМФО(МФО)	
	
	СтрокиСоответствия = СоответствиеМФОСВИФТ.НайтиСтроки(Новый Структура("МФО", СокрЛП(МФО)));
	Если СтрокиСоответствия.Количество() = 1 Тогда
		Возврат СтрокиСоответствия[0].SWIFT;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура БанкПриИзменении()
	
	Объект.ФайлВыгрузки = Справочники.БанковскиеСчетаОрганизаций.ФайлВыгрузкиПоУмолчанию(Объект.Банк);
	Объект.ФайлЗагрузки = Справочники.БанковскиеСчетаОрганизаций.ФайлЗагрузкиПоУмолчанию(Объект.Банк);
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
