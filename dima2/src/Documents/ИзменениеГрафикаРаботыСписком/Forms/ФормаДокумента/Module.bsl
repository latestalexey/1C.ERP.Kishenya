#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// Обработчик подсистемы "Печать".
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец Обработчик подсистемы "Печать".
	
	КадровыйУчетФормы.ФормаКадровогоДокументаПриСозданииНаСервере(ЭтаФорма);
	РасчетЗарплатыРасширенныйФормы.ДокументыПриСозданииНаСервере(ЭтаФорма); 
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный, ДатаСобытия",
			"Объект.Организация",
			"Объект.Ответственный",
			"Объект.ДатаИзменения");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ПриПолученииДанныхНаСервере();
		
		Объект.Дата = ТекущаяДатаСеанса();
		УстановитьОтветственныхЛиц();
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "ПоказателиСотрудниковСотрудник");
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
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("ПроведениеДокументаИзменениеГрафикаРаботыСписком");
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	РеквизитВДанные(ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Если ЗначениеЗаполнено(Объект.ИсправленныйДокумент) Тогда
		Оповестить("ИсправленДокумент", , Объект.ИсправленныйДокумент);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ДанныеВРеквизит();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьНаКлиенте", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыНачисления" И Источник = ЭтаФорма Тогда
		ЗаполнитьНачисленияИзВременногоХранилища(Параметр.АдресВХранилище);
	КонецЕсли;
	Если ИмяСобытия = "ИсправленДокумент" И Источник = Объект.Ссылка Тогда
		ДанныеВРеквизит();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_ОткрытьДокументыВведенныеПозже(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьВведенныеНаДатуДокументы(ЭтотОбъект.ДокументыВведенныеПозже);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьРанееВведенныеДокументы(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьВведенныеНаДатуДокументы(ЭтотОбъект.РанееВведенныеДокументы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ГрафикРаботыПриИзменении(Элемент)
	ГрафикРаботыПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура РуководительПриИзменении(Элемент)
	
	НастроитьОтображениеГруппыПодписантов();
	
КонецПроцедуры

&НаКлиенте
Процедура ГлавныйБухгалтерПриИзменении(Элемент)
	
	НастроитьОтображениеГруппыПодписантов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПоказателиСотрудников

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.Сотрудник) Тогда
		
		Если Поле.Имя = "ПоказателиСотрудниковФОТ" Тогда
			
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("АдресВХранилище", АдресВХранилищеНачисленийИУдержаний(ТекущиеДанные.Сотрудник));
			ПараметрыОткрытия.Вставить("ТолькоПросмотр", ТолькоПросмотр);
			
			ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуРедактированияСоставаНачисленийИУдержаний(ПараметрыОткрытия, ЭтаФорма);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиСотрудниковПриАктивизацииСтроки(Элемент)
	
	Если НЕ Элементы.ПоказателиСотрудников.ТекущиеДанные = Неопределено Тогда
		ТекущийСотрудник = Элементы.ПоказателиСотрудников.ТекущиеДанные.Сотрудник;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиСотрудниковОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ДополнитьПоказателиСотрудников(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиСотрудниковСотрудникПриИзменении(Элемент)
	ПоказателиСотрудниковСотрудникПриИзмененииНаСервере(Элементы.ПоказателиСотрудников.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиСотрудниковПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Элементы.ПоказателиСотрудников.ТекущиеДанные = Неопределено Тогда
		ТекущийСотрудник = Элементы.ПоказателиСотрудников.ТекущиеДанные.Сотрудник;
	КонецЕсли;
	
	КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиСотрудниковПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = ПоказателиСотрудников.НайтиПоИдентификатору(Элементы.ПоказателиСотрудников.ТекущаяСтрока);
	Если ТекущиеДанные.Сотрудник = ТекущийСотрудник Тогда
		УдалитьНачисленияСотрудников(ТекущийСотрудник);
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
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Команда", Команда);
		
		ТекстВопроса = НСтр("ru='Данные еще не записаны.
                |Выполнение печати возможно только после записи данных.
                |Данные будут записаны.'
                |;uk='Дані ще не записані.
                |Виконання друку можливо тільки після запису даних.
                |Дані будуть записані.'");
			
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПодключаемуюКомандуПечатиПодтверждениеЗаписи", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		Возврат;
	КонецЕсли;
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИсправлениеДокументов
&НаКлиенте
Процедура Подключаемый_Исправить(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.Исправить(Объект.Ссылка, "ИзменениеГрафикаРаботыСписком");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправлению(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправлению(ЭтаФорма.ДокументИсправление, "ИзменениеГрафикаРаботыСписком");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправленному(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправленному(Объект.ИсправленныйДокумент, "ИзменениеГрафикаРаботыСписком");
КонецПроцедуры
// Конец ИсправлениеДокументов

&НаКлиенте
Процедура ЗаполнитьПодходящихСотрудников(Команда)
	
	Если ПоказателиСотрудников.Количество() > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ЗаполнитьПодходящихСотрудниковЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru='Табличная часть будет очищена, продолжить?';uk='Таблична частина буде очищена, продовжити?'"), РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьПодходящихСотрудниковЗавершение(КодВозвратаДиалога.Да, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборСотрудников(Команда)
	
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("ПодборСотрудникаВФормеДокументаИзменениеГрафикаРаботыСписком");
	
	ПараметрыОткрытия = Неопределено;
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ГосударственнаяСлужбаКлиент");
		Модуль.УточнитьПараметрыОткрытияФормыВыбораСотрудников(ПараметрыОткрытия);
	КонецЕсли; 
		
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихВПериодеПоПараметрамОткрытияФормыСписка(
		Элементы.ПоказателиСотрудников,
		Объект.Организация,
		Объект.Подразделение,
		Объект.ДатаИзменения,
		КонецМесяца(Объект.ДатаИзменения),
		,
		АдресСпискаПодобранныхСотрудников(),
		ПараметрыОткрытия);
	
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
Процедура ПриПолученииДанныхНаСервере()
	
	ЗарплатаКадрыРасширенный.ОформлениеНесколькихДокументовНаОднуДатуДополнитьФорму(ЭтотОбъект);
	ИсправлениеДокументовЗарплатаКадры.ГруппаИсправлениеДополнитьФорму(ЭтотОбъект, Истина, Ложь);
	
	ДанныеВРеквизит();
	
КонецПроцедуры

&НаСервере
Процедура ДанныеВРеквизит()
	
	ПрочитатьВремяРегистрации();
	
	МассивСотрудников = Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник");
	
	ДополнитьФорму();
	ПоказателиСотрудников.Очистить();
	ПоказателиСотрудниковВРеквизитФормы(Объект.Сотрудники);
	ЗаполнитьФОТПоСотрудникам();
	
	ТекущиеЗначенияСовокупныхТарифныхСтавок = Документы.ИзменениеГрафикаРаботыСписком.ТекущиеЗначенияСовокупныхТарифныхСтавокСотрудников(
		Объект.Ссылка, ВремяРегистрации, МассивСотрудников);
	
	ЗначенияСовокупныхТарифныхСтавокВРеквизитФормы(Объект.ПересчетТарифныхСтавок, ТекущиеЗначенияСовокупныхТарифныхСтавок);
	
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтаФорма);
	КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения();
	НастроитьОтображениеГруппыПодписантов();
	
КонецПроцедуры

// Процедура заполняет таблицу формы в которой редактируются список сотрудников.
// Данные для заполнения берутся из Объект.Сотрудники
&НаСервере
Процедура ПоказателиСотрудниковВРеквизитФормы(Сотрудники)
	
	Если ТипЗнч(Сотрудники) = Тип("ТаблицаЗначений") Тогда
		МассивСотрудников = Сотрудники.Скопировать(, "Сотрудник").ВыгрузитьКолонку("Сотрудник");
	Иначе
		МассивСотрудников = Сотрудники.Выгрузить().ВыгрузитьКолонку("Сотрудник");
	КонецЕсли;
	
	Отбор = Новый Структура;
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, МассивСотрудников, "ДолжностьПоШтатномуРасписанию", ВремяРегистрации, , Ложь);
	Для каждого СтрокаСотрудника Из Сотрудники Цикл
		
		Отбор.Очистить();
		Отбор.Вставить("Сотрудник", СтрокаСотрудника.Сотрудник);
		Строки = ЭтаФорма["ПоказателиСотрудников"].НайтиСтроки(Отбор);
		Если Строки.Количество() > 0 Тогда
			Строка = Строки[0];
		Иначе
			Строка = ЭтаФорма["ПоказателиСотрудников"].Добавить();
			Строка["Сотрудник"] = СтрокаСотрудника.Сотрудник;
			Строка["ФиксСтрока"] = СтрокаСотрудника.ФиксСтрока;
		КонецЕсли;
		
		СтрокиДанных = КадровыеДанные.НайтиСтроки(Новый Структура("Сотрудник", СтрокаСотрудника.Сотрудник));
		Если СтрокиДанных.Количество() > 0 Тогда
			Строка.ДолжностьПоШтатномуРасписанию = СтрокиДанных[0].ДолжностьПоШтатномуРасписанию;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗначенияСовокупныхТарифныхСтавокВРеквизитФормы(ЗначенияСовокупныхТарифныхСтавок, ТекущиеЗначенияСовокупныхТарифныхСтавок);
	
	Отбор = Новый Структура;
	
	Для Каждого ДанныеСовокупныхТарифныхСтавок Из ЗначенияСовокупныхТарифныхСтавок Цикл 
		
		Отбор.Вставить("Сотрудник", ДанныеСовокупныхТарифныхСтавок.Сотрудник);
		ДанныеСотрудника = ЭтаФорма["ПоказателиСотрудников"].НайтиСтроки(Отбор);
		
		Если ДанныеСотрудника.Количество() > 0 Тогда 
			
			ДанныеСотрудника[0].СовокупнаяТарифнаяСтавка = ДанныеСовокупныхТарифныхСтавок.СовокупнаяТарифнаяСтавка;
			ДанныеСотрудника[0].ВидТарифнойСтавки = ДанныеСовокупныхТарифныхСтавок.ВидТарифнойСтавки;
			
			ТекущиеДанныеСовокупныхТарифныхСтавок = ТекущиеЗначенияСовокупныхТарифныхСтавок.НайтиСтроки(Отбор);
			
			Если ТекущиеДанныеСовокупныхТарифныхСтавок.Количество() > 0 Тогда 
				ДанныеСотрудника[0].СовокупнаяТарифнаяСтавкаТекущееЗначение = ТекущиеДанныеСовокупныхТарифныхСтавок[0].СовокупнаяТарифнаяСтавка;
				
				СуммаПодстановки = Строка(Формат(ТекущиеДанныеСовокупныхТарифныхСтавок[0].СовокупнаяТарифнаяСтавка, "ЧДЦ=2; ЧРГ="));
				СуммаПодстановки = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(СуммаПодстановки, 10, " ");
				
				ПредставлениеТекущего = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='было: %1';uk='було: %1'"), СуммаПодстановки);
				ДанныеСотрудника[0].СовокупнаяТарифнаяСтавкаТекущееЗначениеПредставление = ПредставлениеТекущего;
			КонецЕсли;
		
		КонецЕсли;
		
	КонецЦикла;
	
	ЗначенияСовокупныхТарифныхСтавок.Очистить();
	
КонецПроцедуры

// Процедура переносит отредактированный пользователем список сотрудников в Объект.Сотрудники.
&НаСервере
Процедура РеквизитВДанные(ТекущийОбъект)
	
	ТекущийОбъект.Сотрудники.Очистить();
	ТекущийОбъект.ПересчетТарифныхСтавок.Очистить();
	
	Для каждого ПоказателиСотрудника Из ЭтаФорма["ПоказателиСотрудников"] Цикл
		Строка = ТекущийОбъект.Сотрудники.Добавить();
		Строка.Сотрудник = ПоказателиСотрудника.Сотрудник;
		Строка.ФиксСтрока = ПоказателиСотрудника.ФиксСтрока;
		
		// И значения совокупных тарифных ставок.
		Строка = ТекущийОбъект.ПересчетТарифныхСтавок.Добавить();
		Строка.Сотрудник = ПоказателиСотрудника.Сотрудник;
		Строка.СовокупнаяТарифнаяСтавка = ПоказателиСотрудника.СовокупнаяТарифнаяСтавка;
		Строка.ВидТарифнойСтавки = ПоказателиСотрудника.ВидТарифнойСтавки;
	КонецЦикла;
	
	СтрокиДляУдаления = Новый Массив;
	Для каждого СтрокаНачисленияСотрудника Из ТекущийОбъект.НачисленияСотрудников Цикл
		НайденныеСтроки = ТекущийОбъект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", СтрокаНачисленияСотрудника.Сотрудник));
		Если НайденныеСтроки.Количество() = 0 Тогда
			СтрокиДляУдаления.Добавить(СтрокаНачисленияСотрудника);
		КонецЕсли;
	КонецЦикла;
	Для каждого СтрокаДляУдаления Из СтрокиДляУдаления Цикл
		ТекущийОбъект.НачисленияСотрудников.Удалить(СтрокаДляУдаления);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПодходящихСотрудниковЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПодходящихСотрудниковНаСервере();
	
КонецПроцедуры

// Процедура заполняет таблицы документа сотрудниками
// Также выполняются все сопутствующие действия: расчет ФОТ и т.п.
&НаСервере
Процедура ЗаполнитьПодходящихСотрудниковНаСервере(ВыводитьСообщения = Истина)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		ПоказателиСотрудников.Очистить();
		ПолучитьСообщенияПользователю(?(ВыводитьСообщения, Ложь, Истина));
		Возврат;
	КонецЕсли;
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьДокумент(ВремяРегистрации);
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	ДанныеВРеквизит();
	
КонецПроцедуры

#Область ФОТ

&НаСервере
Процедура ЗаполнитьФОТПоСотрудникам()
	
	Для каждого СтрокаСотрудника Из ЭтаФорма["ПоказателиСотрудников"] Цикл
		СтрокаСотрудника.ФОТ = ФОТСотрудника(СтрокаСотрудника.Сотрудник);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ФОТСотрудника(Сотрудник)
	
	НачисленияСотрудника = Объект.НачисленияСотрудников.Выгрузить(Новый Структура("Сотрудник", Сотрудник));
	
	Возврат НачисленияСотрудника.Итог("Размер");
	
КонецФункции

&НаСервере
Процедура ПересчитатьФОТИСовокупныеТарифныеСтавки()
	
	Менеджер = Документы.ИзменениеГрафикаРаботыСписком;
	
	РеквизитВДанные(Объект);
	
	ПересчитываемыеНачисления = Объект.НачисленияСотрудников;
	
	Менеджер.РассчитатьФОТ(Объект.Ссылка, Объект.Организация, ВремяРегистрации, Объект.ГрафикРаботы, ПересчитываемыеНачисления);
	
	ЗаполнитьФОТПоСотрудникам();
	
	ЗначенияСовокупныхТарифныхСтавок = Документы.ИзменениеГрафикаРаботыСписком.ЗначенияСовокупныхТарифныхСтавокСотрудников(
		Объект.НачисленияСотрудников, ВремяРегистрации, Объект.ГрафикРаботы);
	
	Для Каждого ПоказателиСотрудника Из ЭтаФорма["ПоказателиСотрудников"] Цикл
		ДанныеСовокупныхТарифныхСтавок = ЗначенияСовокупныхТарифныхСтавок.Найти(ПоказателиСотрудника.Сотрудник, "Сотрудник");
		ПоказателиСотрудника.СовокупнаяТарифнаяСтавка = ?(ДанныеСовокупныхТарифныхСтавок <> Неопределено, ДанныеСовокупныхТарифныхСтавок.СовокупнаяТарифнаяСтавка, 0);
		ПоказателиСотрудника.ВидТарифнойСтавки = ?(ДанныеСовокупныхТарифныхСтавок <> Неопределено, ДанныеСовокупныхТарифныхСтавок.ВидТарифнойСтавки, Неопределено);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеНачисленийИУдержаний(Сотрудник)
	
	ПараметрыОткрытия = ЗарплатаКадрыРасширенныйКлиентСервер.ПараметрыРедактированияСоставаНачисленийИУдержаний();
	
	ПараметрыОткрытия.ВладелецНачисленийИУдержаний = Сотрудник;
	ПараметрыОткрытия.ДатаРедактирования = ВремяРегистрации;
	ПараметрыОткрытия.Организация = Объект.Организация;
	ПараметрыОткрытия.ГрафикРаботы = Объект.ГрафикРаботы;
	ПараметрыОткрытия.РежимРаботы = 3;
	ПараметрыОткрытия.ДополнитьНедостающиеЗначенияПоказателей = Истина;
	
	МассивНачислений = Новый Массив;
	
	ТаблицаСотрудников = Новый ТаблицаЗначений;
	ТаблицаСотрудников.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	ТаблицаСотрудников.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаСотрудников.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	
	СтрокаТаблицыСотрудников = ТаблицаСотрудников.Добавить();
	СтрокаТаблицыСотрудников.Период = ВремяРегистрации;
	СтрокаТаблицыСотрудников.Организация = Объект.Организация;
	СтрокаТаблицыСотрудников.Сотрудник = Сотрудник;
	
	СтрокиНачислений = Объект.НачисленияСотрудников.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
	Для каждого СтрокаНачислений Из СтрокиНачислений Цикл
		
		СтруктураНачисления = Новый Структура("Начисление, ДокументОснование, Размер");
		ЗаполнитьЗначенияСвойств(СтруктураНачисления, СтрокаНачислений);
		МассивНачислений.Добавить(СтруктураНачисления);
		
	КонецЦикла;
	
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.Используется = Истина;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.Таблица = МассивНачислений;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ИзменятьСоставВидовРасчета = Ложь;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ИзменятьЗначенияПоказателей = Ложь;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.НомерТаблицы = 1;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ПоказатьФОТ = Истина;
	
	Возврат ПоместитьВоВременноеХранилище(ПараметрыОткрытия, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьНачисленияИзВременногоХранилища(АдресВХранилище);
	
	ДанныеИзХранилища = ПолучитьИзВременногоХранилища(АдресВХранилище);
	Сотрудник = ДанныеИзХранилища.ВладелецНачисленийИУдержаний;
	
	УдалитьНачисленияСотрудников(Сотрудник, Ложь, Ложь);
	ФОТИзменен = Ложь;
	НачисленияСотрудников = Новый Массив;
	Если ДанныеИзХранилища <> Неопределено Тогда
		Для каждого НачислениеСотрудника Из ДанныеИзХранилища.Начисления Цикл
			НоваяСтрокаНачислений = Объект.НачисленияСотрудников.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаНачислений, НачислениеСотрудника);
			НоваяСтрокаНачислений.Сотрудник = Сотрудник;
			НачисленияСотрудников.Добавить(НоваяСтрокаНачислений);
		КонецЦикла;
		ФОТИзменен = ДанныеИзХранилища.Модифицированность;
	КонецЕсли;
	
	НайденныеСтроки = ЭтаФорма["ПоказателиСотрудников"].НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
	Если НайденныеСтроки.Количество() > 0 Тогда
		НайденныеСтроки[0].ФОТ = ФОТСотрудника(Сотрудник);
		Если ФОТИзменен Тогда
			НайденныеСтроки[0].ФиксСтрока = Истина;
		КонецЕсли;
		КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения();
	КонецЕсли;
	
	ЗначенияСовокупныхТарифныхСтавок = Документы.ИзменениеГрафикаРаботыСписком.ЗначенияСовокупныхТарифныхСтавокСотрудников(
		НачисленияСотрудников, ВремяРегистрации, Объект.ГрафикРаботы);
	КоличествоСтрок = ЗначенияСовокупныхТарифныхСтавок.Количество();
	Если НайденныеСтроки.Количество() > 0 Тогда
		НайденныеСтроки[0].СовокупнаяТарифнаяСтавка = ?(КоличествоСтрок > 0, ЗначенияСовокупныхТарифныхСтавок[0].СовокупнаяТарифнаяСтавка, 0);
		НайденныеСтроки[0].ВидТарифнойСтавки = ?(КоличествоСтрок > 0, ЗначенияСовокупныхТарифныхСтавок[0].ВидТарифнойСтавки, Неопределено);
	КонецЕсли;
	
	Модифицированность = ДанныеИзХранилища.Модифицированность;
	
КонецПроцедуры

#КонецОбласти

#Область Отрисовка_формы

&НаСервере
Процедура ДополнитьФорму()
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание") Тогда
		ГруппаСотрудник = ЭтаФорма.Элементы.Найти("ГруппаСотрудник");
		ГруппаСотрудник.Заголовок = НСтр("ru='Сотрудник / Должность';uk='Співробітник / Посада'");
	КонецЕсли;
	
	Если Не ЭтаФорма.Параметры.Ключ.Пустая() Тогда
		ИсправлениеДокументовЗарплатаКадры.ПрочитатьРеквизитыИсправления(ЭтаФорма, "ПериодическиеСведения");
	КонецЕсли;
	ИсправлениеДокументовЗарплатаКадры.УстановитьПоляИсправления(ЭтаФорма, "ПериодическиеСведения");
	
КонецПроцедуры

#КонецОбласти

#Область Серверные_обработчики_событий_формы

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьОтветственныхЛиц();
	
	ЗаполнитьПодходящихСотрудниковНаСервере(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтветственныхЛиц()
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Объект.Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "Объект.ДолжностьРуководителя");
	
	ЗапрашиваемыеЗначения.Вставить("ГлавныйБухгалтер", "Объект.ГлавныйБухгалтер");
	
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));
	НастроитьОтображениеГруппыПодписантов();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеГруппыПодписантов()
	ЗарплатаКадры.НастроитьОтображениеГруппыПодписей(Элементы.ПодписиГруппа, "Объект.Руководитель", "Объект.ГлавныйБухгалтер");
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении()
	ДатаНачалаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДатаНачалаПриИзмененииНаСервере()
	
	ПрочитатьВремяРегистрации();
	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаСервере
Процедура ГрафикРаботыПриИзмененииНаСервере()
	ПересчитатьФОТИСовокупныеТарифныеСтавки();
КонецПроцедуры

&НаСервере
Процедура УдалитьНачисленияСотрудников(Сотрудник, УдалитьСотрудников = Истина, УдалитьТарифныеСтавки = Истина)
	
	СтрокиНачислений = Объект.НачисленияСотрудников.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
	Для каждого СтрокаНачислений Из СтрокиНачислений Цикл
		Объект.НачисленияСотрудников.Удалить(СтрокаНачислений);
	КонецЦикла;
	
	Если УдалитьСотрудников Тогда
		СтрокиНачислений = Объект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
		Для каждого СтрокаНачислений Из СтрокиНачислений Цикл
			Объект.Сотрудники.Удалить(СтрокаНачислений);
		КонецЦикла;
	КонецЕсли;
	
	Если УдалитьТарифныеСтавки Тогда
		СтрокиПересчета = Объект.ПересчетТарифныхСтавок.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
		Для каждого СтрокаПересчета Из СтрокиПересчета Цикл
			Объект.ПересчетТарифныхСтавок.Удалить(СтрокаПересчета);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказателиСотрудниковСотрудникПриИзмененииНаСервере(Идентификатор)
	
	ТекущиеДанные = ПоказателиСотрудников.НайтиПоИдентификатору(Идентификатор);
	НовыйСотрудник = ТекущиеДанные.Сотрудник;
	Если НовыйСотрудник <> ТекущийСотрудник Тогда
		УдалитьНачисленияСотрудников(ТекущийСотрудник);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НовыйСотрудник) Тогда
		Возврат;
	КонецЕсли;
	
	ДополнитьПоказателиСотрудников(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(НовыйСотрудник));
	
КонецПроцедуры

#КонецОбласти

#Область КлючевыеРеквизитыЗаполненияФормы

// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить("ПоказателиСотрудников");
	Массив.Добавить("Объект.Сотрудники");
	Массив.Добавить("Объект.ФизическиеЛица");
	Массив.Добавить("Объект.НачисленияСотрудников");
	Массив.Добавить("Объект.ПересчетТарифныхСтавок");
	
	Возврат Массив;
	
КонецФункции

// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация",	НСтр("ru='организации';uk='організації'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Подразделение",	НСтр("ru='подразделения';uk='підрозділи'")));
	
	Возврат Массив;
	
КонецФункции

&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения()
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	УстановитьОтображениеНадписей();
	
КонецФункции

// Контролируемые поля
&НаСервере
Функция ПолучитьКонтролируемыеПоля() Экспорт
	
	СтруктураПоказателиСотрудников = Новый Структура("ФиксСтрока");
	КонтролируемыеПоля = Новый Структура("ПоказателиСотрудников", СтруктураПоказателиСотрудников);
	
	Возврат КонтролируемыеПоля;
	
КонецФункции

// Контролируемые поля
&НаСервере
Функция ОписаниеТаблицыПоказателиСотрудников() Экспорт
	
	ОписаниеТаблицыПоказателиСотрудников = Новый Структура;	
	ОписаниеТаблицыПоказателиСотрудников.Вставить("ИмяТаблицы", 	"ПоказателиСотрудников");
	ОписаниеТаблицыПоказателиСотрудников.Вставить("ПутьКДанным", 	"ПоказателиСотрудников");
	ОписаниеТаблицыПоказателиСотрудников.Вставить("ЭтоПерерасчеты", Ложь);
	
	Возврат ОписаниеТаблицыПоказателиСотрудников;
	
КонецФункции

#КонецОбласти

&НаСервере
Процедура ПрочитатьВремяРегистрации()
	ВремяРегистрации = ЗарплатаКадрыРасширенный.ВремяРегистрацииДокумента(Объект.Ссылка, Объект.ДатаИзменения);
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеНадписей()
	
	УстановитьПривилегированныйРежим(Истина);
	МассивСотрудников = ОбщегоНазначения.ВыгрузитьКолонку(ЭтотОбъект.ПоказателиСотрудников, "Сотрудник", Истина);
	ЗарплатаКадрыРасширенный.УстановитьТекстНадписиОДокументахВведенныхНаДату(ЭтотОбъект, ВремяРегистрации, 
		МассивСотрудников, Объект.Ссылка, , Объект.ИсправленныйДокумент);
	
КонецПроцедуры

#Область ЗаписьДокумента

&НаКлиенте
Процедура ЗаписатьИЗакрытьНаКлиенте(Результат, ДополнительныеПараметры) Экспорт 
	
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", ?(Объект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
	ЗаписатьНаКлиенте(Истина, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиенте(ЗакрытьПослеЗаписи, ПараметрыЗаписи, ОповещениеЗавершения = Неопределено) Экспорт
	
	ПараметрыЗаписи.Вставить("ПроверкаПередЗаписьюВыполнена", Истина);
	
	Если ОповещениеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеЗавершения, ПараметрыЗаписи);
	ИначеЕсли Записать(ПараметрыЗаписи) И ЗакрытьПослеЗаписи Тогда 
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПодключаемуюКомандуПечатиПодтверждениеЗаписи(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		ПараметрыЗаписи = Новый Структура("РежимЗаписи", ?(Объект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
		ЗаписатьНаКлиенте(Ложь, ПараметрыЗаписи);
		Если Объект.Ссылка.Пустая() Или ЭтаФорма.Модифицированность Тогда
			Возврат; // Запись не удалась, сообщения о причинах выводит платформа.
		КонецЕсли;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(ДополнительныеПараметры.Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	Возврат ПоместитьВоВременноеХранилище(ПоказателиСотрудников.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
КонецФункции

&НаСервере
Процедура ДополнитьПоказателиСотрудников(МассивСотрудников)
	
	ТаблицаНачисленийСотрудников = Документы.ИзменениеГрафикаРаботыСписком.НачисленияСотрудников(
		Объект.Ссылка, ВремяРегистрации, МассивСотрудников);
	
	Менеджер = Документы.ИзменениеГрафикаРаботыСписком;
	Менеджер.РассчитатьФОТ(Объект.Ссылка, Объект.Организация, ВремяРегистрации, Объект.ГрафикРаботы, ТаблицаНачисленийСотрудников);
	
	Для каждого СотрудникМассива Из МассивСотрудников Цикл
		НайденныеСтроки = Объект.НачисленияСотрудников.НайтиСтроки(Новый Структура("Сотрудник",СотрудникМассива));
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Объект.НачисленияСотрудников.Удалить(НайденнаяСтрока);
		КонецЦикла;
	КонецЦикла;
	Для каждого СтрокаНачисленияСотрудников Из ТаблицаНачисленийСотрудников Цикл
		НоваяСтрока = Объект.НачисленияСотрудников.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаНачисленияСотрудников);
	КонецЦикла;
	
	ТаблицаНачисленийСотрудниковВрем = ТаблицаНачисленийСотрудников.Скопировать();
	ТаблицаНачисленийСотрудниковВрем.Свернуть("Сотрудник, ФиксСтрока");
	Для каждого СтрокаНачисленияСотрудников Из ТаблицаНачисленийСотрудниковВрем Цикл
		НоваяСтрока = Объект.Сотрудники.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаНачисленияСотрудников);
	КонецЦикла;
	
	ЗначенияСовокупныхТарифныхСтавок = Документы.ИзменениеГрафикаРаботыСписком.ЗначенияСовокупныхТарифныхСтавокСотрудников(
		ТаблицаНачисленийСотрудников, ВремяРегистрации, Объект.ГрафикРаботы);
	
	ТекущиеЗначенияСовокупныхТарифныхСтавок = Документы.ИзменениеГрафикаРаботыСписком.ТекущиеЗначенияСовокупныхТарифныхСтавокСотрудников(
		Объект.Ссылка, ВремяРегистрации, МассивСотрудников);
	
	ПоказателиСотрудниковВРеквизитФормы(ТаблицаНачисленийСотрудников);
	ЗаполнитьФОТПоСотрудникам();
	
	ЗначенияСовокупныхТарифныхСтавокВРеквизитФормы(ЗначенияСовокупныхТарифныхСтавок, ТекущиеЗначенияСовокупныхТарифныхСтавок);
	
КонецПроцедуры

#КонецОбласти
