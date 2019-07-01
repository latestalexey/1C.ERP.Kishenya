
#Область ПрограммныйИнтерфейс

Процедура ЗарегистрироватьИзмененияСправочника(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТипИсточника = ТипЗнч(Источник);
	Если ТипИсточника = Тип("СправочникОбъект.Номенклатура") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = &Значение
		|	И (КодыТоваровПодключаемогоОборудованияOffline.Номенклатура.Наименование <> &ЗначениеНаименование
		|	ИЛИ КодыТоваровПодключаемогоОборудованияOffline.Номенклатура.НаименованиеПолное <> &ЗначениеНаименованиеПолное)
		|");
		
		Запрос.УстановитьПараметр("ЗначениеНаименованиеПолное", Источник.НаименованиеПолное);
		
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.ХарактеристикиНоменклатуры") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровПодключаемогоОборудованияOffline.Характеристика = &Значение
		|	И (КодыТоваровПодключаемогоОборудованияOffline.Характеристика.Наименование <> &ЗначениеНаименование
		|	ИЛИ КодыТоваровПодключаемогоОборудованияOffline.Характеристика.НаименованиеПолное <> &ЗначениеНаименованиеПолное)");
		
		Запрос.УстановитьПараметр("ЗначениеНаименованиеПолное", Источник.НаименованиеПолное);
		
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.УпаковкиЕдиницыИзмерения") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровПодключаемогоОборудованияOffline.Упаковка = &Значение
		|	И КодыТоваровПодключаемогоОборудованияOffline.Упаковка.Наименование <> &ЗначениеНаименование");
	
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.ВидыНоменклатуры") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И КодыТоваровПодключаемогоОборудованияOffline.Номенклатура.ВидНоменклатуры = &Значение");
		
	ИначеЕсли ТипИсточника = Тип("СправочникОбъект.ПодключаемоеОборудование") Тогда
		
		Если  ЗначениеЗаполнено(Источник.УзелИнформационнойБазы)
			И ЗначениеЗаполнено(Источник.ПравилоОбмена)
			И Источник.ПравилоОбмена <> Источник.Ссылка.ПравилоОбмена
			И (Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККМOffline
			   ИЛИ Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток) Тогда
			
			ПланыОбмена.УдалитьРегистрациюИзменений(Источник.УзелИнформационнойБазы);
			
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
			|	КодыТоваровПодключаемогоОборудованияOffline.Код           КАК Код,
			|	&УзелИнформационнойБазы                                   КАК УзелИнформационнойБазы
			|ИЗ
			|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
			|ГДЕ
			|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = &ПравилоОбмена");
			
			Запрос.УстановитьПараметр("ПравилоОбмена", Источник.ПравилоОбмена);
			Запрос.УстановитьПараметр("УзелИнформационнойБазы", Источник.УзелИнформационнойБазы);
			
		Иначе
			Возврат;
		КонецЕсли;
		
	Иначе
		Возврат;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Значение",             Источник.Ссылка);
	Запрос.УстановитьПараметр("ЗначениеНаименование", Источник.Наименование);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Набор = РегистрыСведений.КодыТоваровПодключаемогоОборудованияOffline.СоздатьНаборЗаписей();
	Пока Выборка.Следующий() Цикл
		
		Набор.Отбор.ПравилоОбмена.Значение = Выборка.ПравилоОбмена;
		Набор.Отбор.ПравилоОбмена.Использование = Истина;
		
		Набор.Отбор.Код.Значение = Выборка.Код;
		Набор.Отбор.Код.Использование = Истина;
		
		ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Набор);
	
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗарегистрироватьИзмененияДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТипИсточника = ТипЗнч(Источник);
	Если ТипИсточника = Тип("ДокументОбъект.УстановкаЦенНоменклатуры") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.УстановкаЦенНоменклатуры.Товары КАК УстановкаЦенНоменклатурыТовары
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = УстановкаЦенНоменклатурыТовары.Номенклатура
		|			И КодыТоваровПодключаемогоОборудованияOffline.Характеристика = УстановкаЦенНоменклатурыТовары.Характеристика
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И УстановкаЦенНоменклатурыТовары.Ссылка = &Значение");
	
		Запрос.УстановитьПараметр("Значение", Источник.Ссылка);
		
	Иначе
		Возврат;
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Набор = РегистрыСведений.КодыТоваровПодключаемогоОборудованияOffline.СоздатьНаборЗаписей();
	Пока Выборка.Следующий() Цикл
		
		Набор.Отбор.ПравилоОбмена.Значение = Выборка.ПравилоОбмена;
		Набор.Отбор.ПравилоОбмена.Использование = Истина;
		
		Набор.Отбор.Код.Значение = Выборка.Код;
		Набор.Отбор.Код.Использование = Истина;
		
		ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Набор);
	
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗарегистрироватьИзмененияРегистраСведений(Источник, Отказ, Замещение) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТипИсточника = ТипЗнч(Источник);
	Если ТипИсточника = Тип("РегистрСведенийНаборЗаписей.ШтрихкодыНоменклатуры") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена КАК ПравилоОбмена,
		|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
		|	ПодключаемоеОборудование.УзелИнформационнойБазы КАК УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.ПравилоОбмена = ПодключаемоеОборудование.ПравилоОбмена
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
		|		ПО КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = ШтрихкодыНоменклатуры.Номенклатура
		|			И КодыТоваровПодключаемогоОборудованияOffline.Характеристика = ШтрихкодыНоменклатуры.Характеристика
		|			И КодыТоваровПодключаемогоОборудованияOffline.Упаковка = ШтрихкодыНоменклатуры.Упаковка
		|ГДЕ
		|	КодыТоваровПодключаемогоОборудованияOffline.Используется
		|	И ПодключаемоеОборудование.УзелИнформационнойБазы <> ЗНАЧЕНИЕ(ПланОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка)
		|	И ШтрихкодыНоменклатуры.Штрихкод = &Значение");
		
		Запрос.УстановитьПараметр("Значение", Источник.Отбор.Штрихкод.Значение);
		
	Иначе
		Возврат;
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Набор = РегистрыСведений.КодыТоваровПодключаемогоОборудованияOffline.СоздатьНаборЗаписей();
	Пока Выборка.Следующий() Цикл
		
		Набор.Отбор.ПравилоОбмена.Значение = Выборка.ПравилоОбмена;
		Набор.Отбор.ПравилоОбмена.Использование = Истина;
		
		Набор.Отбор.Код.Значение = Выборка.Код;
		Набор.Отбор.Код.Использование = Истина;
		
		ПланыОбмена.ЗарегистрироватьИзменения(Выборка.УзелИнформационнойБазы, Набор);
	
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьУзелОбменаСПодключаемымОборудованиемOffline(Источник, Отказ) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Источник.УзелИнформационнойБазы)
		И (Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККМOffline
		ИЛИ Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток) Тогда
		Источник.УзелИнформационнойБазы = МенеджерОборудованияВызовСервераПереопределяемый.ПолучитьУзелРИБ(Источник);
	КонецЕсли;
	
	Источник.ДополнительныеСвойства.Вставить("ИзмененоПравилоОбмена", Источник.ПравилоОбмена <> Источник.Ссылка.ПравилоОбмена);
	
КонецПроцедуры

Процедура ОчиститьУзелОбменаСПодключаемымОборудованиемOffline(Источник, ОбъектКопирования) Экспорт
	
	Источник.УзелИнформационнойБазы = ПланыОбмена.ОбменСПодключаемымОборудованиемOffline.ПустаяСсылка();
	
КонецПроцедуры

Процедура ЗарегистрироватьИзмененияПриСменеПравилаОбменаПодключаемогоОборудования(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если (Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККМOffline
		ИЛИ Источник.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток)
		И Источник.ДополнительныеСвойства.ИзмененоПравилоОбмена Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		ПланыОбмена.ЗарегистрироватьИзменения(Источник.УзелИнформационнойБазы, Метаданные.РегистрыСведений.КодыТоваровПодключаемогоОборудованияOffline);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
