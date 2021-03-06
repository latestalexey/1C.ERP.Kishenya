#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ОбновитьДатуАктуальностиРасчетовСервер();

	// Данный отбор присутсвует всегда и не редактируется
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		СписокКПроверке.Отбор, 
		"Статус", 
		Перечисления.СтатусыНалоговыхДокументов.Проверен, // Сформирован или КПроверке
		ВидСравненияКомпоновкиДанных.НеРавно, 
		, 
		Истина
	);
	
	// По умолчанию отбор по контрагенту, может быть переопределен в ПриЗагрузкеДанныхИзНастроекНаСервере
	Контрагент = Справочники.Контрагенты.ПустаяСсылка();
	
	НастроитьЭлементыФормы();
	УстановитьОтборДинамическихСписков();
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыСписка());
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюОтчеты,, Ложь);
	// Конец МенюОтчеты
	
	// ИнтеграцияС1СДокументооборотом         
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(
		ЭтаФорма, 
		Элементы.ГруппаГлобальныеКоманды, 
		Новый Структура("Источник", "ЖурналДокументов.ИсходящиеНалоговыеДокументы"));
		
	// Конец ИнтеграцияС1СДокументооборотом
	
	ВводНаОсновании.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюСоздатьНаОсновании);

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	НастроитьЭлементыФормы();
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВариантОкончания.Вариант = ВариантСтандартнойДатыНачала.ПроизвольнаяДата Тогда
		ВариантОкончания.Дата = ТекущаяДата();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИсходящиеНалоговыеДокументы_АктивироватьОформлениеНалоговыхДокументов" Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКОформлению;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьДатуАктуальностиРасчетов(Команда)
	
	ОбновитьДатуАктуальностиРасчетовСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура АктуализироватьРасчеты(Команда)
	
	ДополнительныеСвойства = Новый Структура();
	Оповещение = Новый ОписаниеОповещения("АктуализироватьРасчетыПродолжение", ЭтотОбъект, ДополнительныеСвойства);
	
	ТекстВопроса = НСтр("ru='Актуализировать расчеты с клиентами?';uk='Актуалізувати розрахунки з клієнтами?'");
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
	
КонецПроцедуры

&НаКлиенте
Процедура АктуализироватьРасчетыПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	АктуализироватьРасчетыСервер();

	Элементы.СписокКПроверке.Обновить();	
	
	ПоказатьОповещениеПользователя(
		НСтр("ru='Актуализация расчетов';uk='Актуалізація розрахунків'"),
		,
		НСтр("ru='Расчеты с клиентами актуализированы. Состояние НН и П2 актуально до ';uk='Розрахунки з клієнтами актуалізовані. Стан ПН та Д2 актуальний до '") + Формат(ДатаАктуальностиРасчетов, "ДФ=dd.MM.yyyy; ДП='Нет данных'"),
		БиблиотекаКартинок.Информация32
	);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНалоговыеДокументы(Команда)
	
	ОбновитьДатуАктуальностиРасчетовСервер();
	
	Если КонецДня(ДатаАктуальностиРасчетов) > КонецДня(ВариантОкончания.Дата) Тогда
		ПоказатьПредупреждение(,
			НСтр("ru='Список сформированных налоговых документов актуален и не требует переформирования';uk='Список сформованих податкових документів актуальний і не потребує переформування'"),
			,
			НСтр("ru='Формирование не требуется';uk='Формування не потрібне'")
		);
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура ("Организация, Партнер, Контрагент"
											, ?(ЗначениеЗаполнено(Организация), Организация, Неопределено)
											, ?(ЗначениеЗаполнено(Партнер), Партнер, Неопределено)
											, ?(ЗначениеЗаполнено(Контрагент), Контрагент, Неопределено));
	
	Если (КонецДня(ДатаАктуальностиРасчетов) < КонецДня(ВариантОкончания.Дата)) И (ЗначениеЗаполнено(Партнер) ИЛИ  ЗначениеЗаполнено(Контрагент)) Тогда
		
		ДополнительныеСвойства = Новый Структура("СтруктураПараметров", СтруктураПараметров);
		Оповещение = Новый ОписаниеОповещения("СформироватьНалоговыеДокументыПродолжение", ЭтотОбъект, ДополнительныеСвойства);
		
		ТекстВопроса = НСтр("ru='Внимание! Формирование налоговых документов за несколько дней рекомендуется 
                                                          |выполнять по организации в целом, без отбора по клиенту и контрагенту. В противном 
                                                          |случае может нарушиться последовательность нумерации налоговых документов.
                                                          |
                                                          |Продолжить формирование с отбором по клиенту и/или контрагенту?'
                                                          |;uk='Увага! Формування податкових документів за кілька днів рекомендується 
                                                          |виконувати по організації в цілому, без відбору за клієнтом та контрагентом. В іншому 
                                                          |випадку може порушитися послідовність нумерації податкових документів.
                                                          |
                                                          |Продовжити формування з відбором за клієнтом та/або контрагентом?'");
								  
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Продолжить с отбором';uk='Продовжити з відбором'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Убрать отбор';uk='Прибрати відбір'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки, , КодВозвратаДиалога.Нет, НСтр("ru='Формирование налоговых документов';uk='Формування податкових документів'"));
		
		
	Иначе
	
		СформироватьНалоговыеДокументыЗавершение(СтруктураПараметров);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНалоговыеДокументыПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		ДополнительныеПараметры.СтруктураПараметров.Партнер = Неопределено;
		ДополнительныеПараметры.СтруктураПараметров.Контрагент = Неопределено;
	КонецЕсли;
	
	СформироватьНалоговыеДокументыЗавершение(ДополнительныеПараметры.СтруктураПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНалоговыеДокументыЗавершение(СтруктураПараметров)
	
	СформироватьНалоговыеДокументыСервер(СтруктураПараметров);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru='Формирование налоговых документов';uk='Формування податкових документів'"),
		,
		НСтр("ru='Формирование успешно завершено';uk='Формування успішно завершено'"),
		БиблиотекаКартинок.Информация32
	);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец МенюОтчеты

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПартнерПриИзменении(Элемент)
	
	Если Партнер = ПредопределенноеЗначение("Справочник.Партнеры.ПустаяСсылка") 
	   И ТипЗнч(Контрагент) <> Тип("СправочникСсылка.Контрагенты") Тогда
		Контрагент = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	   
	ИначеЕсли Партнер = ПредопределенноеЗначение("Справочник.Партнеры.НашеПредприятие") 
	   И ТипЗнч(Контрагент) <> Тип("СправочникСсылка.Организации")  Тогда
		Контрагент = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка");
	Иначе	
		ЗаполнитьКонтрагентаПартнераПоУмолчанию();
	КонецЕсли;
	
	НастроитьЭлементыФормы();
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентПриИзменении(Элемент)
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры


&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьДатуАктуальностиРасчетовСервер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	
	////

	Элемент = УсловноеОформление.Элементы.Добавить();

	//Поле: СтатусАвтокорректировки
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусАвтокорректировки.Имя);

	//Отбор
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ВидОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	ОтборЭлемента.ПравоеЗначение = НДСИсходящийКлиентСервер.ПолучитьСписокАвтокорректируемыхВидовОперацийНН();

	//Оформления
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<не используется>';uk='<не використовується>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	
	////

	Элемент = УсловноеОформление.Элементы.Добавить();

	//Поле: ВидОперации
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидОперации.Имя);

	//Группа отбора
	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	//Отбор
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ВидОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = ПредопределенноеЗначение("Перечисление.ВидыОперацийНалоговыхДокументов.УсловнаяПродажа");
	//Отбор
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Тип");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Тип("ДокументСсылка.Приложение2КНалоговойНакладной");

	//Оформления
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Сторно условной продажи';uk='Сторно умовного продажу'"));
	
	
	////

	Элемент = УсловноеОформление.Элементы.Добавить();

	//Поле: СтатусАвтокорректировки
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокКПроверкеСтатусАвтокорректировки.Имя);

	//Отбор
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокКПроверке.ВидОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	ОтборЭлемента.ПравоеЗначение = НДСИсходящийКлиентСервер.ПолучитьСписокАвтокорректируемыхВидовОперацийНН();

	//Оформления
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<не используется>';uk='<не використовується>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	
	////

	Элемент = УсловноеОформление.Элементы.Добавить();

	//Поле: ВидОперации
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокКПроверкеВидОперации.Имя);

	//Группа отбора
	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	//Отбор
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокКПроверке.ВидОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = ПредопределенноеЗначение("Перечисление.ВидыОперацийНалоговыхДокументов.УсловнаяПродажа");
	//Отбор
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокКПроверке.Тип");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Тип("ДокументСсылка.Приложение2КНалоговойНакладной");

	//Оформления
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Сторно условной продажи';uk='Сторно умовного продажу'"));
	
	////

	Элемент = УсловноеОформление.Элементы.Добавить();

	//Поле: ВидОперации
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокКПроверкеВидОперации.Имя);

	//Группа отбора
	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	//Отбор
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокКПроверке.ВидОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = ПредопределенноеЗначение("Перечисление.ВидыОперацийНалоговыхДокументов.СводнаяУсловнаяПродажа");
	//Отбор
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокКПроверке.Тип");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Тип("ДокументСсылка.Приложение2КНалоговойНакладной");

	//Оформления
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Корректировка условной продажи';uk='Коригування умовного продажу'"));
	
	///

	Элемент = УсловноеОформление.Элементы.Добавить();

	//Поле: ВидОперации
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидОперации.Имя);

	//Группа отбора
	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	//Отбор
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ВидОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = ПредопределенноеЗначение("Перечисление.ВидыОперацийНалоговыхДокументов.СводнаяУсловнаяПродажа");
	//Отбор
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Тип");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Тип("ДокументСсылка.Приложение2КНалоговойНакладной");

	//Оформления
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Корректировка условной продажи';uk='Коригування умовного продажу'"));
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормы()

	Если Партнер = Справочники.Партнеры.НашеПредприятие Тогда
		ОписаниеТипа = Новый ОписаниеТипов("СправочникСсылка.Организации");
	Иначе
		ОписаниеТипа = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	КонецЕсли;
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Контрагент", "ОграничениеТипа", ОписаниеТипа);
	
	ЦветДатыАктуальностиРасчетов = ?(ДатаАктуальностиРасчетов < (КонецДня(ТекущаяДата())+1), ЦветаСтиля.ПоясняющийОшибкуТекст, ЦветаСтиля.ПоясняющийТекст);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДатаАктуальностиРасчетов", "ЦветТекстаЗаголовка", ЦветДатыАктуальностиРасчетов);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДатаАктуальностиРасчетов", "ЦветТекста", ЦветДатыАктуальностиРасчетов);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьНалоговыеДокументыСервер(СтруктураПараметров)
			
	НДСИсходящийСервер.СформироватьНалоговыеНакладные(КонецДня(ВариантОкончания.Дата), СтруктураПараметров, Пользователи.АвторизованныйПользователь());
	
	Элементы.СписокКПроверке.Обновить();
	
	ОбновитьДатуАктуальностиРасчетовСервер();	
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьДатуАктуальностиРасчетовСервер()
	
	ДатаАктуальностиРасчетов = НДСИсходящийСервер.ПолучитьДатуНачалаФормированияНалоговыхДокументов();
	Если НЕ ЗначениеЗаполнено(ДатаАктуальностиРасчетов) Тогда
		ДатаАктуальностиРасчетов = КонецДня(ТекущаяДата())+1;
	КонецЕсли;
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

// Процедура устанавливает отбор динамических списков формы.
//
&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(Организация));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Партнер",     Партнер,     ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(Партнер));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Контрагент",  Контрагент,  ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(Контрагент));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокКПроверке, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(Организация));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокКПроверке, "Партнер",     Партнер,     ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(Партнер));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокКПроверке, "Контрагент",  Контрагент,  ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(Контрагент));
	
КонецПроцедуры

&НаСервере
Процедура АктуализироватьРасчетыСервер()
	
	ОкончаниеПериодаРасчета = КонецМесяца(ТекущаяДатаСеанса()) + 1;
	РаспределениеВзаиморасчетов.РаспределитьВсеРасчетыСКлиентами(ОкончаниеПериодаРасчета);
	
	ОбновитьДатуАктуальностиРасчетовСервер();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКонтрагентаПартнераПоУмолчанию()
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);	
КонецПроцедуры

#КонецОбласти
