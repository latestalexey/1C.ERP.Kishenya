#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;

	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьДоступностьЭлементовОбщееСервер();
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПокупкаПродажаВалюты", ПараметрыЗаписи, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)
	
	ХозяйственнаяОперацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаГривневаяПриИзменении(Элемент)
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаКомиссионныеПриИзменении(Элемент)
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПенсионныйПриИзменении(Элемент)
	
	Объект.СуммаДокумента = Объект.СуммаГривневая + Объект.СуммаКомиссионные + Объект.СуммаПенсионный;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	ФинансыКлиент.СтатьяРасходовПриИзменении(Объект, Элементы);
		
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	Если Объект.СтатьяРасходов.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации") Тогда
		Объект.АналитикаРасходов = Объект.Организация;	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Изменить(Команда)
	
	УстановитьДоступностьЭлементовОбщееСервер(Ложь);

КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

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

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры


#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ХозяйственнаяОперацияПриИзмененииСервер()
	
	РассчитатьСуммуДокумента();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСуммуДокумента()
	
	СтавкаНалогов = РегистрыСведений.ПараметрыНалоговогоУчета.ПолучитьСтавкуПФ(Объект.Дата);
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПокупкаВалюты Тогда
		Объект.СуммаПенсионный = Объект.СуммаГривневая*СтавкаНалогов;
		Объект.СуммаДокумента = Объект.СуммаГривневая + Объект.СуммаКомиссионные + Объект.СуммаПенсионный;
	Иначе	
		Если Объект.СуммаПенсионный <> 0 Тогда
			Объект.СуммаПенсионный = 0;
		КонецЕсли;
		Объект.СуммаДокумента = Объект.СуммаГривневая - Объект.СуммаКомиссионные;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Элементы.СуммаПенсионный.Видимость = (Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПокупкаВалюты);
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПокупкаВалюты Тогда
		Элементы.Валюта.Заголовок = НСтр("ru='Покупаемая валюта';uk='Валюта, що купується'");
	Иначе
		Элементы.Валюта.Заголовок = НСтр("ru='Продаваемая валюта';uk='Валюта, яка продається'");
	КонецЕсли;
	
	ЭтаФорма.ТолькоПросмотр = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	УправлениеЭлементамиФормы();
	УстановитьДоступностьЭлементовОбщееСервер();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементовОбщееСервер(ТолькоПросмотрЭлементов = Неопределено)
	
	Если ТолькоПросмотрЭлементов = Неопределено Тогда
		ТолькоПросмотрЭлементов = Объект.Проведен;
	КонецЕсли;

	МассивЭлементов = Новый Массив();
	
	// Элементы управления шапки
	МассивЭлементов.Добавить("Дата");
	МассивЭлементов.Добавить("ХозяйственнаяОперация");
	МассивЭлементов.Добавить("Организация");
	МассивЭлементов.Добавить("Заявка");
	МассивЭлементов.Добавить("СчетВалютный");
	МассивЭлементов.Добавить("СчетГривневый");
	
	МассивЭлементов.Добавить("Банк");
	МассивЭлементов.Добавить("Подразделение");
	МассивЭлементов.Добавить("СтатьяРасходов");
	МассивЭлементов.Добавить("АналитикаРасходов");
	                          
	МассивЭлементов.Добавить("Валюта");
	МассивЭлементов.Добавить("СуммаВалютная");
	МассивЭлементов.Добавить("СуммаГривневая");
	МассивЭлементов.Добавить("СуммаКомиссионные");
	МассивЭлементов.Добавить("СуммаПенсионный");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "ТолькоПросмотр", ТолькоПросмотрЭлементов);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Изменить", "Доступность", ТолькоПросмотрЭлементов);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
