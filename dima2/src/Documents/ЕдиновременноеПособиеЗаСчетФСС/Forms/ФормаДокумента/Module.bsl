
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РасчетЗарплатыРасширенныйФормы.ДокументыПриСозданииНаСервере(ЭтаФорма);
	
	Если Параметры.Ключ.Пустая() Тогда
		
		// Заполнение нового документа.
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный, Месяц, ДатаСобытия",
			"Объект.Организация",
			"Объект.Ответственный",
			"Объект.ПериодРегистрации",
			"Объект.ДатаСобытия");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		Если НЕ ЗначениеЗаполнено(Объект.ПериодРегистрации) Тогда
			Объект.ПериодРегистрации  = ТекущаяДатаСеанса();
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Объект.ВидПособия) Тогда
			Если НЕ ПрямыеВыплатыПособийСоциальногоСтрахования.ПособиеПлатитУчастникПилотногоПроекта(Объект.Организация, Объект.ПериодРегистрации) Тогда
				Объект.ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ПриПостановкеНаУчетВРанниеСрокиБеременности;
				Объект.ПособиеНаПогребениеСотруднику = Ложь;
			Иначе
				Объект.ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью;
				Объект.ПособиеНаПогребениеСотруднику = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		ПриПолученииДанныхНаСервере();
		РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
		
		Если ЗначениеЗаполнено(Объект.ФизическоеЛицо) Тогда
			РассчитатьПособие();
		КонецЕсли;  
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Сотрудник) И ЗначениеЗаполнено(Объект.ФизическоеЛицо) И Объект.ПособиеНаПогребениеСотруднику Тогда
		ФизическоеЛицоПриИзмененииНаСервере();
	КонецЕсли;
	
	РасчетЗарплатыРасширенныйФормы.УстановитьДоступныеХарактерыВыплаты(Элементы);
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки".
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьПереключательВидПособия();
	
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
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение И ЗначениеЗаполнено(Объект.ИсправленныйДокумент) Тогда
		Оповестить("ПослеЗаписиДокументЕдиновременноеПособиеЗаСчетФСС", Объект.ИсправленныйДокумент, ЭтаФорма);
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.ИсправленныйДокумент) Тогда
		Оповестить("ИсправленДокумент", , Объект.ИсправленныйДокумент);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ДанныеВРеквизит();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПослеЗаписиДокументЕдиновременноеПособиеЗаСчетФСС" И Параметр = Объект.Ссылка Тогда
		ТолькоПросмотр = Истина;
	ИначеЕсли ИмяСобытия = "ИсправленДокумент" И Источник = Объект.Ссылка Тогда
		ДанныеВРеквизит();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПособияПриИзменении(Элемент)
	
	Объект.ФизическоеЛицо = ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка");
	Объект.Сотрудник = ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка");
	ОбработкаПереключателя();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПереключателя()
	
	Если ВидПособия = 0 Тогда
		Объект.ВидПособия = ПредопределенноеЗначение("Перечисление.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью");
		Объект.ПособиеНаПогребениеСотруднику = Ложь;
	ИначеЕсли ВидПособия = 1 Тогда
		Объект.ВидПособия = ПредопределенноеЗначение("Перечисление.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью");
		Объект.ПособиеНаПогребениеСотруднику = Истина;
	КонецЕсли;
	
	УстановитьВыплату(ЭтаФорма);
	
	ВидПособияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВыплату(Форма)
	Если Форма.ВидПособия = 0 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ВыплатаГруппа", "Видимость", Ложь);
		Форма.Объект.ПорядокВыплаты = ПредопределенноеЗначение("Перечисление.ХарактерВыплатыЗарплаты.Зарплата");
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.КоманднаяПанель.ПодчиненныеЭлементы, "ФормаОбработкаСозданиеВедомостейНаВыплатуЗарплатыСоздатьВедомостиПоРасчетномуДокументу", "Видимость", Ложь);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ВыплатаГруппа", "Видимость", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.КоманднаяПанель.ПодчиненныеЭлементы, "ФормаОбработкаСозданиеВедомостейНаВыплатуЗарплатыСоздатьВедомостиПоРасчетномуДокументу", "Видимость", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(Элемент)
	ФизическоеЛицоПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Объект.ВидПособия.Пустая() Тогда
		ПоказатьПредупреждение(, НСтр("ru='Сначала укажите вид пособия.';uk='Спочатку вкажіть вид допомоги.'"));
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииСтрокойПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Модифицированность);
	РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
	УстановитьСписокВыбораВидаПособия();
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ПериодРегистрацииСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииСтрокойНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт

	РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
	УстановитьСписокВыбораВидаПособия();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Направление, Модифицированность);
	РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
	УстановитьСписокВыбораВидаПособия();
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	УстановитьСписокВыбораВидаПособия();
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	УстановитьСписокВыбораВидаПособия();
КонецПроцедуры

&НаКлиенте
Процедура ДатаСобытияПриИзменении(Элемент)
	ДатаСобытияПриИзмененииНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПорядокВыплатыПриИзменении(Элемент)
	
	РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОплатыПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	ВзаиморасчетыССотрудникамиКлиент.ВедомостьОплатаПоказать(ЭтаФорма, Элемент, НавигационнаяСсылка, СтандартнаяОбработка);
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
	ИсправлениеДокументовЗарплатаКадрыКлиент.Исправить(Объект.Ссылка, "ЕдиновременноеПособиеЗаСчетФСС");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправлению(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправлению(ЭтаФорма.ДокументИсправление, "ЕдиновременноеПособиеЗаСчетФСС");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправленному(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправленному(Объект.ИсправленныйДокумент, "ЕдиновременноеПособиеЗаСчетФСС");
КонецПроцедуры
// Конец ИсправлениеДокументов

&НаКлиенте
Процедура Рассчитать(Команда)
	  РассчитатьПособие(Истина);
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
Процедура ПриПолученииДанныхНаСервере() Экспорт
	
	РасчетЗарплатыРасширенныйФормы.ПорядокВыплатыЗарплатыДополнитьФорму(ЭтаФорма);
	
	ИсправлениеДокументовЗарплатаКадры.ГруппаИсправлениеДополнитьФорму(ЭтаФорма, Истина, Ложь);
	
	ДанныеВРеквизит();
	
	УстановитьПредставлениеОплаты();
	
КонецПроцедуры

&НаСервере
Процедура ДанныеВРеквизит()
	
	ОбновитьПараметрыВыбораФизическогоЛица();
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");
	
	УстановитьСписокВыбораВидаПособия();
	
	Если Не ЭтаФорма.Параметры.Ключ.Пустая() Тогда
		ИсправлениеДокументовЗарплатаКадры.ПрочитатьРеквизитыИсправления(ЭтаФорма);
	КонецЕсли;
	ИсправлениеДокументовЗарплатаКадры.УстановитьПоляИсправления(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСписокВыбораВидаПособия()
	Элементы.ВидПособия.СписокВыбора.ЗагрузитьЗначения(СписокВыбораВидаПособия().ВыгрузитьЗначения());
	УстановитьПредставленияЭлементовСписка(Элементы.ВидПособия.СписокВыбора);
КонецПроцедуры

&НаСервере
Процедура РассчитатьПособие(ВыводитьСообщения = Ложь)
	  
	Если НЕ ДокументЗаполненПравильно(ВыводитьСообщения) Тогда
		Объект.Начислено = 0;
		Возврат;
	КонецЕсли;
	
	Если Объект.ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью Тогда
	  ГосударственноеПособиеВТвердыхСуммах = "ВСвязиСоСмертью";
	КонецЕсли;
	
	Если Объект.ВидПособия <> Перечисления.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью 
		Тогда
		Объект.Начислено = 0;	
	Иначе
		Объект.Начислено = УчетПособийСоциальногоСтрахованияРасширенный.РазмерГосударственногоПособия(ГосударственноеПособиеВТвердыхСуммах, Объект.ДатаСобытия); //* РайонныйКоэффициентРФнаНачалоСобытия; 	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ДокументЗаполненПравильно(ВыводитьСообщения = Истина)
	ТекстСообщения = "";
	СтруктураСообщений  = Новый Соответствие;
	ДокументЗаполненПравильно = Истина;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаСобытия) Тогда
		ТекстСообщения = НСтр("ru='Не указана дата выплаты пособия.';uk='Не вказана дата виплати допомоги.'");
		СтруктураСообщений.Вставить("ДатаСобытия", ТекстСообщения);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидПособия) Тогда
		ТекстСообщения = НСтр("ru='Не указан вид выплачиваемого пособия.';uk='Не зазначено вид виплачуваної допомоги.'");
		СтруктураСообщений.Вставить("ВидПособия", ТекстСообщения);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ФизическоеЛицо) Тогда
		ТекстСообщения = НСтр("ru='Не указан получатель пособия.';uk='Не вказаний отримувач допомоги.'");
		СтруктураСообщений.Вставить("ФизическоеЛицо", ТекстСообщения);
	КонецЕсли;
	
	ДокументЗаполненПравильно = СтруктураСообщений.Количество() = 0;
	
	Если ВыводитьСообщения И НЕ ДокументЗаполненПравильно Тогда
		Для каждого Сообщение Из СтруктураСообщений Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение.Значение,,"Объект" + ?(Сообщение.Ключ = "","",".") + Сообщение.Ключ);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ДокументЗаполненПравильно;	
КонецФункции // ()

&НаСервере
Функция ОбновитьПараметрыВыбораФизическогоЛица()
	
	НовыйМассив = Новый Массив();
	
	Если НЕ (Объект.ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью
		И НЕ Объект.ПособиеНаПогребениеСотруднику) Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Организация", Объект.Организация);
		НовыйМассив.Добавить(НовыйПараметр);
		
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ВидЗанятости", ПредопределенноеЗначение("Перечисление.ВидыЗанятости.ОсновноеМестоРаботы"));
		НовыйМассив.Добавить(НовыйПараметр);

	Иначе
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Организация", Неопределено);
		НовыйМассив.Добавить(НовыйПараметр);
	КонецЕсли;	
	
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	Элементы.ФизическоеЛицо.ПараметрыВыбора = НовыеПараметры;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "ФизическоеЛицо");
	КонецЕсли; 
	
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Объект.ФизическоеЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();
	
	ОбновитьПараметрыВыбораФизическогоЛица();
	
	УстановитьСписокВыбораВидаПособия();
	
	РасчетЗарплатыРасширенныйФормы.ОбновитьПлановыеДатыВыплатыПоОрганизации(ЭтаФорма);
	РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
	
КонецПроцедуры

&НаСервере
Процедура ВидПособияПриИзмененииНаСервере()
	
	ОбновитьПараметрыВыбораФизическогоЛица();
	РассчитатьПособие();
	УстановитьПредставлениеОплаты();
	
КонецПроцедуры

&НаСервере
Процедура ДатаСобытияПриИзмененииНаСервере()
	РассчитатьПособие();
КонецПроцедуры

&НаСервере
Функция СписокВыбораВидаПособия()
	
	СписокВыбора = Новый СписокЗначений;

	//Если НЕ ПрямыеВыплатыПособийСоциальногоСтрахования.ПособиеПлатитУчастникПилотногоПроекта(Объект.Организация, Объект.ПериодРегистрации)  Тогда
	//	СписокВыбора.Добавить(0);
	//	СписокВыбора.Добавить(1);
	//КонецЕсли;	
	СписокВыбора.Добавить(0);
	СписокВыбора.Добавить(1);
	Возврат СписокВыбора;
	
КонецФункции

&НаСервере
Процедура ФизическоеЛицоПриИзмененииНаСервере()
	РассчитатьПособие();
	ОсновныеСотрудникиФизическихЛиц = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.ФизическоеЛицо), Истина, Объект.Организация, Объект.ДатаСобытия);
	Если ОсновныеСотрудникиФизическихЛиц.количество() > 0 Тогда 
		Объект.Сотрудник = ОсновныеСотрудникиФизическихЛиц[0].Сотрудник;
	Иначе                                                              
		Объект.Сотрудник = Справочники.Сотрудники.ПустаяСсылка();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПереключательВидПособия()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если Объект.ВидПособия = ПредопределенноеЗначение("Перечисление.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью") Тогда
			ВидПособия = ?(Объект.ПособиеНаПогребениеСотруднику, 1, 0);
		КонецЕсли;
		
	КонецЕсли;
	ОбработкаПереключателя();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставленияЭлементовСписка(СписокВыбора)
	
	Для Каждого ЭлементСписка Из СписокВыбора Цикл
		
		//Если ЭлементСписка.Значение = 0 Тогда
		//	ЭлементСписка.Представление = "При постановке на учет в ранние сроки беременности";
		//ИначеЕсли ЭлементСписка.Значение = 1 Тогда
		//	ЭлементСписка.Представление = "При рождении ребенка";
		Если ЭлементСписка.Значение = 0 Тогда
			ЭлементСписка.Представление = "Социальное пособие на погребение, выплачиваемое стороннему лицу";
		ИначеЕсли ЭлементСписка.Значение = 1 Тогда
			ЭлементСписка.Представление = "Социальное пособие на погребение, выплачиваемое сотруднику";
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеДокумента()
	
	Возврат Новый Структура("МесяцНачисленияИмя,ПорядокВыплатыИмя,ПланируемаяДатаВыплатыИмя", "ПериодРегистрации", "ПорядокВыплаты", "ПланируемаяДатаВыплаты");
	
КонецФункции

&НаСервере
Процедура УстановитьПредставлениеОплаты()
	ВедомостьУстановитьПредставлениеОплаты(ЭтаФорма);
КонецПроцедуры

Процедура ВедомостьУстановитьПредставлениеОплаты(Форма)
	
	Если Объект.ПособиеНаПогребениеСотруднику Тогда
		ПроверкаВыплат = ПроверитьВыплаты(Объект.Ссылка);
		Если ПроверкаВыплат = "Оплачено" Тогда
			Форма.ОплатыПредставление = Новый ФорматированнаяСтрока(НСтр("ru='Оплачено фондом';uk='Сплачено фондом'"),,WebЦвета.Зеленый,,);
		ИначеЕсли ПроверкаВыплат = "Отклонено" Тогда
			Форма.ОплатыПредставление = Новый ФорматированнаяСтрока(НСтр("ru='Пособие отклонено';uk='Допомога відхилена'"),,WebЦвета.Красный,,);
		ИначеЕсли ПроверкаВыплат = "Еще нет подтверждения" Тогда	
			СписокОплат = СписокОплат(Форма);
			
			Форма.ОплатыСписок			= СписокОплат;
			Форма.ОплатыПредставление	= ПредставлениеОплаты(СписокОплат)
		КонецЕсли;
	Иначе Форма.ОплатыПредставление = "";
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Функция ПроверитьВыплаты(Документ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИСТИНА Как Поле1
	|ИЗ
	|	РегистрСведений.ОплатаПособийСоциальногоСтрахования КАК ОплатаПособийСоциальногоСтрахования
	|ГДЕ
	|	ОплатаПособийСоциальногоСтрахования.Организация = &Организация
	|	И ОплатаПособийСоциальногоСтрахования.ДокументОснование = &ДокументОснование";
	
	Запрос.УстановитьПараметр("ДокументОснование", Документ);
	Запрос.УстановитьПараметр("Организация", Документ.Организация);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Следующий() Тогда
		Возврат "Оплачено"
	Иначе
		ЗапросРасчеты = Новый Запрос;
		ЗапросРасчеты.Текст = 
		"ВЫБРАТЬ
		|	РасчетыСФондамиПоПособиямОбороты.СуммаОборот
		|ИЗ
		|	РегистрНакопления.РасчетыСФондамиПоПособиям.Обороты(, , , ДокументОснование = &ДокументОснование) КАК РасчетыСФондамиПоПособиямОбороты";
		
		ЗапросРасчеты.УстановитьПараметр("ДокументОснование", Документ);
		РезультатЗапросаРасчеты = ЗапросРасчеты.Выполнить().Выбрать();
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ИСТИНА КАК Поле1
		|ИЗ
		|	Документ.ЗаявлениеРасчетВФСС.ПособияНаПогребение КАК ЗаявлениеРасчетВФССПособияНаПогребение
		|ГДЕ
		|	ЗаявлениеРасчетВФССПособияНаПогребение.ДокументОснование = &ДокументОснование
		|	И ЗаявлениеРасчетВФССПособияНаПогребение.Ссылка.Проведен
		|	И НЕ ЗаявлениеРасчетВФССПособияНаПогребение.Ссылка.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗаявлениеРасчетВФССПособияНаПогребение.Ссылка.Дата УБЫВ";
		
		Запрос.УстановитьПараметр("ДокументОснование", Документ);
		РезультатЗапроса = Запрос.Выполнить().Выбрать();
		
		Если НЕ РезультатЗапросаРасчеты.Следующий() И РезультатЗапроса.Следующий() Тогда
			Возврат "Отклонено"
		Иначе
			Возврат "Еще нет подтверждения"
		КонецЕсли;
	КонецЕсли;
	
КонецФункции	

Функция СписокОплат(Форма)
	
	СписокОплат = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", Форма.Объект.Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ЗаявлениеРасчетВФССПособияНаПогребение.Ссылка.СтатусДокумента,
	|	ЗаявлениеРасчетВФССПособияНаПогребение.Ссылка
	|ИЗ
	|	Документ.ЗаявлениеРасчетВФСС.ПособияНаПогребение КАК ЗаявлениеРасчетВФССПособияНаПогребение
	|ГДЕ
	|	ЗаявлениеРасчетВФССПособияНаПогребение.Ссылка.Проведен = ИСТИНА
	|	И НЕ ЗаявлениеРасчетВФССПособияНаПогребение.Ссылка.ПометкаУдаления
	|	И ЗаявлениеРасчетВФССПособияНаПогребение.ДокументОснование = &ДокументОснование
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаявлениеРасчетВФССПособияНаПогребение.Ссылка.Дата УБЫВ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		СписокОплат.Добавить(Выборка.Ссылка, Выборка.СтатусДокумента); 
	КонецЕсли;
	
	Возврат СписокОплат
	
КонецФункции	

Функция ПредставлениеОплаты(СписокОплат)  
	
	Если СписокОплат.Количество() = 0 Тогда
		
		ПредставлениеОплаты = Новый ФорматированнаяСтрока(НСтр("ru='Заявление расчет в ФСС по единовременному пособию не сформировано';uk='Заява розрахунок до ФСС з одноразової допомоги не сформовано'"),,WebЦвета.Синий,,);
		
	Иначе //СписокОплат.Количество() = 1 Тогда	
		
		ПредставлениеДокумента = 
		НРег(Лев(СписокОплат[0].Представление, 1))
		+ Сред(СписокОплат[0].Представление, 2, СтрНайти(СписокОплат[0].Представление, " - ") - 2);
		
		ПредставлениеОплаты = Новый ФорматированнаяСтрока("Оформлено "+ СписокОплат[0].Значение + ", находится в статусе ",	" ",  
		Новый ФорматированнаяСтрока(ПредставлениеДокумента, ,WebЦвета.Синий , , "ссылка"));
	КонецЕсли;	
	
	Возврат ПредставлениеОплаты
	
КонецФункции

#КонецОбласти
