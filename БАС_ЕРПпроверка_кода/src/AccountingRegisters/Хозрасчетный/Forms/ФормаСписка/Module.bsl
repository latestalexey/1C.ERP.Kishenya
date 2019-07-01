
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	УстановитьЗаголовкиПодразделения();
	
	Если Параметры.Свойство("Счет") Тогда
		ОтборСчет = Параметры.Счет;
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Счет", ОтборСчет,
			ЗначениеЗаполнено(ОтборСчет), ВидСравненияКомпоновкиДанных.ВИерархии);
	КонецЕсли;
	
	ОтборОрганизация = ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма);
	
	НерекомендуемыеСчетаУчетаВОперацииБух = Документы.ОперацияБух.НерекомендуемыеСчетаУчета();
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "НерекомендуемыеСчетаУчетаВОперацииБух", НерекомендуемыеСчетаУчетаВОперацииБух);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОтборОрганизация = ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, , Параметр);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборСчетПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Счет", ОтборСчет, ЗначениеЗаполнено(ОтборСчет), ВидСравненияКомпоновкиДанных.ВИерархии);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Организация", ОтборОрганизация, ЗначениеЗаполнено(ОтборОрганизация));

КонецПроцедуры

&НаКлиенте
Процедура ОтборРегистраторПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "Регистратор", ОтборРегистратор, ЗначениеЗаполнено(ОтборРегистратор));
	
КонецПроцедуры

&НаСервере
Процедура ПереключитьАктивностьПроводокСервер(Документ)
	
	БухгалтерскийУчет.ПереключитьАктивностьПроводокБУ(Документ);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьАктивностьПроводок(Команда)
	
	ТекДокумент = ПолучитьДокумент();
	
	Если ТекДокумент <> Неопределено Тогда
		
		ПереключитьАктивностьПроводокСервер(ТекДокумент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТипЗнч(Элемент.ТекущиеДанные.Регистратор) = Тип("ДокументСсылка.ОперацияБух") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОткрытьФорму("Документ.ОперацияБух.ФормаОбъекта",
		             Новый Структура("ПараметрТекущаяСтрока,Ключ", Элемент.ТекущиеДанные.НомерСтроки,Элемент.ТекущиеДанные.Регистратор));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСчетДтНеРекомендуетсяИспользоватьВОперацииБух.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СчетДтНеРекомендуетсяИспользоватьВОперацииБух");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСчетКтНеРекомендуетсяИспользоватьВОперацииБух.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СчетКтНеРекомендуетсяИспользоватьВОперацииБух");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовкиПодразделения()

	ИспользуетсяУчетПоНаправлениям = ПолучитьФункциональнуюОпцию("ИспользоватьУчетЗатратПоНаправлениямДеятельности")
								ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьУчетДоходовПоНаправлениямДеятельности")
								ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьУчетДСпоНаправлениямДеятельностиРаздельно")
								ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьУчетДСпоНаправлениямДеятельностиПоКорреспонденции")
								ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьУчетВнеоборотныхАктивовПоНаправлениямДеятельности");
	ШаблонЗаголовка = НСтр("ru='Подразделение %1';uk='Підрозділ %1'");
	Если ИспользуетсяУчетПоНаправлениям Тогда
		ШаблонЗаголовка = ШаблонЗаголовка + ", " + НСтр("ru='Направление %1';uk='Напрямок %1'")
	КонецЕсли;
	Элементы.СписокПодразделениеДт.Заголовок = СтрШаблон(ШаблонЗаголовка, НСтр("ru='Дт';uk='Дт'"));
	Элементы.СписокПодразделениеКт.Заголовок = СтрШаблон(ШаблонЗаголовка, НСтр("ru='Кт';uk='Кт'"));
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьДокумент()
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение( , НСтр("ru='Не выбран документ';uk='Не вибраний документ'"));
		Возврат Неопределено;
	КонецЕсли;
	
	ТекДокумент = ТекДанные.Регистратор;
	Если НЕ ЗначениеЗаполнено(ТекДокумент) Тогда
		ПоказатьПредупреждение( , НСтр("ru='Не выбран документ';uk='Не вибраний документ'"));
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ТекДокумент;
	
КонецФункции

#КонецОбласти
