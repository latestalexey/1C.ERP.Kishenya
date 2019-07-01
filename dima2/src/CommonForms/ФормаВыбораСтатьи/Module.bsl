
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	УстановитьПараметрыДинамическогоСписка();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ХозяйственнаяОперация = Неопределено;
	АктивПассив = Неопределено;
	ВариантРаспределенияРасходов = Неопределено;
	Если Параметры.Свойство("ПараметрыВыбора") Тогда
		
		Для каждого ПараметрВыбора Из Параметры.ПараметрыВыбора Цикл
		
			Если ПараметрВыбора.Имя = "Отбор.ХозяйственнаяОперация" Тогда
				
				Если ЗначениеЗаполнено(ПараметрВыбора.Значение) Тогда
					ХозяйственнаяОперация = ПараметрВыбора.Значение;
				КонецЕсли;
				
			КонецЕсли;
			
			Если ПараметрВыбора.Имя = "Отбор.ВариантРаспределенияРасходов" Тогда
				
				Если ЗначениеЗаполнено(ПараметрВыбора.Значение) Тогда
					ВариантРаспределенияРасходов = ПараметрВыбора.Значение;
				КонецЕсли;
				
			КонецЕсли;
			
			Если ПараметрВыбора.Имя = "Отбор.АктивПассив" Тогда
				Если ЗначениеЗаполнено(ПараметрВыбора.Значение) Тогда
					АктивПассив = ПараметрВыбора.Значение;
				КонецЕсли;
			КонецЕсли;
			
			Если ПараметрВыбора.Имя = "ДополнитьСтатьямиРасходов" Тогда
				ВыбиратьСтатьиРасходов = Истина;
			КонецЕсли;
			
			Если ПараметрВыбора.Имя = "ДополнитьСтатьямиДоходов" Тогда
				ВыбиратьСтатьиДоходов = Истина;
			КонецЕсли;
			
			Если ПараметрВыбора.Имя = "ДополнитьСтатьямиАктивовПассивов" Тогда
				ВыбиратьСтатьиАктивовПассивов = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	СтатьиРасходов.Параметры.УстановитьЗначениеПараметра("ХозяйственнаяОперация", ХозяйственнаяОперация);
	СтатьиРасходов.Параметры.УстановитьЗначениеПараметра("БезОграниченияИспользования", Не ЗначениеЗаполнено(ХозяйственнаяОперация));
	
	СтатьиРасходов.Параметры.УстановитьЗначениеПараметра("ВариантРаспределенияРасходов", ВариантРаспределенияРасходов);
	СтатьиРасходов.Параметры.УстановитьЗначениеПараметра("ПоВсемВариантамРаспределения", Не ЗначениеЗаполнено(ВариантРаспределенияРасходов));
	
	СтатьиАктивовПассивов.Параметры.УстановитьЗначениеПараметра("АктивностьСтатьи", АктивПассив);
	СтатьиАктивовПассивов.Параметры.УстановитьЗначениеПараметра("БезОграниченияПоАктивуПассиву", Не ЗначениеЗаполнено(АктивПассив));
	
	Если Параметры.Свойство("Статья", Статья) Тогда
		
		Если ТипЗнч(Статья) = Тип("ПланВидовХарактеристикСсылка.СтатьиРасходов") Тогда
			РежимВыбора = 0;
			Элементы.СтатьиРасходов.ТекущаяСтрока = Статья;
		ИначеЕсли ТипЗнч(Статья) = Тип("ПланВидовХарактеристикСсылка.СтатьиДоходов") Тогда
			РежимВыбора = 1;
			Элементы.СтатьиДоходов.ТекущаяСтрока = Статья;
		Иначе
			РежимВыбора = 2;
			Элементы.СтатьиАктивовПассивов.ТекущаяСтрока = Статья;
		КонецЕсли;
	КонецЕсли;
	
	ФормироватьФинансовыйРезультат = ПолучитьФункциональнуюОпцию("ФормироватьФинансовыйРезультат");
	
	НастроитьРежимВыбора();
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура РежимВыбораПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СтатьиРасходовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтатьяРасходов = Элементы.СтатьиРасходов.ТекущаяСтрока;
	Если НЕ Элементы.СтатьиРасходов.ДанныеСтроки(СтатьяРасходов).ЭтоГруппа Тогда
		СтандартнаяОбработка = Ложь;
		Закрыть(СтатьяРасходов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьиДоходовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтатьяДоходов = Элементы.СтатьиДоходов.ТекущаяСтрока;
	Если НЕ Элементы.СтатьиДоходов.ДанныеСтроки(СтатьяДоходов).ЭтоГруппа Тогда
		СтандартнаяОбработка = Ложь;
		Закрыть(СтатьяДоходов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьиАктивовПассивовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтатьяАктивовПассивов = Элементы.СтатьиАктивовПассивов.ТекущаяСтрока;
	Если НЕ Элементы.СтатьиАктивовПассивов.ДанныеСтроки(СтатьяАктивовПассивов).ЭтоГруппа Тогда
		СтандартнаяОбработка = Ложь;
		Закрыть(СтатьяАктивовПассивов);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтатьюРасходов(Команда)
	
	ВыбратьСтатью("СтатьиРасходов");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтатьюДоходов(Команда)
	
	ВыбратьСтатью("СтатьиДоходов");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтатьюАктивовПассивов(Команда)
	
	ВыбратьСтатью("СтатьиАктивовПассивов");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьСтатью(ИмяТаблицы)
	
	ТекущаяСтрока = Элементы[ИмяТаблицы].ТекущаяСтрока; 
	
	Если ТекущаяСтрока = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru='Команда не может быть выполнена для указанного объекта.';uk='Команда не може бути виконана для зазначеного об''єкта.'"));
		Возврат;
	КонецЕсли;
	
	Если Элементы[ИмяТаблицы].ДанныеСтроки(ТекущаяСтрока).ЭтоГруппа Тогда
		ПоказатьПредупреждение(, НСтр("ru='Выберите элемент, а не группу.';uk='Виберіть елемент, а не групу.'"));
		Возврат;
	КонецЕсли;
	
	Закрыть(ТекущаяСтрока);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатьиРасходовВариантРаспределенияРасходов.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СтатьиРасходов.ВариантРаспределенияРасходов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВариантыРаспределенияРасходов.НаНаправленияДеятельности;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ФормироватьФинансовыйРезультат");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='На финансовый результат';uk='На фінансовий результат'"));

КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыДинамическогоСписка()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			СтатьиРасходов,
			"Ссылка",
			ПланыВидовХарактеристик.СтатьиРасходов.ЗаблокированныеСтатьиРасходов(),
			ВидСравненияКомпоновкиДанных.НеВСписке);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			СтатьиДоходов,
			"Ссылка",
			ПланыВидовХарактеристик.СтатьиДоходов.ЗаблокированныеСтатьиДоходов(),
			ВидСравненияКомпоновкиДанных.НеВСписке);
			
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			СтатьиАктивовПассивов,
			"Ссылка",
			ПланыВидовХарактеристик.СтатьиАктивовПассивов.ЗаблокированныеСтатьиАктивовПассивов(),
			ВидСравненияКомпоновкиДанных.НеВСписке);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	Если РежимВыбора = 0 Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтатьиРасходов;
		Элементы.СтатьиРасходовКнопкаВыбрать.КнопкаПоУмолчанию = Истина;
	ИначеЕсли РежимВыбора = 1 Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтатьиДоходов;
		Элементы.СтатьиДоходовКнопкаВыбрать.КнопкаПоУмолчанию = Истина;
	Иначе
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтатьиАктивовПассивов;
		Элементы.СтатьиАктивовПассивовКнопкаВыбрать.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
	Если Элементы.РежимВыбора.СписокВыбора.Количество() = 1 Тогда
		
		Если РежимВыбора = 0 Тогда
			ЭтаФорма.Заголовок =  НСтр("ru='Выбор статьи расходов';uk='Вибір статті витрат'");
		ИначеЕсли РежимВыбора = 1 Тогда
			ЭтаФорма.Заголовок =  НСтр("ru='Выбор статьи доходов';uk='Вибір статті доходів'");
		Иначе
			ЭтаФорма.Заголовок =  НСтр("ru='Выбор статьи активов/пассивов';uk='Вибір статті активів/пасивів'");
		КонецЕсли;
	Иначе
		ЭтаФорма.Заголовок =  НСтр("ru='Выбор статьи';uk='Вибір статті'");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура НастроитьРежимВыбора()
	
	СписокВыбора = Элементы.РежимВыбора.СписокВыбора;
	
	Если НЕ ВыбиратьСтатьиАктивовПассивов
			ИЛИ НЕ ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихАктивовПассивов") Тогда
		СписокВыбора.Удалить(2);
	КонецЕсли;
	
	Если НЕ ВыбиратьСтатьиДоходов
			ИЛИ НЕ ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов") Тогда
		СписокВыбора.Удалить(1);
	КонецЕсли;
	
	Если НЕ ВыбиратьСтатьиРасходов
			ИЛИ НЕ ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов") Тогда
		СписокВыбора.Удалить(0);
	КонецЕсли;
	
	Элементы.РежимВыбора.Видимость =  (СписокВыбора.Количество() > 1);
	
	Если СписокВыбора.Количество() = 1 Тогда
		РежимВыбора = СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
