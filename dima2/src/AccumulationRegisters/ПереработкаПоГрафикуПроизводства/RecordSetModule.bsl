#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	СформироватьТаблицуРаспоряжений();
	
	УстановитьБлокировкиДанных();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗафиксироватьВводЗаказаПереработчикуПоЭтапамПроизводства();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗафиксироватьВводЗаказаПереработчикуПоЭтапамПроизводства()
	
	Если НЕ ДополнительныеСвойства.ЭтоПереработка Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыНакопления.ПереработкаПоГрафикуПроизводства.ЗафиксироватьВводЗаказаПереработчикуПоЭтапамПроизводства(ДополнительныеСвойства.ТаблицаЭтаповГрафика);
	
КонецПроцедуры

Процедура СформироватьТаблицуРаспоряжений()
	
	ДополнительныеСвойства.Вставить("ЭтоПереработка",
		ТипЗнч(Отбор.Регистратор.Значение) = Тип("ДокументСсылка.ЗаказПереработчику"));
	
	Если НЕ ДополнительныеСвойства.ЭтоПереработка Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаЭтаповГрафика = ЭтотОбъект.Выгрузить(, "ЗаказНаПроизводство, КодСтрокиЭтапыГрафик");
	ТаблицаЭтаповГрафика.Колонки.ЗаказНаПроизводство.Имя = "Распоряжение";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.ЗаказНаПроизводство КАК Распоряжение,
	|	Таблица.КодСтрокиЭтапыГрафик КАК КодСтрокиЭтапыГрафик
	|ИЗ
	|	РегистрНакопления.ПереработкаПоГрафикуПроизводства КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			ЗаполнитьЗначенияСвойств(ТаблицаЭтаповГрафика.Добавить(), Выборка);
			
		КонецЦикла;
	
	КонецЕсли;
	
	ТаблицаЭтаповГрафика.Свернуть("Распоряжение, КодСтрокиЭтапыГрафик");
	
	ТаблицаРаспоряжений = ТаблицаЭтаповГрафика.Скопировать(, "Распоряжение");
	ТаблицаРаспоряжений.Свернуть("Распоряжение");

	ДополнительныеСвойства.Вставить("ТаблицаРаспоряжений", ТаблицаРаспоряжений);
	ДополнительныеСвойства.Вставить("ТаблицаЭтаповГрафика", ТаблицаЭтаповГрафика);

КонецПроцедуры

Процедура УстановитьБлокировкиДанных()
	
	Если НЕ ДополнительныеСвойства.ЭтоПереработка Тогда
		Возврат;
	КонецЕсли;
	
	Блокировка = Новый БлокировкаДанных;

	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ПереработкаПоГрафикуПроизводства");
	ЭлементБлокировки.Режим          = РежимБлокировкиДанных.Разделяемый;
	ЭлементБлокировки.ИсточникДанных = ДополнительныеСвойства.ТаблицаРаспоряжений;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ЗаказНаПроизводство", "Распоряжение");

	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ЭтапыПроизводства");
	ЭлементБлокировки.Режим          = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ДополнительныеСвойства.ТаблицаРаспоряжений;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Распоряжение", "Распоряжение");

	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ГрафикЭтаповПроизводства");
	ЭлементБлокировки.Режим          = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ДополнительныеСвойства.ТаблицаРаспоряжений;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Распоряжение", "Распоряжение");

	Блокировка.Заблокировать();

КонецПроцедуры

#КонецОбласти

#КонецЕсли