
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный, ПредыдущийМесяц", 
								"Объект.Организация", "Объект.Ответственный", "Объект.ПериодРегистрации");
		
		Если ПолучитьФункциональнуюОпцию("ВыполнятьРасчетЗарплатыПоПодразделениям") Тогда
			ЗначенияДляЗаполнения.Вставить("Подразделение", "Объект.Подразделение");
		КонецЕсли;

		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
		
		ЗаполнитьДанныеФормыПоОрганизации();
	КонецЕсли;

	
	УчетРабочегоВремениФормы.ТабельПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗаполнитьДанныеФормыПоОрганизации();
	КонецЕсли; 
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки".
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Обработчик подсистемы "Печать".
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);

	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "ДанныеОВремениСотрудник");
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	УчетРабочегоВремениФормы.ТабельПриЧтенииНаСервере(ЭтаФорма);
	
	НастроитьОтображениеГруппыПодписантов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("ПроведениеДокументаТабельУчетаРабочегоВремени");
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	УчетРабочегоВремениФормы.ТабельПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УчетРабочегоВремениФормы.ТабельПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи); 
	
	СохраняемыеЗначения = Новый Структура;
	СохраняемыеЗначения.Вставить("Исполнитель", ТекущийОбъект.Исполнитель);
	СохраняемыеЗначения.Вставить("ДолжностьИсполнителя", ТекущийОбъект.ДолжностьИсполнителя);
	
	ЗарплатаКадры.СохранитьЗначенияЗаполненияОтветственныхРаботников(ТекущийОбъект.Организация, СохраняемыеЗначения);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	УчетРабочегоВремениКлиент.ТабельОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник); 	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УчетРабочегоВремениКлиент.ТабельОрганизацияПриИзменении(ЭтаФорма);
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ПериодРегистрацииНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "МесяцРегистрацииСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	ПериодРегистрацииПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодВводаДанныхОВремениПриИзменении(Элемент)
	ПериодВводаДанныхОВремениПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПериодаПриИзменении(Элемент)
	
	Если НачалоМесяца(Объект.ДатаНачалаПериода) <> НачалоМесяца(Объект.ДатаОкончанияПериода) Тогда
		Объект.ДатаОкончанияПериода = КонецМесяца(Объект.ДатаНачалаПериода);
	КонецЕсли;
	
	ПериодРегистрацииПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПериодаПриИзменении(Элемент)
	
	Если НачалоМесяца(Объект.ДатаНачалаПериода) <> НачалоМесяца(Объект.ДатаОкончанияПериода) Тогда
		Объект.ДатаОкончанияПериода = КонецМесяца(Объект.ДатаНачалаПериода);
	КонецЕсли;
	
	ПериодРегистрацииПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцРегистрацииСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцРегистрацииСтрокой", Модифицированность);
	
	ПериодРегистрацииПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцРегистрацииСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцРегистрацииСтрокой", Направление, Модифицированность);
	
	ПериодРегистрацииПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцРегистрацииСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
	ПериодРегистрацииПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцРегистрацииСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
	ПериодРегистрацииПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ВысотаСтрокиПриИзменении(Элемент)
	УчетРабочегоВремениКлиент.ТабельВысотаСтрокиПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура РуководительПриИзменении(Элемент)
	
	НастроитьОтображениеГруппыПодписантов();
	
КонецПроцедуры

&НаКлиенте
Процедура РаботникКадровойСлужбыПриИзменении(Элемент)
	
	НастроитьОтображениеГруппыПодписантов();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	НастроитьОтображениеГруппыПодписантов();
	
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыФормыДанныеОВремени

&НаКлиенте
Процедура ДанныеОВремениПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	УчетРабочегоВремениКлиент.ТабельДанныеОВремениПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа)
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	УдалитьСтрокиПоСотруднику(Элементы.ДанныеОВремени.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаПодбораНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	УчетРабочегоВремениКлиент.ТабельДанныеОВремениПередОкончаниемРедактирования(ЭтаФорма, Элемент, НоваяСтрока, ОтменаРедактирования, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениВремяПредставлениеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	УчетРабочегоВремениКлиент.ТабельДанныеОВремениВремяПредставлениеОкончаниеВводаТекста(ЭтаФорма, Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениВремяПредставлениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	УчетРабочегоВремениКлиент.ТабельДанныеОВремениВремяПредставлениеАвтоПодбор(ЭтаФорма, Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениВремяПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	УчетРабочегоВремениКлиент.ТабельДанныеОВремениВремяПредставлениеОбработкаВыбора(ЭтаФорма, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениВремяПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УчетРабочегоВремениКлиент.ТабельДанныеОВремениПредставлениеНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, Элемент);
КонецПроцедуры

#КонецОбласти

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

// ИсправлениеДокументов
&НаКлиенте
Процедура Подключаемый_Исправить(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.Исправить(Объект.Ссылка, "ТабельУчетаРабочегоВремени");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Сторнировать(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.Сторнировать(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправлению(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправлению(ЭтаФорма.ДокументИсправление, "ТабельУчетаРабочегоВремени");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправленному(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправленному(Объект.ИсправленныйДокумент, "ТабельУчетаРабочегоВремени");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКСторно(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКСторно(ЭтаФорма.ДокументСторно);
КонецПроцедуры
// Конец ИсправлениеДокументов

&НаКлиенте
Процедура Заполнить(Команда)
	
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("ЗаполнениеДокументаТабельУчетаРабочегоВремени");	
	
	ОчиститьСообщения();
	
	ЗаполнитьСотрудникамиОрганизацииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("ПодборСотрудникаВФормеДокументаТабельУчетаРабочегоВремени");
	
	УчетРабочегоВремениКлиент.ТабельПодбор(ЭтаФорма, АдресСпискаПодобранныхСотрудников());
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	УчетРабочегоВремениКлиент.ТабельПереместитьСтрокуВверх(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	УчетРабочегоВремениКлиент.ТабельПереместитьСтрокуВниз(ЭтаФорма);
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
Процедура ОбновитьОписаниеВидовВремени() Экспорт
	УчетРабочегоВремениФормы.ТабельПоместитьОписаниеВидовВремениВДанныеФормы(ЭтаФорма);	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПодбораНаСервере(Сотрудники)
	УчетРабочегоВремениФормы.ТабельОбработкаПодбора(ЭтаФорма, Сотрудники);
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСотрудникамиОрганизацииНаСервере()
	УчетРабочегоВремениФормы.ТабельЗаполнитьСотрудникамиОрганизации(ЭтаФорма);
КонецФункции

&НаСервере
Процедура ЗаполнитьДанныеПоСотрудникуНаСервере()
	УчетРабочегоВремениФормы.ТабельЗаполнитьДанныеПоСотруднику(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОВремениСотрудникПриИзменении(Элемент)
	ЗаполнитьДанныеПоСотрудникуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПериодРегистрацииПриИзменении()
	УчетРабочегоВремениФормы.ТабельПериодРегистрацииПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПериодВводаДанныхОВремениПриИзмененииНаСервере()
	УчетРабочегоВремениФормы.ТабельПериодВводаДанныхОВремениПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура УдалитьСтрокиПоСотруднику(Знач УдаляемыеСтроки)
	Для Каждого ИдентификаторУдаляемойСтроки Из УдаляемыеСтроки Цикл
		УчетРабочегоВремениФормы.ТабельУдалитьСтрокиПоСотруднику(ЭтаФорма, ИдентификаторУдаляемойСтроки);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УстановитьВысотуСтрокНаСервере() Экспорт
	УчетРабочегоВремениФормы.ТабельУстановитьВысотуСтрокПоСотрудникам(ЭтаФорма, УстанавливаемаяВысотаСтроки);
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.ДанныеОВремени.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ЗаполнитьДанныеФормыПоОрганизации();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли; 
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	
	Если ПолучитьФункциональнуюОпцию("ВыполнятьРасчетЗарплатыПоПодразделениям") Тогда
		ЗапрашиваемыеЗначения.Вставить("Подразделение", "Объект.Подразделение");
	КонецЕсли;

	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Объект.Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "Объект.ДолжностьРуководителя");
	
	ЗапрашиваемыеЗначения.Вставить("РаботникКадровойСлужбы", "Объект.РаботникКадровойСлужбы");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРаботникаКадровойСлужбы", "Объект.ДолжностьРаботникаКадровойСлужбы");
	
	ЗапрашиваемыеЗначения.Вставить("Исполнитель", "Объект.Исполнитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьИсполнителя", "Объект.ДолжностьИсполнителя");
	
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));	
	
	НастроитьОтображениеГруппыПодписантов();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеГруппыПодписантов()
	
	ЗарплатаКадры.НастроитьОтображениеГруппыПодписей(Элементы.ПодписиГруппа, "Объект.Руководитель", "Объект.РаботникКадровойСлужбы", "Объект.Исполнитель");	
	
КонецПроцедуры	

#КонецОбласти
