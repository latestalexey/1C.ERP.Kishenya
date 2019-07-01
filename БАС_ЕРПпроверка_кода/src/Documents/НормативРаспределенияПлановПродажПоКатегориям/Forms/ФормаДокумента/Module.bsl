&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	Элементы.НормативыПоРеквизитамЗагрузитьНормативыИзФайла.Доступность = НЕ ЭтаФорма.ТолькоПросмотр;
	Элементы.НормативыПоСвойствамЗагрузитьНормативыИзФайла.Доступность = НЕ ЭтаФорма.ТолькоПросмотр;
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, СтандартнаяОбработка, Отказ);
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТоварнаяКатегорияПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.ТоварнаяКатегория) Тогда
	
		Элементы.Реквизит.Доступность = Истина;
		ТоварнаяКатегорияПриИзмененииНаСервере();
	
	Иначе
	
		Элементы.Реквизит.Доступность = Ложь;
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Объект.Реквизит = ВыбранноеЗначение 
		ИЛИ Объект.Операция = ПредопределенноеЗначение("Перечисление.ОперацииНормативовРаспределения.БлокировкаНорматива") Тогда
		Объект.Реквизит = ВыбранноеЗначение;
		Возврат;
	КонецЕсли;
	
	Если Объект.НормативыПоРеквизитам.Количество() > 0 ИЛИ Объект.НормативыПоСвойствам.Количество() > 0 Тогда
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Очистить и продолжить';uk='Очистити і продовжити'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена';uk='Відмінити'"));
		
		ДополнительныеПараметры = Новый Структура("ВыбранноеЗначение", ВыбранноеЗначение);
		
		Оповещение = Новый ОписаниеОповещения("РеквизитОбработкаВыбораЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, НСтр("ru='При изменении ""Реквизита"" нормативы будут очищены. Продолжить?';uk='При зміні ""Реквізиту"" нормативи будуть очищені. Продовжити?'"), Кнопки);
	
	Иначе
		
		ДополнительныеПараметры = Новый Структура("ВыбранноеЗначение", ВыбранноеЗначение);
		РеквизитОбработкаВыбораЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитОбработкаВыбораЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Реквизит = ДополнительныеПараметры.ВыбранноеЗначение;
	
	Объект.НормативыПоРеквизитам.Очистить();
	Объект.НормативыПоСвойствам.Очистить();
	
	Если ТипЗнч(Объект.Реквизит) = Тип("Строка") Тогда
		
		Объект.ВариантЗаполнения = 0;
		
		СтруктураРеквизита = Неопределено;
		СтруктураРеквизитов.Свойство(Объект.Реквизит, СтруктураРеквизита);
		
		Если СтруктураРеквизита = Неопределено Тогда
			
			ОписаниеТипов = Новый ОписаниеТипов("Неопределено");
			Элементы.НормативыПоРеквизитамЗначение.ОграничениеТипа = ОписаниеТипов;
			
		Иначе
			
			ОписаниеТипов = Новый ОписаниеТипов(СтруктураРеквизита.ТипРеквизита);
			Элементы.НормативыПоРеквизитамЗначение.ОграничениеТипа = ОписаниеТипов;
			
		КонецЕсли; 
		
	Иначе
		
		Объект.ВариантЗаполнения = 1;
		Если ХарактеристикиИспользуются Тогда
			
			Объект.ВариантЗаполнения = ВариантЗаполнения(Объект.ТоварнаяКатегория, Объект.Реквизит);
			
		КонецЕсли; 
	КонецЕсли; 
	
	УстановитьВидимостьПоРеквизиту(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтаФорма, "Объект.Комментарий");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыНормативыПоРеквизитам

&НаКлиенте
Процедура НормативыПоРеквизитамЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ТипЗнч(Объект.Реквизит) = Тип("Строка") Тогда
		
		СтруктураРеквизита = Неопределено;
		СтруктураРеквизитов.Свойство(Объект.Реквизит, СтруктураРеквизита);
		
		Если СтруктураРеквизита = Неопределено Тогда
		
			ОписаниеТипов = Новый ОписаниеТипов("Неопределено");
			Элементы.НормативыПоРеквизитамЗначение.ОграничениеТипа = ОписаниеТипов;
		
		Иначе
		
			ОписаниеТипов = Новый ОписаниеТипов(СтруктураРеквизита.ТипРеквизита);
			Элементы.НормативыПоРеквизитамЗначение.ОграничениеТипа = ОписаниеТипов;
			
			Если НЕ ОписаниеТипов.СодержитТип(ТипЗнч(Элементы.НормативыПоРеквизитам.ТекущиеДанные.Значение)) Тогда
			
				Элементы.НормативыПоРеквизитам.ТекущиеДанные.Значение = ОписаниеТипов.ПривестиЗначение(Неопределено);
			
			КонецЕсли;
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты


&НаКлиенте
Процедура ЗаполнитьВсеЗначения(Команда)
	
	Если НЕ ПроверкаЗаполненияШапки() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ТипЗнч(Объект.Реквизит) = Тип("Строка") Тогда
		
		СтруктураРеквизита = Неопределено;
		СтруктураРеквизитов.Свойство(Объект.Реквизит, СтруктураРеквизита);
		
		Если СтруктураРеквизита = Неопределено Тогда
		
			Возврат;
		
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьВсеЗначенияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоИспользованнымВНоменклатуре(Команда)
	
	Если НЕ ПроверкаЗаполненияШапки() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ТипЗнч(Объект.Реквизит) = Тип("Строка") Тогда
		
		СтруктураРеквизита = Неопределено;
		СтруктураРеквизитов.Свойство(Объект.Реквизит, СтруктураРеквизита);
		
		Если СтруктураРеквизита = Неопределено Тогда
		
			Возврат;
		
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьПоИспользованнымВНоменклатуреНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоСтатистикеПродаж(Команда)
	
	Если НЕ ПроверкаЗаполненияШапки() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьПоСтатистикеПродажЗавершение",ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВариантЗаполнения", Объект.ВариантЗаполнения);
	ПараметрыФормы.Вставить("Реквизит", Объект.Реквизит);
	ПараметрыФормы.Вставить("ПорядокДолейРаспределения", Объект.ПорядокДолейРаспределения);
	
	ОткрытьФорму("Документ.НормативРаспределенияПлановПродажПоКатегориям.Форма.ФормаПериода",
		ПараметрыФормы,
		ЭтаФорма,
		УникальныйИдентификатор,
		,
		,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

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
Процедура ЗагрузитьНормативыИзФайла(Команда)
	
	Если НЕ ПроверкаЗаполненияШапки() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗагрузки = ЗагрузкаДанныхИзФайлаКлиент.ПараметрыЗагрузкиДанных();
	Если ТипЗнч(Объект.Реквизит) = Тип("Строка") Тогда
		ПараметрыЗагрузки.ПолноеИмяТабличнойЧасти = "НормативРаспределенияПлановПродажПоКатегориям.НормативыПоРеквизитам";
	Иначе
		ПараметрыЗагрузки.ПолноеИмяТабличнойЧасти = "НормативРаспределенияПлановПродажПоКатегориям.НормативыПоСвойствам";
	КонецЕсли;
	ПараметрыЗагрузки.Заголовок = НСтр("ru='Загрузка нормативов распределения из файла';uk='Завантаження нормативів розподілу з файлу'");
	ПараметрыЗагрузки.ДополнительныеПараметры =  Новый Структура;
	ПараметрыЗагрузки.ДополнительныеПараметры.Вставить("ТоварнаяКатегория", Объект.ТоварнаяКатегория);
	ПараметрыЗагрузки.ДополнительныеПараметры.Вставить("Реквизит", Объект.Реквизит);
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьНормативыИзФайлаЗавершение", ЭтотОбъект);
	ЗагрузкаДанныхИзФайлаКлиент.ПоказатьФормуЗагрузки(ПараметрыЗагрузки, Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НормативыПоРеквизитамЗначение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НормативыПоРеквизитам.Значение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<Пустое значение>';uk='<Порожнє значення>'"));
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НормативыПоСвойствамЗначение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НормативыПоСвойствам.Значение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<Пустое значение>';uk='<Порожнє значення>'"));
	
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	ХарактеристикиИспользуются = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	
	Если Объект.Операция = Перечисления.ОперацииНормативовРаспределения.УстановкаНорматива Тогда
	
		Элементы.Страницы.Видимость = Истина;
		Элементы.ДатаНачалаДействия.Видимость = Истина;
		Элементы.ГруппаБлокировка.Видимость = Ложь;
		Элементы.ДатаБлокировки.Видимость = Ложь;
	
	Иначе
	
		Элементы.Страницы.Видимость = Ложь;
		Элементы.ДатаНачалаДействия.Видимость = Ложь;
		Элементы.ГруппаБлокировка.Видимость = Истина;
		Элементы.ДатаБлокировки.Видимость = Истина;
	
	КонецЕсли;
	
	ЗаполнитьСписокРеквизитов();
	
	РеквизитДоИзменения = Объект.Реквизит;
	
	УстановитьВидимостьПоРеквизиту(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ТоварнаяКатегорияПриИзмененииНаСервере()
	
	ЗаполнитьСписокРеквизитов();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокРеквизитов()

	СтруктураРеквизитов = Документы.НормативРаспределенияПлановПродажПоКатегориям.ПолучитьРеквизитыДляНормативов();
	
	Элементы.Реквизит.СписокВыбора.Очистить();
	Для каждого КлючЗначение Из СтруктураРеквизитов Цикл
		Элементы.Реквизит.СписокВыбора.Добавить(КлючЗначение.Ключ, КлючЗначение.Значение.Представление);
	КонецЦикла; 
	
	СписокДопРеквизитов = Документы.НормативРаспределенияПлановПродажПоКатегориям.ПолучитьДополнительныеРеквизитыДляНормативов(Объект.ТоварнаяКатегория);
	
	Для каждого ЭлементСписка Из СписокДопРеквизитов Цикл
		Элементы.Реквизит.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
	КонецЦикла;

КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьВсеЗначенияНаСервере()
	
	Если ТипЗнч(Объект.Реквизит) = Тип("Строка") Тогда
		
		СтруктураРеквизита = Неопределено;
		СтруктураРеквизитов.Свойство(Объект.Реквизит, СтруктураРеквизита);
		
		Если СтруктураРеквизита = Неопределено Тогда
			
			Возврат;
			
		КонецЕсли;
		
		Нормативы = Объект.НормативыПоРеквизитам;
		
	Иначе
	
		Нормативы = Объект.НормативыПоСвойствам;
		
	КонецЕсли; 
	
	Документы.НормативРаспределенияПлановПродажПоКатегориям.ЗаполнитьТаблицуНормативовВсемиЗначениями(
		Нормативы, 
		Объект.ТоварнаяКатегория, 
		Объект.Реквизит, 
		Объект.ДатаНачалаДействия);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоИспользованнымВНоменклатуреНаСервере()
	
	Если ТипЗнч(Объект.Реквизит) = Тип("Строка") Тогда
		
		СтруктураРеквизита = Неопределено;
		СтруктураРеквизитов.Свойство(Объект.Реквизит, СтруктураРеквизита);
		
		Если СтруктураРеквизита = Неопределено Тогда
			
			Возврат;
			
		КонецЕсли;
		
		Нормативы = Объект.НормативыПоРеквизитам;
		
	Иначе
	
		Нормативы = Объект.НормативыПоСвойствам;
		
	КонецЕсли; 
	
	Документы.НормативРаспределенияПлановПродажПоКатегориям.ЗаполнитьТаблицуНормативовЗначениямиИспользованнымиВНоменклатуре(
		Нормативы, 
		Объект.ТоварнаяКатегория, 
		Объект.Реквизит, 
		Объект.ВариантЗаполнения, 
		Объект.ДатаНачалаДействия);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоСтатистикеПродажЗавершение(Настройки, ДополнительныеПараметры) Экспорт
	
	Если Настройки <> Неопределено Тогда
		
		Объект.ПорядокДолейРаспределения = Настройки.ПорядокДолейРаспределения;
		
		Настройки.Вставить("Свойство",          Объект.Реквизит);
		Настройки.Вставить("Реквизит",          Объект.Реквизит);
		Настройки.Вставить("ТоварнаяКатегория", Объект.ТоварнаяКатегория);
		
		Результат = ЗаполнитьПоСтатистикеПродажНаСервере(Настройки);
		
		Если НЕ Результат.ЗаданиеВыполнено Тогда
			ИдентификаторЗадания = Результат.ИдентификаторЗадания;
			АдресХранилища       = Результат.АдресХранилища;
			
			ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
			ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		Иначе
			ПолучитьРезультатЗаполненияНаСервере();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

//Унифицированная процедура проверки выполнения фонового задания
&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ПолучитьРезультатЗаполненияНаСервере();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал,
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Функция ЗаполнитьПоСтатистикеПродажНаСервере(ПараметрыЗадания)
	
	ПараметрыЗадания.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыЗадания.Вставить("КлючОбщихНастроек",       "Документ.НормативРаспределенияПлановПродажПоКатегориям");
	
	Настройки = Новый Структура;
	Настройки.Вставить("ПользовательскиеНастройки",  ПолучитьИзВременногоХранилища(ПараметрыЗадания.АдресПользовательскихНастроек));
	ПараметрыЗадания.Удалить("АдресПользовательскихНастроек");
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ПараметрыЗадания.КлючОбщихНастроек, "НастройкиФоновогоЗадания_"+ПараметрыЗадания.УникальныйИдентификатор, Настройки);
	
	НаименованиеЗадания = НСтр("ru='Заполнение нормативов распределения по статистике продаж';uk='Заповнення нормативів розподілу за статистикою продажів'");
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"Документы.НормативРаспределенияПлановПродажПоКатегориям.РассчитатьНормативыПоСтатистикеПродаж",
		ПараметрыЗадания,
		НаименованиеЗадания);
	
	АдресХранилища = Результат.АдресХранилища;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьРезультатЗаполненияНаСервере()
	
	ТаблицаНормативов = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если Объект.ВариантЗаполнения = 1 ИЛИ Объект.ВариантЗаполнения = 2 Тогда
	
		Объект.НормативыПоСвойствам.Загрузить(ТаблицаНормативов);
	
	Иначе
	
		Объект.НормативыПоРеквизитам.Загрузить(ТаблицаНормативов);
	
	КонецЕсли; 
	
	
КонецФункции

&НаСервереБезКонтекста
Функция ВариантЗаполнения(ТоварнаяКатегория, Реквизит)

	Возврат Документы.НормативРаспределенияПлановПродажПоКатегориям.ВариантЗаполнения(ТоварнаяКатегория, Реквизит);

КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьПоРеквизиту(Форма)

	Если ТипЗнч(Форма.Объект.Реквизит) = Тип("Строка") Тогда
		
		Форма.Элементы.Страницы.ТекущаяСтраница = Форма.Элементы.СтраницаНормативыПоРеквизитам;
		
	Иначе
		
		Форма.Элементы.Страницы.ТекущаяСтраница = Форма.Элементы.СтраницаНормативыПоСвойствам;
	
	КонецЕсли; 
	
	Если Форма.Объект.ВариантЗаполнения = 2 Тогда
	
		Заголовок = НСтр("ru='По использованным в Характеристиках';uk='За використаними в Характеристиках'");
	
	Иначе
	
		Заголовок = НСтр("ru='По использованным в Номенклатуре';uk='За використаними у Номенклатурі'");
	
	КонецЕсли; 
	
	Форма.Элементы.НормативыПоСвойствамЗаполнитьПоИспользованнымВНоменклатуре.Заголовок = Заголовок;
	
КонецПроцедуры 

&НаКлиенте
Функция ПроверкаЗаполненияШапки()

	Результат = Истина;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаНачалаДействия) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Поле ""Дата начала действия"" не заполнено';uk='Поле ""Дата початку дії"" не заповнено'"),
			Объект.Ссылка,
			"ДатаНачалаДействия",
			"Объект");
		Результат = Ложь;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ТоварнаяКатегория) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Поле ""Товарная категория"" не заполнено';uk='Поле ""Товарна категорія"" не заповнено'"),
			Объект.Ссылка,
			"ТоварнаяКатегория",
			"Объект");
		Результат = Ложь;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Реквизит) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Поле ""Реквизит"" не заполнено';uk='Поле ""Реквізит"" не заповнено'"),
			Объект.Ссылка,
			"Реквизит",
			"Объект");
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции 

&НаКлиенте
Процедура ЗагрузитьНормативыИзФайлаЗавершение(АдресЗагруженныхДанных, ДополнительныеПараметры) Экспорт
	
	Если АдресЗагруженныхДанных = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЗагрузитьНормативыИзФайлаНаСервере(АдресЗагруженныхДанных);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНормативыИзФайлаНаСервере(АдресЗагруженныхДанных)
	
	ЗагруженныеДанные = ПолучитьИзВременногоХранилища(АдресЗагруженныхДанных);
	
	СтрокиДобавлены = Ложь;
	Для каждого СтрокаТаблицы Из ЗагруженныеДанные Цикл 
		
		Если ТипЗнч(Объект.Реквизит) = Тип("Строка") Тогда
			НоваяСтрока = Объект.НормативыПоРеквизитам.Добавить();
		Иначе
			НоваяСтрока = Объект.НормативыПоРеквизитам.Добавить();
		КонецЕсли;
		НоваяСтрока.Значение = СтрокаТаблицы.Значение;
		НоваяСтрока.ДоляРаспределения = СтрокаТаблицы.ДоляРаспределения;
		СтрокиДобавлены = Истина;

	КонецЦикла;
	
	Если СтрокиДобавлены Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти





 
