
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Изменить", "Доступность", Ложь);
		
		Если НЕ ЗначениеЗаполнено(Объект.ВалютаВзаиморасчетов) Тогда
			Объект.ВалютаВзаиморасчетов = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		КонецЕсли;
		
		ОбновитьЗаголовокФормы();
		УстановитьВидимость();
		
		Если ЗначениеЗаполнено(Объект.Партнер) Тогда
			ПартнерПриИзмененииСервер(Объект.Партнер, Объект.Контрагент, Объект.ПорядокОплаты, Объект.БанковскийСчетКонтрагента);
		КонецЕсли;
		
		ЗаполнитьСтатьиУчета(Объект.ХарактерДоговора, Объект.ТипДоговора, Объект.ТипСрочности);
		
		ЗначениеКопирования = Параметры.ЗначениеКопирования;
		Если ЗначениеЗаполнено(ЗначениеКопирования) Тогда
			РегистрыСведений.ПроцентныеСтавкиКредитовИДепозитов.ПрочитатьПроцентнуюСтавкуКомисиию(ЗначениеКопирования, ЭтаФорма.СтавкаПроцентов, ЭтаФорма.Комиссия);
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыВыбораСчета = ПараметрыВыбораБанковскихСчетов(Объект.ПорядокОплаты);
	Элементы.БанковскийСчет.ПараметрыВыбора            = ПараметрыВыбораСчета;
	Элементы.БанковскийСчетКонтрагента.ПараметрыВыбора = ПараметрыВыбораСчета;
	Элементы.БанковскийСчетПроцентов.ПараметрыВыбора   = ПараметрыВыбораСчета;
	Элементы.БанковскийСчетКомиссии.ПараметрыВыбора    = ПараметрыВыбораСчета;
	Элементы.Касса.ПараметрыВыбора                     = ПараметрыВыбораСчета;
	Элементы.Партнер.ПараметрыВыбора = ПараметрыВыбораПартнера();
	УстановитьПараметрыВыбораСтатейДДС();
	
	УстановитьТипДоговора();
	УстановитьВидимостьГруппыФинансовогоУчетаДенежныхСредств();
	// подсистема запрета редактирования ключевых реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	УстановитьДоступностьСтавкиПроцентовСервер();
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	
	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	ОбновитьЗаголовокФормы();
	УстановитьВидимость();
	ОбновитьДанныеГрафиковСервер();
	УстановитьДоступностьПоГрафикуСервер();
	УстановитьДоступностьСтавкиПроцентовСервер();
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	КонтролироватьЛимит = Объект.СуммаЛимита > 0;
	КонтролироватьЛимитПриИзменении(Элементы.КонтролироватьЛимит);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	Если ТекущийОбъект.Статус <> Перечисления.СтатусыДоговоровКонтрагентов.НеСогласован
		И НЕ Справочники.ДоговорыКредитовИДепозитов.ЗаполненыСтатьиУчета(ТекущийОбъект) Тогда
		Отказ = Истина;
	КонецЕсли;

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РегистрыСведений.ПроцентныеСтавкиКредитовИДепозитов.ЗаписатьПроцентнуюСтавкуКомисиию(Объект.Ссылка, ЭтаФорма.СтавкаПроцентов, ЭтаФорма.Комиссия, Объект.Дата);
	УстановитьДоступностьПоГрафикуСервер();
	УстановитьДоступностьСтавкиПроцентовСервер();
	ОбновитьЗаголовокФормы();

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	Если ИмяСобытия = "ИзмененыСвязанныеДанныеПоКредитуДепозиту" Тогда
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Если Параметр.Свойство("ИтогиГрафика") Тогда
				Для Каждого Итог Из Параметр.ИтогиГрафика Цикл
					Если Объект.Свойство(Итог.Ключ) Тогда
						Объект[Итог.Ключ] = Итог.Значение;
					КонецЕсли;
				КонецЦикла;
				ОбновитьДоступностьСервер();
			КонецЕсли;
			Если Параметр.Свойство("СтавкиДоговора") Тогда
				ЭтаФорма.СтавкаПроцентов = Параметр.СтавкиДоговора.Процент;
				ЭтаФорма.Комиссия = Параметр.СтавкиДоговора.Комиссия;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "СнятиеБлокировкиРеквизитов" Тогда
		// Настроим отображение ставки процентов и комиссии
		УстановитьДоступностьСтавкиПроцентовСервер();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаВзаиморасчетовПриИзменении(Элемент)
	
	ВалютаВзаиморасчетовПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПервогоТраншаПриИзменении(Элемент)
	
	ДатаСрокиГрафикаПриИзмененииСервер(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПоследнегоПлатежаПриИзменении(Элемент)
	
	ДатаСрокиГрафикаПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокМесПриИзменении(Элемент)
	
	ДатаСрокиГрафикаПриИзменении(Элемент)
	
КонецПроцедуры

&НаКлиенте
Процедура СрокДнейПриИзменении(Элемент)
	
	ДатаСрокиГрафикаПриИзменении(Элемент)
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаСрокиГрафикаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДатаПоследнегоПлатежа) И Объект.ДатаПоследнегоПлатежа < Объект.ДатаПервогоТранша Тогда
		
		Текст = НСтр("ru='Дата последнего платежа не может быть раньше даты первого транша';uk='Дата останнього платежу не може бути раніше дати першого траншу'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,,"ДатаПоследнегоПлатежа","Объект");
		Объект.ДатаПоследнегоПлатежа = Неопределено;
		
	КонецЕсли;
	
	ДатаСрокиГрафикаПриИзмененииСервер(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.НаименованиеДляПечати) Тогда
		Объект.НаименованиеДляПечати = Объект.Наименование;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	ПартнерПриИзмененииСервер(Объект.Партнер, Объект.Контрагент, Объект.ПорядокОплаты, Объект.БанковскийСчетКонтрагента);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ЗаполнитьБанковскийСчетПоУмолчанию(Объект.Контрагент, Объект.ПорядокОплаты, Объект.БанковскийСчетКонтрагента);

КонецПроцедуры

&НаКлиенте
Процедура ПорядокОплатыПриИзменении(Элемент)
	
	ПорядокОплатыПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстИспользуемыйГрафикНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ВариантГрафика.Пустая() Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Ответ = Неопределено;

			ПоказатьВопрос(Новый ОписаниеОповещения("ТекстИспользуемыйГрафикНажатиеЗавершение", ЭтотОбъект), НСтр("ru='Ввод графика возможен только после записи договора.
                                        |Записать и продолжить?'
                                        |;uk='Введення графіка можливе тільки після запису договору.
                                        |Записати і продовжити?'"),
							РежимДиалогаВопрос.ДаНет,,
							КодВозвратаДиалога.Да);
            Возврат;
		КонецЕсли;
		
		ТекстИспользуемыйГрафикНажатиеФрагмент();

	Иначе
		ОткрытьФорму("Справочник.ВариантыГрафиковКредитовИДепозитов.ФормаОбъекта",
						Новый Структура("Ключ",ВариантГрафика), 
						ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстИспользуемыйГрафикНажатиеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли;
    
    ТекстИспользуемыйГрафикНажатиеФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ТекстИспользуемыйГрафикНажатиеФрагмент()
    
    ПараметрыФормы = Новый Структура("Владелец",Объект.Ссылка);
    ОткрытьФорму("Справочник.ВариантыГрафиковКредитовИДепозитов.ФормаОбъекта",
    ПараметрыФормы, 
    ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ТипДоговораСрочностиПриИзменении(Элемент)
	
	ЗаполнитьСтатьиУчета(Объект.ХарактерДоговора, Объект.ТипДоговора, Объект.ТипСрочности);
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактерДоговораПриИзменении(Элемент)
	
	ХарактерДоговораПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеВидимостьюПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтавкуПроцентовНажатие(Элемент)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Договор", Объект.Ссылка));
	ОткрытьФорму("РегистрСведений.ПроцентныеСтавкиКредитовИДепозитов.ФормаСписка", 
					ПараметрыФормы, 
					ЭтаФорма,
					Истина,
					Окно);
					
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОбеспечение

&НаКлиенте
Процедура ОбеспечениеПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И НЕ Копирование Тогда
		
		Элемент.ТекущиеДанные.Контрагент = Объект.Контрагент;
		Элемент.ТекущиеДанные.Статус = ПредопределенноеЗначение("Перечисление.СтатусыДоговоровКонтрагентов.НеСогласован");
		Элемент.ТекущиеДанные.ДатаНачала = Объект.Дата;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбработкаСнятияБлокировки = Новый ОписаниеОповещения("СнятиеБлокировкиРеквизитов", ЭтаФорма);
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма,,ОбработкаСнятияБлокировки);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
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

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	Если Объект.ФормаОплаты = Перечисления.ФормыОплаты.Наличная Тогда		
		ЗаполнитьКассуПоУмолчанию(Объект.Организация, Объект.Касса, Объект.ВалютаВзаиморасчетов);
	Иначе
		ЗаполнитьБанковскийСчетПоУмолчанию(Объект.Организация, Объект.ПорядокОплаты, Объект.БанковскийСчет);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВалютаВзаиморасчетовПриИзмененииСервер()
	
	Если Объект.ВалютаВзаиморасчетов = Константы.ВалютаРегламентированногоУчета.Получить() Тогда
		Объект.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВГривнахОплатаВГривнах;
	ИначеЕсли Объект.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВГривнахОплатаВГривнах Тогда
		Объект.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.ПустаяСсылка();
	КонецЕсли;
	
	ПорядокОплатыПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ДатаСрокиГрафикаПриИзмененииСервер(ИмяЭлемента = "ДатаПоследнегоПлатежа")
	
	ОбъектСправочника = РеквизитФормыВЗначение("Объект",Тип("СправочникОбъект.ДоговорыКредитовИДепозитов"));
	Справочники.ВариантыГрафиковКредитовИДепозитов.ПересчитатьСроки(ОбъектСправочника,ИмяЭлемента);
	ЗначениеВРеквизитФормы(ОбъектСправочника,"Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьЛимитПриИзменении(Элемент)
	
	Элементы.СуммаЛимита.ТолькоПросмотр = НЕ КонтролироватьЛимит;
	Если НЕ КонтролироватьЛимит И Объект.СуммаЛимита > 0 Тогда
		Объект.СуммаЛимита = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПартнерПриИзмененииСервер(Партнер, Контрагент, ПорядокОплаты, БанковскийСчетКонтрагента)
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	ЗаполнитьБанковскийСчетПоУмолчанию(Контрагент, ПорядокОплаты, БанковскийСчетКонтрагента);
	
КонецПроцедуры

&НаСервере
Процедура ПорядокОплатыПриИзмененииСервер()
	
	Если Объект.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВГривнахОплатаВГривнах Тогда
		Объект.ВалютаВзаиморасчетов = Константы.ВалютаРегламентированногоУчета.Получить();
	ИначеЕсли Объект.ВалютаВзаиморасчетов = Константы.ВалютаРегламентированногоУчета.Получить() Тогда
		Объект.ВалютаВзаиморасчетов = Справочники.Валюты.ПустаяСсылка();
	КонецЕсли;
	
	ПараметрыВыбораСчета = ПараметрыВыбораБанковскихСчетов(Объект.ПорядокОплаты);
	Элементы.БанковскийСчет.ПараметрыВыбора            = ПараметрыВыбораСчета;
	Элементы.БанковскийСчетКонтрагента.ПараметрыВыбора = ПараметрыВыбораСчета;
	Элементы.БанковскийСчетПроцентов.ПараметрыВыбора   = ПараметрыВыбораСчета;
	Элементы.БанковскийСчетКомиссии.ПараметрыВыбора    = ПараметрыВыбораСчета;
	Элементы.Касса.ПараметрыВыбора                     = ПараметрыВыбораСчета;
	
	Если НЕ БанковскийСчетСоответствуетПорядкуОплаты(Объект.БанковскийСчет, Объект.ПорядокОплаты) Тогда
		Объект.БанковскийСчет = Неопределено;
	КонецЕсли;
	ЗаполнитьБанковскийСчетПоУмолчанию(Объект.Организация, Объект.ПорядокОплаты, Объект.БанковскийСчет);
	
	Если НЕ БанковскийСчетСоответствуетПорядкуОплаты(Объект.БанковскийСчетКонтрагента, Объект.ПорядокОплаты) Тогда
		Объект.БанковскийСчетКонтрагента = Неопределено;
	КонецЕсли;
	ЗаполнитьБанковскийСчетПоУмолчанию(Объект.Контрагент, Объект.ПорядокОплаты, Объект.БанковскийСчетКонтрагента);
	
	Если НЕ БанковскийСчетСоответствуетПорядкуОплаты(Объект.БанковскийСчетПроцентов, Объект.ПорядокОплаты) Тогда
		Объект.БанковскийСчетПроцентов = Неопределено;
	КонецЕсли;
	
	Если НЕ БанковскийСчетСоответствуетПорядкуОплаты(Объект.БанковскийСчетКомиссии, Объект.ПорядокОплаты) Тогда
		Объект.БанковскийСчетКомиссии = Неопределено;
	КонецЕсли;
	
	Если НЕ КассаСоответствуетПорядкуОплаты(Объект.Касса, Объект.ПорядокОплаты) Тогда
		Объект.Касса = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ХарактерДоговораПриИзмененииСервер()
	
	Элементы.Партнер.ПараметрыВыбора = ПараметрыВыбораПартнера();
	УстановитьПараметрыВыбораСтатейДДС();
	
	УстановитьТипДоговора();
	ЗаполнитьСтатьиУчета(Объект.ХарактерДоговора, Объект.ТипДоговора, Объект.ТипСрочности);
	
	Если Объект.ХарактерДоговора = Перечисления.ХарактерДоговораКредитовИДепозитов.Депозит Тогда
		Объект.ФормаОплаты = Перечисления.ФормыОплаты.Безналичная;
		Объект.ТипКомиссии = Перечисления.ТипыКомиссииКредитовИДепозитов.Нет;
	КонецЕсли;
	УстановитьВидимость();
	
	УстановитьВидимостьГруппыФинансовогоУчетаДенежныхСредств();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств(Команда)
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыВыбораБанковскихСчетов(ПорядокОплаты)

	МассивПараметров = Новый Массив;
	
	Если ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВГривнахОплатаВГривнах
	 ИЛИ ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВГривнах Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВалютаДенежныхСредств", Константы.ВалютаРегламентированногоУчета.Получить()));
	Иначе
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВалютаДенежныхСредств", Новый ФиксированныйМассив(ИностранныеВалюты())));
	КонецЕсли;
	
	МассивПараметров.Добавить(Новый ПараметрВыбора("ВыборСчетовГоловнойОрганизации", Неопределено));
	
	Возврат Новый ФиксированныйМассив(МассивПараметров);
	
КонецФункции

&НаСервереБезКонтекста
Функция ИностранныеВалюты()
	
	Запрос = Новый Запрос("ВЫБРАТЬ
						|	Валюты.Ссылка КАК Ссылка
						|ИЗ
						|	Справочник.Валюты КАК Валюты
						|ГДЕ
						|	Валюты.Ссылка <> &ВалютаРегламентированногоУчета
						|	И Валюты.ПометкаУдаления = ЛОЖЬ");
	
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаСервереБезКонтекста
Функция БанковскийСчетСоответствуетПорядкуОплаты(БанковскийСчет, ПорядокОплаты)

	Соответствует = Истина;
	
	Если ЗначениеЗаполнено(БанковскийСчет) Тогда
		
		ВалютаСчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БанковскийСчет, "ВалютаДенежныхСредств");
		
		Если ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВВалюте Тогда
			Соответствует = ВалютаСчета <> Константы.ВалютаРегламентированногоУчета.Получить();
		Иначе
			Соответствует = ВалютаСчета = Константы.ВалютаРегламентированногоУчета.Получить();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Соответствует;
	
КонецФункции

&НаСервереБезКонтекста
Функция КассаСоответствуетПорядкуОплаты(Касса, ПорядокОплаты)

	Соответствует = Истина;
	
	Если ЗначениеЗаполнено(Касса) Тогда
		
		ВалютаКассы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Касса, "ВалютаДенежныхСредств");
		
		Если ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВВалюте Тогда
			Соответствует = ВалютаКассы <> Константы.ВалютаРегламентированногоУчета.Получить();
		Иначе
			Соответствует = ВалютаКассы = Константы.ВалютаРегламентированногоУчета.Получить();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Соответствует;
	
КонецФункции

&НаСервере
Функция ПараметрыВыбораПартнера()
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ПрочиеОтношения", Истина));
	Возврат Новый ФиксированныйМассив(МассивПараметров);
	
КонецФункции

&НаСервере
Процедура УстановитьПараметрыВыбораСтатейДДС()
	
	ХО = Перечисления.ХозяйственныеОперации;
	ХарактерыДоговоров = Перечисления.ХарактерДоговораКредитовИДепозитов;
	Если Объект.ХарактерДоговора <> ХарактерыДоговоров.КредитИлиЗайм Тогда
		Элементы.СтатьяДДСПоступления.ПараметрыВыбора = ПараметрыВыбораСтатьиДДС(Объект.ХарактерДоговора);
		Элементы.СтатьяДДСОсновногоДолга.ПараметрыВыбора = ПараметрыВыбораСтатьиДДС(Объект.ХарактерДоговора, Истина);
		Если Объект.ХарактерДоговора = ХарактерыДоговоров.Депозит Тогда
			Элементы.СтатьяДДСПроцентов.ПараметрыВыбора = ПараметрыВыбораСтатьиДДС(Объект.ХарактерДоговора,,ХО.НачисленияПоДепозитам);
		Иначе
			Элементы.СтатьяДДСПроцентов.ПараметрыВыбора = ПараметрыВыбораСтатьиДДС(Объект.ХарактерДоговора,,ХО.ПоступлениеПроцентовПоЗаймамВыданным);
		КонецЕсли;
	Иначе
		Элементы.СтатьяДДСПоступления.ПараметрыВыбора = ПараметрыВыбораСтатьиДДС(Объект.ХарактерДоговора, Истина);
		Элементы.СтатьяДДСОсновногоДолга.ПараметрыВыбора = ПараметрыВыбораСтатьиДДС(Объект.ХарактерДоговора);
		Элементы.СтатьяДДСПроцентов.ПараметрыВыбора = ПараметрыВыбораСтатьиДДС(Объект.ХарактерДоговора,,ХО.ОплатаПроцентовПоКредитам);
	КонецЕсли;
	Элементы.СтатьяДДСКомиссии.ПараметрыВыбора = ПараметрыВыбораСтатьиДДС(Объект.ХарактерДоговора,,);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыВыбораСтатьиДДС(ХарактерДоговора, ЭтоПоступление = Ложь, ХозяйственнаяОперация = Неопределено)
	
	МассивПараметров = Новый Массив;
	Если ХозяйственнаяОперация = Неопределено Тогда
		ХозяйственнаяОперация = Справочники.ДоговорыКредитовИДепозитов.ОперацияПоХарактеруДоговора(ХарактерДоговора, ЭтоПоступление);
	КонецЕсли;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ХозяйственнаяОперация", ХозяйственнаяОперация));
	Возврат Новый ФиксированныйМассив(МассивПараметров);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьБанковскийСчетПоУмолчанию(ВладелецСчета, ПорядокОплаты, БанковскийСчетВладельца)
	
	Если ЗначениеЗаполнено(БанковскийСчетВладельца)
	 ИЛИ НЕ ЗначениеЗаполнено(ВладелецСчета) Тогда
		Возврат;
	КонецЕсли;
	
	ОплатаВВалюте = ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВВалюте;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 2
	|	БанковскиеСчета.Ссылка КАК БанковскийСчет
	|ИЗ
	|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.Владелец = &ВладелецСчета
	|	И (БанковскиеСчета.ВалютаДенежныхСредств = &ВалютаРегл И НЕ &ОплатаВВалюте
	|		ИЛИ БанковскиеСчета.ВалютаДенежныхСредств <> &ВалютаРегл И &ОплатаВВалюте)
	|	И НЕ БанковскиеСчета.ПометкаУдаления");
	
	Если ТипЗнч(ВладелецСчета) = Тип("СправочникСсылка.Контрагенты") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"БанковскиеСчетаОрганизаций","БанковскиеСчетаКонтрагентов");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ВладелецСчета", ВладелецСчета);
	Запрос.УстановитьПараметр("ОплатаВВалюте", ОплатаВВалюте);
	Запрос.УстановитьПараметр("ВалютаРегл", Константы.ВалютаРегламентированногоУчета.Получить());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 И Выборка.Следующий() Тогда
		БанковскийСчетВладельца = Выборка.БанковскийСчет;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьКассуПоУмолчанию(Организация, Касса, ВалютаВзаиморасчетов)
	
	Если ЗначениеЗаполнено(Касса) Тогда
		Возврат;
	КонецЕсли;
	
	Касса = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ТекущаяКасса", "");
	Если Не ЗначениеЗаполнено(Касса) Тогда
		Касса = Справочники.Кассы.ПолучитьКассуПоУмолчанию(Организация);
	КонецЕсли;
	Если ЗначениеЗаполнено(Касса) Тогда
		СтруктураРеквизитов = Справочники.Кассы.ПолучитьРеквизитыКассы(Касса);
		ВалютаВзаиморасчетов = СтруктураРеквизитов.Валюта;
	Иначе
		ВалютаВзаиморасчетов = Константы.ВалютаРегламентированногоУчета.Получить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатьиУчета(ДоговорХарактер, ДоговорТип, ТипСрочности) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДоговорыКредитовИДепозитов.Ссылка,
	|	ДоговорыКредитовИДепозитов.СтатьяДДСКомиссии,
	|	ДоговорыКредитовИДепозитов.СтатьяДДСОсновногоДолга,
	|	ДоговорыКредитовИДепозитов.СтатьяДДСПоступленияВыдачи,
	|	ДоговорыКредитовИДепозитов.СтатьяДДСПроцентов,
	|	ДоговорыКредитовИДепозитов.СтатьяДоходовРасходовКомиссии,
	|	ДоговорыКредитовИДепозитов.СтатьяДоходовРасходовПроцентов,
	|	ДоговорыКредитовИДепозитов.Дата КАК Дата
	|ИЗ
	|	Справочник.ДоговорыКредитовИДепозитов КАК ДоговорыКредитовИДепозитов
	|ГДЕ
	|	НЕ ДоговорыКредитовИДепозитов.ПометкаУдаления
	|	И ДоговорыКредитовИДепозитов.ТипДоговора = &ТипДоговора
	|	И ДоговорыКредитовИДепозитов.ХарактерДоговора = &ХарактерДоговора
	|	И ДоговорыКредитовИДепозитов.ТипСрочности = &ТипСрочности
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ";
	
	Запрос.УстановитьПараметр("ТипДоговора", ДоговорТип);
	Запрос.УстановитьПараметр("ХарактерДоговора", ДоговорХарактер);
	Запрос.УстановитьПараметр("ТипСрочности",ТипСрочности);
	
	ПустаяСтатьяДоходов = ПланыВидовХарактеристик.СтатьиДоходов.ПустаяСсылка();
	ПустаяСтатьяРасходов = ПланыВидовХарактеристик.СтатьиРасходов.ПустаяСсылка();
	ПустаяСтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.ПустаяСсылка();
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		// Транши
		Объект.СтатьяДДСПоступленияВыдачи = Выборка.СтатьяДДСПоступленияВыдачи;
		
		// Оплаты
		Объект.СтатьяДДСОсновногоДолга = Выборка.СтатьяДДСОсновногоДолга;
		Объект.СтатьяДДСПроцентов = Выборка.СтатьяДДСПроцентов;
		Объект.СтатьяДДСКомиссии = Выборка.СтатьяДДСКомиссии;
		
		// Начисления
		Объект.СтатьяДоходовРасходовПроцентов = Выборка.СтатьяДоходовРасходовПроцентов;
		Объект.СтатьяДоходовРасходовКомиссии = Выборка.СтатьяДоходовРасходовКомиссии;
		
	Иначе
		
		// Транши
		Объект.СтатьяДДСПоступленияВыдачи = ПустаяСтатьяДДС;
		
		// Оплаты
		Объект.СтатьяДДСОсновногоДолга = ПустаяСтатьяДДС;
		Объект.СтатьяДДСПроцентов = ПустаяСтатьяДДС;
		Объект.СтатьяДДСКомиссии = ПустаяСтатьяДДС;
		
		// Начисления
		Если ДоговорХарактер = Перечисления.ХарактерДоговораКредитовИДепозитов.КредитИлиЗайм Тогда
			Объект.СтатьяДоходовРасходовПроцентов = ПустаяСтатьяРасходов;
			Объект.СтатьяДоходовРасходовКомиссии = ПустаяСтатьяРасходов;
		Иначе
			Объект.СтатьяДоходовРасходовПроцентов = ПустаяСтатьяДоходов;
			Объект.СтатьяДоходовРасходовКомиссии = ПустаяСтатьяДоходов;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокФормы()
	
	Если Объект.ХарактерДоговора = Перечисления.ХарактерДоговораКредитовИДепозитов.КредитИлиЗайм Тогда
		ПредставлениеТипа = НСтр("ru='Условия кредита или займа';uk='Умови кредиту або позики'");
	ИначеЕсли Объект.ХарактерДоговора = Перечисления.ХарактерДоговораКредитовИДепозитов.Депозит Тогда
		ПредставлениеТипа = НСтр("ru='Условия депозита';uk='Умови депозиту'");
	ИначеЕсли Объект.ХарактерДоговора = Перечисления.ХарактерДоговораКредитовИДепозитов.ЗаймВыданный Тогда
		ПредставлениеТипа = НСтр("ru='Условия выдачи займа';uk='Умови видачі позики'");
	Иначе
		ПредставлениеТипа = НСтр("ru='Договор с контрагентом';uk='Договір з контрагентом'");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЭтаФорма.Заголовок = ПредставлениеТипа + НСтр("ru=' (создание)';uk=' (створення)'");
	Иначе
		ЭтаФорма.Заголовок = Объект.Наименование + " (" + ПредставлениеТипа + ")";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступностьСервер()
	
	УстановитьДоступностьПоГрафикуСервер();
	УстановитьДоступностьСтавкиПроцентовСервер();
	ДатаСрокиГрафикаПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеГрафиковСервер(ДоговорСсылка)
	
	// Обновим процентную ставку
	ИсторияСтавок = РегистрыСведений.ПроцентныеСтавкиКредитовИДепозитов.СрезПоследних(ТекущаяДата(), Новый Структура("Договор", ДоговорСсылка));
	СтавкиДоговора = Новый Структура("Процент,Комиссия", 0,0);
	Если ИсторияСтавок.Количество() > 0 Тогда
		СтавкиДоговора.Процент = ИсторияСтавок[0].Процент;
		СтавкиДоговора.Комиссия = ИсторияСтавок[0].Комиссия;
	КонецЕсли;
	
	// Обновим данные графика
	ИтогиГрафика = Справочники.ВариантыГрафиковКредитовИДепозитов.ИтогиГрафика(ДоговорСсылка);
	Сроки = Новый Структура("ДатаПервогоТранша, ДатаПоследнегоПлатежа,СрокМес,СрокДней", ИтогиГрафика.ДатаПервогоТранша, ИтогиГрафика.ДатаПоследнегоПлатежа, 0, 0);
	Справочники.ВариантыГрафиковКредитовИДепозитов.ПересчитатьСроки(Сроки);
	
	Возврат Новый Структура("СтавкиДоговора, ИтогиГрафика, Сроки",СтавкиДоговора,ИтогиГрафика,Сроки);
	
КонецФункции

&НаСервере
Процедура ОбновитьДанныеГрафиковСервер()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ДанныеГрафиков = ПолучитьДанныеГрафиковСервер(Объект.Ссылка);
		ЭтаФорма.СтавкаПроцентов = ДанныеГрафиков.СтавкиДоговора.Процент;
		ЭтаФорма.Комиссия = ДанныеГрафиков.СтавкиДоговора.Комиссия;
		
		УстановитьПараметрыГрафика(ДанныеГрафиков.ИтогиГрафика);
		УстановитьПараметрыГрафика(ДанныеГрафиков.Сроки);
		
	КонецЕсли;// ссылка существует
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыГрафика(ПараметрыГрафика)
	
	Для Каждого Параметр Из ПараметрыГрафика Цикл
		Если ЗначениеЗаполнено(Параметр.Значение) Тогда
			Если Объект.Свойство(Параметр.Ключ) Тогда
				Объект[Параметр.Ключ] = Параметр.Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	ПанельКассаСчет = ЭтаФорма.Элементы.ПанельКассаСчет;
	Если Объект.ФормаОплаты = Перечисления.ФормыОплаты.Наличная Тогда
		
		ПанельКассаСчет.ТекущаяСтраница = Элементы.ГруппаКасса;
		ПанельКассаСчет.ТекущаяСтраница.Видимость = Истина;
		Элементы.ДопСчетаРасчетов.Видимость = Ложь;
		Элементы.БанковскийСчетКонтрагента.Видимость = Ложь;
		ЗаполнитьКассуПоУмолчанию(Объект.Организация, Объект.Касса, Объект.ВалютаВзаиморасчетов);
		
	Иначе
		
		ПанельКассаСчет.ТекущаяСтраница = Элементы.ГруппаСчет;
		ПанельКассаСчет.ТекущаяСтраница.Видимость = Истина;
		Элементы.ДопСчетаРасчетов.Видимость = Истина;
		Элементы.БанковскийСчетКонтрагента.Видимость = Истина;
		ЗаполнитьБанковскийСчетПоУмолчанию(Объект.Организация, Объект.ПорядокОплаты, Объект.БанковскийСчет);
		
	КонецЕсли;
	
	Если Объект.ТипКомиссии = Перечисления.ТипыКомиссииКредитовИДепозитов.Нет 
		ИЛИ Объект.ТипКомиссии = Перечисления.ТипыКомиссииКредитовИДепозитов.ПроизвольныйГрафик Тогда
		Элементы.ГруппаСуммаКомиссии.ТекущаяСтраница = Элементы.СтраницаБезСуммыКомисии;
		Комиссия = 0;
	Иначе
		Элементы.ГруппаСуммаКомиссии.ТекущаяСтраница = Элементы.СтраницаСуммыКомиссии;
	КонецЕсли;
	
	ЕстьКомиссия = Объект.ТипКомиссии <> Перечисления.ТипыКомиссииКредитовИДепозитов.Нет;
	Элементы.СтатьяДДСКомиссии.Видимость = ЕстьКомиссия;
	Элементы.СтатьяДоходовРасходовКомиссии.Видимость = ЕстьКомиссия;
	
	ЭлементФормы = Элементы.НаправлениеДеятельности;
	ХарактерыДоговоров = Перечисления.ХарактерДоговораКредитовИДепозитов;
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Статус", Перечисления.СтатусыНаправленияДеятельности.Используется));
	// Для кредитов и займов полученных указываем затратные направления
	Если Объект.ХарактерДоговора = ХарактерыДоговоров.КредитИлиЗайм Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.УчетЗатрат", Истина));
		ЭлементФормы.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьУчетЗатратПоНаправлениямДеятельности");
		ЭлементФормы.АвтоОтметкаНезаполненного = ЗначениеНастроекПовтИсп.УказыватьНаправлениеВЗатратах();
	Иначе// доходные направления
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.УчетДоходов", Истина));
		ЭлементФормы.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоходовПоНаправлениямДеятельности");
		ЭлементФормы.АвтоОтметкаНезаполненного = ЗначениеНастроекПовтИсп.УказыватьНаправлениеВДоходах();
	КонецЕсли;
	Элементы.НаправлениеДеятельности.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	ЭлементФормы.ОтметкаНезаполненного = ЭлементФормы.АвтоОтметкаНезаполненного И НЕ ЗначениеЗаполнено(Объект.НаправлениеДеятельности);
	
	УстановитьДоступностьПоДепозиту();
	ПартнерыИКонтрагенты.ЗаголовокЭлементаПарнерВЗависимостиОтХарактераДоговораКредитаИДепозита(ЭтотОбъект, "Партнер", Объект.ХарактерДоговора);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьПоГрафикуСервер()
	
	МассивЭлементов = Новый Массив();
	
	МассивЭлементов.Добавить("ДатаПервогоТранша");
	МассивЭлементов.Добавить("СуммаТраншей");
	МассивЭлементов.Добавить("ДатаПоследнегоПлатежа");
	МассивЭлементов.Добавить("СрокМес");
	МассивЭлементов.Добавить("СрокДней");
	МассивЭлементов.Добавить("СуммаКомиссии");
	МассивЭлементов.Добавить("СуммаПроцентов");
	
	ВариантГрафика = Справочники.ВариантыГрафиковКредитовИДепозитов.ТекущийВариантГрафика(Объект.Ссылка);
	Если ВариантГрафика.Пустая() Тогда
		ТекстИспользуемыйГрафик = "<Ввести>";
		ПросмотрПараметровГрафика = Ложь;
	Иначе
		ТекстИспользуемыйГрафик = ВариантГрафика.Наименование;
		ПросмотрПараметровГрафика = Истина;
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "ТолькоПросмотр", ПросмотрПараметровГрафика);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьСтавкиПроцентовСервер()
	
	// Настроим отображение ставки процентов и комиссии
	МассивЭлементов = Новый Массив();
	МассивЭлементов.Добавить("СтавкаПроцентов");
	МассивЭлементов.Добавить("ТипКомиссии");
	МассивЭлементов.Добавить("Комиссия");
	
	ЕстьИстория = Ложь;
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЕстьИстория = РегистрыСведений.ПроцентныеСтавкиКредитовИДепозитов.ЕстьИстория(Объект.Ссылка);
	КонецЕсли;
	
	РеквизитыЗаблокированы = Элементы.ХарактерДоговора.ТолькоПросмотр;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "ТолькоПросмотр", ЕстьИстория ИЛИ РеквизитыЗаблокированы);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИзменитьСтавкуПроцентов", "Видимость", ЕстьИстория ИЛИ РеквизитыЗаблокированы);
	КонецЕсли;
	
	УстановитьДоступностьПоДепозиту();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьПоДепозиту()
	
	ЭтоДепозит = Объект.ХарактерДоговора = Перечисления.ХарактерДоговораКредитовИДепозитов.Депозит;
	Элементы.ФормаОплаты.ТолькоПросмотр = ЭтоДепозит;
	Элементы.ТипКомиссии.ТолькоПросмотр = ЭтоДепозит;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТипДоговора()
	
	Элементы.ГруппаСтатьиДоходаРасхода.Заголовок = НСтр("ru='Статьи';uk='Статті'")+ " " + Справочники.ДоговорыКредитовИДепозитов.ТипСтатьи(Объект.ХарактерДоговора);
	Если Объект.ХарактерДоговора = Перечисления.ХарактерДоговораКредитовИДепозитов.КредитИлиЗайм Тогда
		Элементы.СтатьяДДСПоступления.Заголовок = НСтр("ru='Поступление';uk='Надходження'");
	Иначе
		Элементы.СтатьяДДСПоступления.Заголовок = НСтр("ru='Выплата';uk='Виплата'");
	КонецЕсли;
	
	СписокВыбора = Элементы.ТипДоговора.СписокВыбора;
	СписокВыбора.Очистить();
	
	Элементы.СтатьяДоходовРасходовПроцентов.ОграничениеТипа = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиДоходов");
	Элементы.СтатьяДоходовРасходовКомиссии.ОграничениеТипа = Элементы.СтатьяДоходовРасходовПроцентов.ОграничениеТипа;
	Если Объект.ХарактерДоговора = Перечисления.ХарактерДоговораКредитовИДепозитов.КредитИлиЗайм Тогда
		
		Элементы.СтатьяДоходовРасходовПроцентов.ОграничениеТипа = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиРасходов");
		Элементы.СтатьяДоходовРасходовКомиссии.ОграничениеТипа = Элементы.СтатьяДоходовРасходовПроцентов.ОграничениеТипа;
		СписокВыбора.Добавить(Перечисления.ТипыДоговораКредитовИДепозитов.КредитВБанке);
		СписокВыбора.Добавить(Перечисления.ТипыДоговораКредитовИДепозитов.ВнешнийЗайм);
		СписокВыбора.Добавить(Перечисления.ТипыДоговораКредитовИДепозитов.ВнутреннийЗайм);
		СписокВыбора.Добавить(Перечисления.ТипыДоговораКредитовИДепозитов.ВкладСотрудника);
		
	ИначеЕсли Объект.ХарактерДоговора = Перечисления.ХарактерДоговораКредитовИДепозитов.Депозит Тогда
		
		СписокВыбора.Добавить(Перечисления.ТипыДоговораКредитовИДепозитов.ДепозитВБанке);
		СписокВыбора.Добавить(Перечисления.ТипыДоговораКредитовИДепозитов.ДепозитВБанкеСКапитализацией);
		
	ИначеЕсли Объект.ХарактерДоговора = Перечисления.ХарактерДоговораКредитовИДепозитов.ЗаймВыданный Тогда
		
		СписокВыбора.Добавить(Перечисления.ТипыДоговораКредитовИДепозитов.ВнешнийЗайм);
		СписокВыбора.Добавить(Перечисления.ТипыДоговораКредитовИДепозитов.ВнутреннийЗайм);
		
	КонецЕсли;
	
	Если СписокВыбора.НайтиПоЗначению(Объект.ТипДоговора) = Неопределено Тогда
		Объект.ТипДоговора = СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьГруппыФинансовогоУчетаДенежныхСредств()

	Элементы.ГруппаФинансовогоУчетаДенежныхСредств.Видимость = Объект.ХарактерДоговора = Перечисления.ХарактерДоговораКредитовИДепозитов.Депозит;

КонецПроцедуры

&НаКлиенте
Процедура СнятиеБлокировкиРеквизитов(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	УстановитьДоступностьСтавкиПроцентовСервер();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
