
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицуТоваров();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()
	
	СтруктураПоиска = Новый Структура("Пометка", Истина);
 	СписокСтрок = ТаблицаТоваров.НайтиСтроки(СтруктураПоиска);
	
	Если СписокСтрок.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Необходимо выбрать продукцию.';uk='Необхідно вибрати продукцію.'"));
		Возврат;
	КонецЕсли;
	
	ПеренестиТоварыВДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьТоварыВыполнить()
	
	ВыбратьВсеТоварыНаСервере(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьТоварыВыполнить()
	
	ВыбратьВсеТоварыНаСервере(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	#Область СтандартноеОформление
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "ТаблицаТоваровХарактеристика",
																		     "ТаблицаТоваров.ХарактеристикиИспользуются");
	#КонецОбласти

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеТоварыНаСервере(ЗначениеВыбора)
	
	Для Каждого СтрокаТаблицы Из ТаблицаТоваров.НайтиСтроки(Новый Структура("Пометка", Не ЗначениеВыбора)) Цикл
		
		СтрокаТаблицы.Пометка = ЗначениеВыбора;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьВыбраннуюПродукцию()
	
	ДанныеЗаполнения = Новый Массив;
	СтруктураПоиска = Новый Структура("Пометка", Истина);
 	СписокСтрок = ТаблицаТоваров.НайтиСтроки(СтруктураПоиска);
	Для каждого ТекущиеДанные Из СписокСтрок Цикл
		ДанныеПродукции = Новый Структура("Номенклатура,Характеристика,Назначение,КодСтроки,Упаковка,НомерГруппыЗатрат,ТипСтоимости");
		ЗаполнитьЗначенияСвойств(ДанныеПродукции, ТекущиеДанные);
		Если ТекущиеДанные.Поступило <> 0 Тогда
			Количество = ТекущиеДанные.Поступило;
		Иначе
			Количество = ТекущиеДанные.Заказано;
		КонецЕсли; 
		ДанныеПродукции.Вставить("Количество", Количество);
		
		ДанныеЗаполнения.Добавить(ДанныеПродукции);
	КонецЦикла; 
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуТоваров()
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВложенныйЗапрос.КодСтроки КАК КодСтроки,
	|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	|	ВложенныйЗапрос.Характеристика КАК Характеристика,
	|	ЕСТЬNULL(ТаблицаПродукция.Упаковка, ТаблицаОтходы.Упаковка) КАК Упаковка,
	|	ЕСТЬNULL(ТаблицаПродукция.ДоляСтоимости, 0) КАК ДоляСтоимости,
	|	ЕСТЬNULL(ТаблицаПродукция.НомерГруппыЗатрат, ТаблицаОтходы.НомерГруппыЗатрат) КАК НомерГруппыЗатрат,
	|	ВЫБОР
	|		КОГДА НЕ ТаблицаПродукция.Ссылка ЕСТЬ NULL 
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыСтоимостиВыходныхИзделий.Рассчитывается)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыСтоимостиВыходныхИзделий.Фиксированная)
	|	КОНЕЦ КАК ТипСтоимости,
	|	СУММА(ВложенныйЗапрос.Поступило) КАК Поступило,
	|	СУММА(ВложенныйЗапрос.Заказано) КАК Заказано,
	|	СУММА(ВложенныйЗапрос.Поступило / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1))) КАК ПоступилоУпаковок,
	|	СУММА(ВложенныйЗапрос.Заказано / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1))) КАК ЗаказаноУпаковок,
	|	ВЫБОР
	|		КОГДА ВложенныйЗапрос.Номенклатура.ИспользованиеХарактеристик В (ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры), ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры), ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры))
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ХарактеристикиИспользуются,
	|	ВЫРАЗИТЬ(ВложенныйЗапрос.Распоряжение КАК Документ.ЗаказПереработчику).Номер КАК НомерРаспоряжения,
	|	ВЫРАЗИТЬ(ВложенныйЗапрос.Распоряжение КАК Документ.ЗаказПереработчику).Дата КАК ДатаРаспоряжения
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗаказыПоставщикам.ЗаказПоставщику КАК Распоряжение,
	|		ЗаказыПоставщикам.КодСтроки КАК КодСтроки,
	|		ЗаказыПоставщикам.Номенклатура КАК Номенклатура,
	|		ЗаказыПоставщикам.Характеристика КАК Характеристика,
	|		0 КАК Поступило,
	|		ЗаказыПоставщикам.КОформлениюОстаток КАК Заказано
	|	ИЗ
	|		РегистрНакопления.ЗаказыПоставщикам.Остатки(, ЗаказПоставщику = &Заказ) КАК ЗаказыПоставщикам
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТоварыПолученныеОтПереработчикаОстатки.Распоряжение,
	|		ТоварыПолученныеОтПереработчикаОстатки.КодСтроки,
	|		ТоварыПолученныеОтПереработчикаОстатки.АналитикаУчетаНоменклатуры.Номенклатура,
	|		ТоварыПолученныеОтПереработчикаОстатки.АналитикаУчетаНоменклатуры.Характеристика,
	|		ТоварыПолученныеОтПереработчикаОстатки.КоличествоОстаток,
	|		0
	|	ИЗ
	|		РегистрНакопления.ТоварыПолученныеОтПереработчика.Остатки(, Распоряжение = &Заказ) КАК ТоварыПолученныеОтПереработчикаОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТоварыПолученныеОтПереработчикаОстатки.Распоряжение,
	|		ТоварыПолученныеОтПереработчикаОстатки.КодСтроки,
	|		ТоварыПолученныеОтПереработчикаОстатки.АналитикаУчетаНоменклатуры.Номенклатура,
	|		ТоварыПолученныеОтПереработчикаОстатки.АналитикаУчетаНоменклатуры.Характеристика,
	|		ТоварыПолученныеОтПереработчикаОстатки.Количество,
	|		0
	|	ИЗ
	|		РегистрНакопления.ТоварыПолученныеОтПереработчика КАК ТоварыПолученныеОтПереработчикаОстатки
	|	ГДЕ
	|		ТоварыПолученныеОтПереработчикаОстатки.Регистратор = &Регистратор
	|		И ТоварыПолученныеОтПереработчикаОстатки.Активность) КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПереработчику КАК ДокЗаказПереработчику
	|		ПО (ДокЗаказПереработчику.Ссылка = ВложенныйЗапрос.Распоряжение)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПереработчику.Продукция КАК ТаблицаПродукция
	|		ПО (ТаблицаПродукция.Ссылка = ВложенныйЗапрос.Распоряжение)
	|			И (ТаблицаПродукция.КодСтроки = ВложенныйЗапрос.КодСтроки)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПереработчику.ВозвратныеОтходы КАК ТаблицаОтходы
	|		ПО (ТаблицаОтходы.Ссылка = ВложенныйЗапрос.Распоряжение)
	|			И (ТаблицаОтходы.КодСтроки = ВложенныйЗапрос.КодСтроки)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Распоряжение,
	|	ЕСТЬNULL(ТаблицаПродукция.Упаковка, ТаблицаОтходы.Упаковка),
	|	ЕСТЬNULL(ТаблицаПродукция.НомерГруппыЗатрат, ТаблицаОтходы.НомерГруппыЗатрат),
	|	ЕСТЬNULL(ТаблицаПродукция.ДоляСтоимости, 0),
	|	ВложенныйЗапрос.КодСтроки,
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.Характеристика,
	|	ВЫБОР
	|		КОГДА НЕ ТаблицаПродукция.Ссылка ЕСТЬ NULL 
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыСтоимостиВыходныхИзделий.Рассчитывается)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыСтоимостиВыходныхИзделий.Фиксированная)
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ВложенныйЗапрос.Номенклатура.ИспользованиеХарактеристик В (ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры), ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры), ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры))
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ,
	|	ВЫРАЗИТЬ(ВложенныйЗапрос.Распоряжение КАК Документ.ЗаказПереработчику).Номер,
	|	ВЫРАЗИТЬ(ВложенныйЗапрос.Распоряжение КАК Документ.ЗаказПереработчику).Дата
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаРаспоряжения,
	|	НомерРаспоряжения,
	|	ВложенныйЗапрос.Распоряжение";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"ТаблицаПродукция.Упаковка",
		"ТаблицаПродукция.Номенклатура"));
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"ТаблицаОтходы.Упаковка",
		"ТаблицаОтходы.Номенклатура"));
		
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Заказ", Параметры.Заказ);
	Запрос.УстановитьПараметр("Регистратор", Параметры.ОтчетПереработчика);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		ДанныеСтроки = ТаблицаТоваров.Добавить();
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, Выборка);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиТоварыВДокумент()
	
	ДанныеЗаполнения = ПолучитьВыбраннуюПродукцию();
	
	Закрыть(ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
