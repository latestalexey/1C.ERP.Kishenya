#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УточняемыеДанные.Организация КАК Организация,
	|	УточняемыеДанные.Период КАК Период,
	|	УточняемыеДанные.ФормироватьРезервОтпусковБУ КАК ФормироватьРезервОтпусковБУ,
	|	УточняемыеДанные.МетодНачисленияРезерваОтпусков КАК МетодНачисленияРезерваОтпусков,
	|	УточняемыеДанные.НормативОтчисленийВРезервОтпусков КАК НормативОтчисленийВРезервОтпусков,
	|	УточняемыеДанные.ПредельнаяВеличинаОтчисленийВРезервОтпусков КАК ПредельнаяВеличинаОтчисленийВРезервОтпусков
	|ПОМЕСТИТЬ ВТДанныеДляУточнения
	|ИЗ
	|	&Данные КАК УточняемыеДанные";
	Запрос.УстановитьПараметр("Данные", ЭтотОбъект.Выгрузить());
	Запрос.Выполнить(); 
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УточняемыеДанные.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|		  ИЛИ УточняемыеДанные.Организация.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА УточняемыеДанные.ФормироватьРезервОтпусковБУ
	|		ИНАЧЕ ЕСТЬNULL(Настройки.ФормироватьРезервОтпусковБУ, ЛОЖЬ)
	|	КОНЕЦ КАК ФормироватьРезервОтпусковБУ,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|		  ИЛИ УточняемыеДанные.Организация.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА УточняемыеДанные.МетодНачисленияРезерваОтпусков
	|		ИНАЧЕ ЕСТЬNULL(Настройки.МетодНачисленияРезерваОтпусков, ЛОЖЬ)
	|	КОНЕЦ КАК МетодНачисленияРезерваОтпусков,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|		  ИЛИ УточняемыеДанные.Организация.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА УточняемыеДанные.НормативОтчисленийВРезервОтпусков
	|		ИНАЧЕ ЕСТЬNULL(Настройки.НормативОтчисленийВРезервОтпусков, ЛОЖЬ)
	|	КОНЕЦ КАК НормативОтчисленийВРезервОтпусков,
	|	ВЫБОР
	|		КОГДА УточняемыеДанные.Организация = УточняемыеДанные.Организация.ГоловнаяОрганизация
	|		  ИЛИ УточняемыеДанные.Организация.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА УточняемыеДанные.ПредельнаяВеличинаОтчисленийВРезервОтпусков
	|		ИНАЧЕ ЕСТЬNULL(Настройки.ПредельнаяВеличинаОтчисленийВРезервОтпусков, ЛОЖЬ)
	|	КОНЕЦ КАК ПредельнаяВеличинаОтчисленийВРезервОтпусков,
	|	УточняемыеДанные.Период КАК Период
	|ИЗ
	|	ВТДанныеДляУточнения КАК УточняемыеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиРасчетаРезервовОтпусков КАК Настройки
	|		ПО УточняемыеДанные.Организация.ГоловнаяОрганизация = Настройки.Организация
	|			И УточняемыеДанные.Период = Настройки.Период";
	
	ЭтотОбъект.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УточняемыеДанные.Организация КАК Организация,
	|	УточняемыеДанные.ФормироватьРезервОтпусковБУ КАК ФормироватьРезервОтпусковБУ,
	|	УточняемыеДанные.МетодНачисленияРезерваОтпусков КАК МетодНачисленияРезерваОтпусков,
	|	УточняемыеДанные.НормативОтчисленийВРезервОтпусков КАК НормативОтчисленийВРезервОтпусков,
	|	УточняемыеДанные.ПредельнаяВеличинаОтчисленийВРезервОтпусков КАК ПредельнаяВеличинаОтчисленийВРезервОтпусков,
	|	УточняемыеДанные.Период КАК Период
	|ПОМЕСТИТЬ ВТНовыеДанные
	|ИЗ
	|	&Данные КАК УточняемыеДанные";
	Запрос.УстановитьПараметр("Данные", ЭтотОбъект.Выгрузить());
	Запрос.Выполнить(); 
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Организации.Ссылка КАК Организация,
	|	НовыеДанные.ФормироватьРезервОтпусковБУ КАК ФормироватьРезервОтпусковБУ,
	|	НовыеДанные.МетодНачисленияРезерваОтпусков КАК МетодНачисленияРезерваОтпусков,
	|	НовыеДанные.НормативОтчисленийВРезервОтпусков КАК НормативОтчисленийВРезервОтпусков,
	|	НовыеДанные.ПредельнаяВеличинаОтчисленийВРезервОтпусков КАК ПредельнаяВеличинаОтчисленийВРезервОтпусков,
	|	НовыеДанные.Период КАК Период
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНовыеДанные КАК НовыеДанные
	|		ПО Организации.Ссылка.ГоловнаяОрганизация = НовыеДанные.Организация
	|ГДЕ
	|	Организации.Ссылка <> Организации.ГоловнаяОрганизация
	|	И Организации.ГоловнаяОрганизация В
	|			(ВЫБРАТЬ
	|				Организации.Организация
	|			ИЗ
	|				ВТНовыеДанные КАК Организации
	|			ГДЕ
	|				Организации.Организация = Организации.Организация.ГоловнаяОрганизация)";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
	
		НаборЗаписей = РегистрыСведений.НастройкиРасчетаРезервовОтпусков.СоздатьНаборЗаписей();
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.Отбор.Организация.Установить(Выборка.Организация);
		НаборЗаписей.Отбор.Период.Установить(Выборка.Период);
	    ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(),Выборка);
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли