
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	КадровыйУчетФормыБазовый.ФормаКадровогоДокументаПриСозданииНаСервере(ЭтаФорма);
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура("ДатаСобытия", "Объект.ДатаНачала");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
		Если Параметры.Свойство("Сотрудник") И ЗначениеЗаполнено(Параметры.Сотрудник) Тогда 
			Объект.Сотрудник	= Параметры.Сотрудник;
		КонецЕсли;
		
		ЗаполнитьДанныеФормыПоОрганизации();
		ПриПолученииДанныхНаСервере();
		
	КонецЕсли;
	
	ПоказатьНадписьДней(ЭтаФорма, Объект);
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// Обработчик подсистемы "Печать".
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "Сотрудник");
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ЗаписанДокументПеренос", Новый Структура("Сотрудник, ВидОтпуска, ДатаНачала", Объект.Сотрудник, Объект.ВидОтпуска, Объект.ИсходнаяДатаНачала));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	СотрудникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	ДатыОтпускаПриИзмененииНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	ДатыОтпускаПриИзмененииНаСервере();
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
	ОбновитьНадписьРасшифровкаОстаткаОтпуска(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ПараметрыФО = Новый Структура("Организация", Объект.Организация);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

#Область ОбслуживаниеЭлементовФормы

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ЗаполнитьДанныеФормыПоОрганизации();
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	
	ОбновитьДлительностьИнтервалов();
	
	ОбновитьНадписьРасшифровкаОстаткаОтпуска(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ДатыОтпускаПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.ДатаОкончания) И ЗначениеЗаполнено(Объект.ДатаНачала) 
		И Объект.ДатаНачала <= Объект.ДатаОкончания Тогда
		ОбновитьДлительностьИнтервалов()
	Иначе
		Объект.КоличествоДней = 0;
	КонецЕсли;
	
	ПоказатьНадписьДней(ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьНадписьДней(Форма, Объект)
	Если ЗначениеЗаполнено(Объект.КоличествоДней) Тогда
		Форма.НадписьДней = "дн.";	
	Иначе
		Форма.НадписьДней = "";	
	КонецЕсли;
КонецПроцедуры	

&НаСервере
Процедура ОбновитьДлительностьИнтервалов()
	ОписаниеВидаОтпуска = Документы.Отпуск.ОписаниеВидаОтпуска(ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.Основной"));
	Объект.КоличествоДней = УчетРабочегоВремени.ДлительностьИнтервала(Объект.Сотрудник, Объект.ДатаНачала, Объект.ДатаОкончания, ОписаниеВидаОтпуска.СпособРасчетаПоКалендарнымДням, ОписаниеВидаОтпуска.ЕжегодныйОтпуск);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьНадписьРасшифровкаОстаткаОтпуска(Форма)
	Если ЗначениеЗаполнено(Форма.Объект.Сотрудник) Тогда
		Форма.РасшифровкаОстаткаОтпуска = НСтр("ru='Как сотрудник использовал отпуск?';uk='Як працівник використав відпустку?'");
	Иначе
		Форма.РасшифровкаОстаткаОтпуска = "";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаОстаткаОтпускаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Справочник.Сотрудники", "СправкаПоОтпускамСотрудника",
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Сотрудник), ЭтаФорма,
		Новый Структура("ДатаОстатков, ЭтоРасчетПриУвольнении", Объект.ДатаНачала, Ложь));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли; 
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Объект.Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "Объект.ДолжностьРуководителя");
	
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
