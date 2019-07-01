
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд создания на основании.
//
// Параметры:
// 		КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	Документы.ИзменениеПараметровНМА.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	//++ НЕ УТКА
	Документы.ПринятиеКУчетуНМАМеждународныйУчет.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	//-- НЕ УТКА
	
КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.ПринятиеКУчетуНМА) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.ПринятиеКУчетуНМА.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.ПринятиеКУчетуНМА);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт
	
	ИсточникиДанных = Новый Соответствие;
	
	Возврат ИсточникиДанных;
	
КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	
	
	ПервоначальныеСведенияНМАБухгалтерскийУчетУКР(ТекстыЗапроса, Регистры);
	ПервоначальныеСведенияНМАНалоговыйУчетУКР(ТекстыЗапроса, Регистры);
	СостоянияНМАОрганизаций(ТекстыЗапроса, Регистры);
	СпособыОтраженияРасходовПоАмортизацииНМАБухгалтерскийУчет(ТекстыЗапроса, Регистры);
	СчетаБухгалтерскогоУчетаНМА(ТекстыЗапроса, Регистры);
	ОтражениеДокументовВРеглУчете(ТекстыЗапроса, Регистры);
	
	МестонахождениеНМАБухгалтерскийУчет(ТекстыЗапроса, Регистры);
	
	ПроведениеСервер.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Ложь, Ложь, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.Дата,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.Подразделение,
	|	ДанныеДокумента.МОЛ КАК МОЛ,
	|	ДанныеДокумента.НалоговоеНазначение КАК НалоговоеНазначение,
	|	ДанныеДокумента.НалоговаяГруппаОС 	КАК НалоговаяГруппаОС,
	|	ДанныеДокумента.СпособНачисленияАмортизацииНУ,
	|	ДанныеДокумента.ЛиквидационнаяСтоимостьБУ,
	|	ДанныеДокумента.НематериальныйАктив,
	|	ДанныеДокумента.СчетУчета,
	|	ДанныеДокумента.СчетНачисленияАмортизации,
	|	ДанныеДокумента.СчетУчетаДооценокНМА,
	|	ДанныеДокумента.НачислятьАмортизациюБУ,
	|	ДанныеДокумента.СрокИспользованияБУ,
	|	ДанныеДокумента.СпособНачисленияАмортизацииБУ,
	|	ДанныеДокумента.ОбъемНаработкиБУ,
	|	ДанныеДокумента.НачислятьАмортизациюНУ,
	|	ДанныеДокумента.СрокИспользованияНУ,
	|	ДанныеДокумента.НаправлениеДеятельности,
	|	ДанныеДокумента.СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	Запрос.УстановитьПараметр("ГраницаКонецМесяца", Новый Граница(КонецМесяца(Реквизиты.Дата), ВидГраницы.Включая));
	
КонецПроцедуры

Процедура ДанныеДокументаИУчета(ТекстыЗапроса)
	
	ИмяТаблицы = "втДанныеДокументаИУчета";
	
	Если ПроведениеСервер.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Временная таблица втДанныеДокументаИУчета
	|"+
	"ВЫБРАТЬ
	|	ПринятиеКУчетуНМА.НематериальныйАктив КАК НематериальныйАктив,
	//|	ПринятиеКУчетуНМА.НалоговоеНазначение КАК НалоговоеНазначение,
	//|	ПринятиеКУчетуНМА.СпособНачисленияАмортизацииНУ КАК СпособНачисленияАмортизацииНУ,
	|	СУММА(ЕСТЬNULL(ДанныеУчета.СуммаОстатокДт, 0)) КАК ПервоначальнаяСтоимостьБУ,
	|	ВЫБОР
	|		КОГДА &НалоговоеНазначение = ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность)
	|			ТОГДА 0
	|		ИНАЧЕ СУММА(ЕСТЬNULL(ДанныеУчета.СуммаОстатокДт, 0))
	|	КОНЕЦ КАК ПервоначальнаяСтоимостьНУ,
    |	0 КАК ПервоначальнаяСтоимостьПР,
	|	0 КАК ПервоначальнаяСтоимостьВР,
	|	0 КАК СуммаЦелевыхСредств
	
	|ПОМЕСТИТЬ втДанныеДокументаИУчета
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК ПринятиеКУчетуНМА
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
	|				&ГраницаКонецМесяца,
	|				Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПриобретениеИзготовлениеНематериальныхАктивов)),
	|				,
	|				Организация = &Организация
	|					И Подразделение = &Подразделение
	|					И НаправлениеДеятельности = &НаправлениеДеятельности
	|					И Субконто1 = &НематериальныйАктив) КАК ДанныеУчета
	|		ПО ПринятиеКУчетуНМА.НематериальныйАктив = ДанныеУчета.Субконто1
	|ГДЕ
	|	ПринятиеКУчетуНМА.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПринятиеКУчетуНМА.НематериальныйАктив
	|	"+";";
	
	
	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы, Ложь);
	
КонецПроцедуры

Процедура ТаблицаНМА(ТекстыЗапроса)
	
	ИмяТаблицы = "ТаблицаНМА";
	
	Если ПроведениеСервер.ЕстьТаблицаЗапроса(ИмяТаблицы, ТекстыЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеДокументаИУчета(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Временная таблица ТаблицаНМА
	|"+
	"ВЫБРАТЬ
	|	втДанныеДокументаИУчета.НематериальныйАктив КАК НематериальныйАктив,
	|	втДанныеДокументаИУчета.ПервоначальнаяСтоимостьБУ КАК ПервоначальнаяСтоимостьБУ,
	|	втДанныеДокументаИУчета.ПервоначальнаяСтоимостьНУ КАК ПервоначальнаяСтоимостьНУ,
	//|	ВЫБОР
	//|		КОГДА втДанныеДокументаИУчета.НалоговоеНазначение = ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность)
	//|			ТОГДА 0
	//|		ИНАЧЕ втДанныеДокументаИУчета.ПервоначальнаяСтоимостьБУ
	//|	КОНЕЦ 
	//|		втДанныеДокументаИУчета.ПервоначальнаяСтоимостьБУ КАК ПервоначальнаяСтоимостьНУ,
	|	втДанныеДокументаИУчета.ПервоначальнаяСтоимостьПР КАК ПервоначальнаяСтоимостьПР,
	|	втДанныеДокументаИУчета.ПервоначальнаяСтоимостьВР КАК ПервоначальнаяСтоимостьВР,
	|	втДанныеДокументаИУчета.СуммаЦелевыхСредств КАК СуммаЦелевыхСредств
	|ПОМЕСТИТЬ ТаблицаНМА
	|ИЗ
	|	втДанныеДокументаИУчета КАК втДанныеДокументаИУчета"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяТаблицы, Ложь);
	
КонецПроцедуры




Процедура ПервоначальныеСведенияНМАБухгалтерскийУчетУКР(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПервоначальныеСведенияНМАБухгалтерскийУчет";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаНМА(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица ПервоначальныеСведенияНМАБухгалтерскийУчет
	|"+
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Дата КАК Период,
	|	
	|	ТаблицаНМА.НематериальныйАктив КАК НематериальныйАктив,
	|	
	|	&Организация КАК Организация,
	|	ТаблицаНМА.ПервоначальнаяСтоимостьБУ КАК ПервоначальнаяСтоимость,
	|	&НачислятьАмортизациюБУ КАК НачислятьАмортизацию,
	|	&СпособНачисленияАмортизацииБУ КАК СпособНачисленияАмортизации,
	|	&СрокИспользованияБУ КАК СрокПолезногоИспользования,
	|	&ОбъемНаработкиБУ КАК ОбъемПродукцииРаботДляВычисленияАмортизации,
	|	&ЛиквидационнаяСтоимостьБУ КАК ЛиквидационнаяСтоимость
	|ИЗ
	|	ТаблицаНМА КАК ТаблицаНМА"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры


Процедура ПервоначальныеСведенияНМАНалоговыйУчетУКР(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПервоначальныеСведенияНМАНалоговыйУчет";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаНМА(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица ПервоначальныеСведенияНМАНалоговыйУчет
	|"+
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Дата КАК Период,
	|	
	|	ТаблицаНМА.НематериальныйАктив КАК НематериальныйАктив,
	|	ВЫБОР
	|		КОГДА НЕ &СпособНачисленияАмортизацииНУ = 
	|				ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность) ТОГДА
	|	            	&СпособНачисленияАмортизацииНУ
	|       ИНАЧЕ
	|          ВЫБОР
	|				КОГДА &СпособНачисленияАмортизацииБУ = ЗНАЧЕНИЕ(Перечисление.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции) ТОГДА
	|					ЗНАЧЕНИЕ(Перечисление.СпособыНачисленияАмортизацииНМА.Линейный)
	|               ИНАЧЕ
	|                   &СпособНачисленияАмортизацииБУ
	|               КОНЕЦ
	|       КОНЕЦ КАК СпособНачисленияАмортизацииНУ,
	|
	|	&НалоговаяГруппаОС 			   КАК НалоговаяГруппаОС,
	|	&НалоговоеНазначение           КАК НалоговоеНазначение,
	|
	|	&НачислятьАмортизациюНУ КАК НачислятьАмортизацию,
	|	&Организация КАК Организация,
	|	ТаблицаНМА.ПервоначальнаяСтоимостьНУ КАК ПервоначальнаяСтоимостьНУ,
	|	ВЫБОР
	|		КОГДА НЕ &СпособНачисленияАмортизацииНУ = 
	|			ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность) ТОГДА
	|	        &СрокИспользованияНУ
	|       ИНАЧЕ
	|          &СрокИспользованияБУ
	|       КОНЕЦ КАК СрокПолезногоИспользования
	|ИЗ
	|	ТаблицаНМА КАК ТаблицаНМА"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

Процедура СостоянияНМАОрганизаций(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СостоянияНМАОрганизаций";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаНМА(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица СостоянияНМАОрганизаций
	|"+
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Дата КАК Период,
	|	
	|	&Организация КАК Организация,
	|	ТаблицаНМА.НематериальныйАктив КАК НематериальныйАктив,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.ПринятКУчету) КАК Состояние
	|ИЗ
	|	ТаблицаНМА КАК ТаблицаНМА"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

Процедура МестонахождениеНМАБухгалтерскийУчет(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "МестонахождениеНМАБухгалтерскийУчет";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаНМА(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица МестонахождениеНМАБухгалтерскийУчет
	|"+
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Дата КАК Период,
	|	
	|	&Организация КАК Организация,
	|	ТаблицаНМА.НематериальныйАктив КАК НематериальныйАктив,
	|	
	|	&Подразделение КАК Местонахождение,
	|	&МОЛ КАК МОЛ
	|ИЗ
	|	ТаблицаНМА КАК ТаблицаНМА"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

Процедура СпособыОтраженияРасходовПоАмортизацииНМАБухгалтерскийУчет(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СпособыОтраженияРасходовПоАмортизацииНМАБухгалтерскийУчет";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаНМА(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица СпособыОтраженияРасходовПоАмортизацииНМАБухгалтерскийУчет
	|"+
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Дата КАК Период,
	|	
	|	&Организация КАК Организация,
	|	ТаблицаНМА.НематериальныйАктив КАК НематериальныйАктив,
	|	
	|	&СтатьяРасходов КАК СтатьяРасходов,
	|	&АналитикаРасходов КАК АналитикаРасходов
	|	
	|ИЗ
	|	ТаблицаНМА КАК ТаблицаНМА"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

Процедура СчетаБухгалтерскогоУчетаНМА(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СчетаБухгалтерскогоУчетаНМА";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаНМА(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица СчетаБухгалтерскогоУчетаНМА
	|"+
	"ВЫБРАТЬ
	|	&Ссылка КАК Регистратор,
	|	&Дата КАК Период,
	|	
	|	&Организация КАК Организация,
	|	ТаблицаНМА.НематериальныйАктив КАК НематериальныйАктив,
	|	
	|	&СчетУчета КАК СчетУчета,
	|	&СчетУчетаДооценокНМА КАК СчетУчетаДооценокНМА,
	|	&СчетНачисленияАмортизации КАК СчетНачисленияАмортизации
	|	
	|ИЗ
	|	ТаблицаНМА КАК ТаблицаНМА"+";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры

Процедура ОтражениеДокументовВРеглУчете(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОтражениеДокументовВРеглУчете";
	
	Если Не ПроведениеСервер.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаНМА(ТекстыЗапроса);
	
	Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// Таблица ОтражениеДокументовВРеглУчете
	|" +
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	НАЧАЛОПЕРИОДА(&Период, ДЕНЬ) КАК ДатаОтражения,
	|	
	|	&Организация КАК Организация,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияДокументовВРеглУчете.КОтражениюВРеглУчете) КАК Статус" + ";";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра, Истина);
	
КонецПроцедуры


#КонецОбласти

#Область ПроведениеРегламентированныйУчет

Функция ТекстОтраженияВРеглУчетеУКР() Экспорт
	
	Возврат ПринятиеКУчетуУКР(); 
	
КонецФункции

Функция ПринятиеКУчетуУКР()
	
	Возврат "
	|////////////////////////////////////////////////////////////////////////////////
	|// Принятие к учету  (Дт СчетУчета:: Кт СчетаКапитальныхЗатрат)
	|
	|ВЫБРАТЬ
	|	
	|	втДанныеДокумента.Ссылка КАК Ссылка,
	|	втДанныеДокумента.Дата КАК Период,
	|	втДанныеДокумента.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|	
	|	втДанныеСчетаКапитализации.СуммаБУ КАК Сумма,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|	
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	втДанныеДокумента.Подразделение КАК ПодразделениеДт,
	|	втДанныеДокумента.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|втДанныеДокумента.НалоговоеНазначение КАК НалоговоеНазначениеДт,
	|	
	|	втДанныеДокумента.СчетУчета КАК СчетДт,
	|	
	|	втДанныеДокумента.НематериальныйАктив КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	ВЫБОР
	|		КОГДА втДанныеДокумента.НалоговоеНазначение = ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.НДС_НеоблагаемаяНеХозДеятельность)
	|			ТОГДА 0
	|		ИНАЧЕ втДанныеСчетаКапитализации.СуммаБУ
	|	КОНЕЦ КАК СуммаНУДт,
	|	втДанныеСчетаКапитализации.СуммаПР КАК СуммаПРДт,
	|	втДанныеСчетаКапитализации.СуммаВР КАК СуммаВРДт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	втДанныеДокумента.Подразделение КАК ПодразделениеКт,
	|	втДанныеДокумента.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.ПустаяСсылка) КАК НалоговоеНазначениеКт,
	|	
	|	втДанныеСчетаКапитализации.Счет КАК СчетКт,
	|	
	|	втДанныеДокумента.НематериальныйАктив КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	втДанныеСчетаКапитализации.СуммаНУ КАК СуммаНУКт,
	|	втДанныеСчетаКапитализации.СуммаПР КАК СуммаПРКт,
	|	втДанныеСчетаКапитализации.СуммаВР КАК СуммаВРКт,
	|	""Принятие к учету НМА"" КАК Содержание
	|ИЗ
	|	втДанныеДокумента КАК втДанныеДокумента
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ втДанныеСчетаКапитализации
	|	ПО втДанныеДокумента.НематериальныйАктив = втДанныеСчетаКапитализации.НематериальныйАктив
	|";
	
КонецФункции

Функция ВременнаяТаблицаДанныеДокументаУКР()
	
	Возврат
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.Дата КАК Дата,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.Подразделение КАК Подразделение,
	|	ТаблицаДокумента.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ТаблицаДокумента.НематериальныйАктив КАК НематериальныйАктив,
	|	ТаблицаДокумента.СчетУчета,
	|	ТаблицаДокумента.СчетНачисленияАмортизации,
	|	ТаблицаДокумента.СтатьяРасходов,
	|	ТаблицаДокумента.АналитикаРасходов,
	|	ТаблицаДокумента.НалоговоеНазначение КАК НалоговоеНазначение
	|
	|ПОМЕСТИТЬ втДанныеДокумента
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаОрганизаций.СрезПоследних(
	|				&Дата,
	|				Организация В
	|					(ВЫБРАТЬ
	|						Т.Организация
	|					ИЗ
	|						Документ.ПринятиеКУчетуНМА КАК Т
	|					ГДЕ
	|						Т.Ссылка = &Ссылка)) КАК УчетнаяПолитикаОрганизаций
	|		ПО ТаблицаДокумента.Организация = УчетнаяПолитикаОрганизаций.Организация
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка";
	
КонецФункции

Функция ВременнаяТаблицаОстаткиСчетаКапитализацииУКР()
	Возврат
	"ВЫБРАТЬ
	|	ДанныеУчета.Счет КАК Счет,
	|	ДанныеУчета.Субконто1 КАК НематериальныйАктив,
	|	СУММА(ДанныеУчета.СуммаОборот) КАК СуммаБУ,
	|	СУММА(ДанныеУчета.СуммаНУОборот) КАК СуммаНУ,
	|	СУММА(ДанныеУчета.СуммаПРОборот) КАК СуммаПР,
	|	СУММА(ДанныеУчета.СуммаВРОборот) КАК СуммаВР
	|ПОМЕСТИТЬ втОстатки
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(
	|			,
	|			&ГраницаМесяцОкончание,
	|			Регистратор,
	|			Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПриобретениеИзготовлениеНематериальныхАктивов)),
	|			,
	|			(Организация, Подразделение, НаправлениеДеятельности, Субконто1) В
	|				(ВЫБРАТЬ
	|					Т.Организация,
	|					Т.Подразделение,
	|					Т.НаправлениеДеятельности,
	|					Т.НематериальныйАктив
	|				ИЗ
	|					втДанныеДокумента КАК Т),
	|			,
	|			) КАК ДанныеУчета
	|ГДЕ
	|	ДанныеУчета.Регистратор <> &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеУчета.Субконто1,
	|	ДанныеУчета.Счет
	|;
	|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втОстатки.Счет КАК Счет,
	|	втОстатки.НематериальныйАктив,
	|	втОстатки.СуммаБУ  КАК СуммаБУ,
	|	втОстатки.СуммаНУ  КАК СуммаНУ,
	|	втОстатки.СуммаПР  КАК СуммаПР,
	|	втОстатки.СуммаВР  КАК СуммаВР

	|ПОМЕСТИТЬ втДанныеСчетаКапитализации
	|ИЗ
	|	втОстатки КАК втОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДанныеСчетаКапитализации.НематериальныйАктив,
	|	СУММА(втДанныеСчетаКапитализации.СуммаБУ) КАК СуммаБУ,
	|	СУММА(втДанныеСчетаКапитализации.СуммаНУ) КАК СуммаНУ,
	|	СУММА(втДанныеСчетаКапитализации.СуммаПР) КАК СуммаПР,
	|	СУММА(втДанныеСчетаКапитализации.СуммаВР) КАК СуммаВР
	|ПОМЕСТИТЬ втДанныеСчетаКапитализацииСгруппированные
	|ИЗ
	|	втДанныеСчетаКапитализации КАК втДанныеСчетаКапитализации
	|
	|СГРУППИРОВАТЬ ПО
	|	втДанныеСчетаКапитализации.НематериальныйАктив
	|";
КонецФункции

Функция ТекстЗапросаВТОтраженияВРеглУчетеУКР() Экспорт
	Разделитель = Символы.ПС + ";" + Символы.ПС;
	
	Возврат ВременнаяТаблицаДанныеДокументаУКР() + Разделитель
		+ ВременнаяТаблицаОстаткиСчетаКапитализацииУКР() + Разделитель;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// НА-1
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "НА1";
	КомандаПечати.Представление = НСтр("ru='Форма НА-1';uk='Форма НА-1'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 10;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;

	// Проверяем, нужно ли для макета СчетЗаказа формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "НА1") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		ИмяМакета = "";
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "НА1",
			НСтр("ru='Форма НА-1';uk='Форма НА-1'"), ПечатьНА1(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета),, ИмяМакета);
	КонецЕсли;

	
КонецПроцедуры


// Функция формирует табличный документ с типовой печатной формой НА-1
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьНА1(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета)
	
	Перем СписокСчетовКт;
	Перем ТЗСчетаКт;
	Перем ТЗПервоначальнаяСтоимость;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент   = Новый ТабличныйДокумент();
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПринятиеКУчетуНМА_НА1";
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПринятиеКУчетуНМА.ПФ_MXL_UK_НА1");
	
	ПервыйДокумент = Истина;
	
	ТЗСчетаКт = Новый ТаблицаЗначений;
	
	ТЗСчетаКт.Колонки.Добавить("ДокументПринятиеКУчетуНМА",Новый ОписаниеТипов("ДокументСсылка.ПринятиеКУчетуНМА"));
	ТЗСчетаКт.Колонки.Добавить("СписокСчетовКт",Новый ОписаниеТипов("Строка"));
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ХозрасчетныйДвиженияССубконто.Регистратор КАК Документ.ПринятиеКУчетуНМА) КАК Регистратор,
	|	ХозрасчетныйДвиженияССубконто.СчетКт КАК СчетКт
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(
	|			,
	|			,
	|			Активность
	|				И ВЫРАЗИТЬ(Регистратор КАК Документ.ПринятиеКУчетуНМА) В (&МассивОбъектов),
	|			,
	|			) КАК ХозрасчетныйДвиженияССубконто
	|ИТОГИ ПО
	|	Регистратор";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаРегистратор = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаРегистратор.Следующий() Цикл
		// Вставить обработку выборки ВыборкаРегистратор
		СписокСчетовКт = "";
		
		ВыборкаДетальныеЗаписи = ВыборкаРегистратор.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			СписокСчетовКт = СписокСчетовКт+?(СписокСчетовКт = "",ВыборкаДетальныеЗаписи.СчетКт,", "+ВыборкаДетальныеЗаписи.СчетКт);
		КонецЦикла;
		
		НоваяСтрока = ТЗСчетаКт.Добавить();
		НоваяСтрока.ДокументПринятиеКУчетуНМА = ВыборкаРегистратор.Регистратор;
		НоваяСтрока.СписокСчетовКт 			  = СписокСчетовКт;
		
	КонецЦикла;
	
	ТЗПервоначальнаяСтоимость = Новый ТаблицаЗначений;
	
	ТЗПервоначальнаяСтоимость.Колонки.Добавить("ДокументПринятиеКУчетуНМА",Новый ОписаниеТипов("ДокументСсылка.ПринятиеКУчетуНМА"));
	ТЗПервоначальнаяСтоимость.Колонки.Добавить("НематериальныйАктив",Новый ОписаниеТипов("СправочникСсылка.НематериальныеАктивы"));
	ТЗПервоначальнаяСтоимость.Колонки.Добавить("ПервоначальнаяСтоимость",Новый ОписаниеТипов("Число"));
	
	Для Каждого Ссылка Из МассивОбъектов Цикл
		
		Отбор = Новый Структура;
		Отбор.Вставить("НематериальныйАктив",Ссылка.НематериальныйАктив);
		
		ПервоначальныеСведенияНМА = РегистрыСведений.ПервоначальныеСведенияНМАБухгалтерскийУчет.ПолучитьПоследнее(Новый Граница(Ссылка.МоментВремени(),ВидГраницы.Включая),Отбор);
		
		НоваяСтрокаПервоначальнаяСтоимость = ТЗПервоначальнаяСтоимость.Добавить();
		НоваяСтрокаПервоначальнаяСтоимость.ДокументПринятиеКУчетуНМА = Ссылка;
		НоваяСтрокаПервоначальнаяСтоимость.НематериальныйАктив 	   	 = Ссылка.НематериальныйАктив;
		НоваяСтрокаПервоначальнаяСтоимость.ПервоначальнаяСтоимость	 = ПервоначальныеСведенияНМА.ПервоначальнаяСтоимость;
		
	КонецЦикла; 
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов" 			 , МассивОбъектов);
	Запрос.УстановитьПараметр("ТЗСчетаКт" 				 , ТЗСчетаКт);
	Запрос.УстановитьПараметр("ТЗПервоначальнаяСтоимость", ТЗПервоначальнаяСтоимость);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТЗСчетаКт.ДокументПринятиеКУчетуНМА КАК ДокументПринятиеКУчетуНМА,
	|	ТЗСчетаКт.СписокСчетовКт КАК СчетУчетаБУВнеоборотногоАктива
	|ПОМЕСТИТЬ ТЗСчетаКт
	|ИЗ
	|	&ТЗСчетаКт КАК ТЗСчетаКт
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ДокументПринятиеКУчетуНМА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЗПервоначальнаяСтоимость.ДокументПринятиеКУчетуНМА КАК ДокументПринятиеКУчетуНМА,
	|	ТЗПервоначальнаяСтоимость.НематериальныйАктив КАК НематериальныйАктив,
	|	ТЗПервоначальнаяСтоимость.ПервоначальнаяСтоимость
	|ПОМЕСТИТЬ ТЗПервоначальнаяСтоимость
	|ИЗ
	|	&ТЗПервоначальнаяСтоимость КАК ТЗПервоначальнаяСтоимость
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ДокументПринятиеКУчетуНМА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка КАК Ссылка,
	|	ДанныеДокументов.Организация КАК Организация,
	|	ДанныеДокументов.Организация.НаименованиеПолное КАК НаименованиеПолноеОрганизации,
	|	ДанныеДокументов.Организация.КодПоЕДРПОУ КАК КодПоЕДРПОУ,
	|	ДанныеДокументов.Дата КАК ДатаДок,
	|	ДанныеДокументов.Номер КАК НомерДок,
	|	ДанныеДокументов.НематериальныйАктив КАК НематериальныйАктив,
	|	ДанныеДокументов.НематериальныйАктив.НаименованиеПолное КАК НаименованиеПолное,
	|	ДанныеДокументов.НематериальныйАктив.ПрочиеСведения КАК ПрочиеСведения,
	|	ДанныеДокументов.СчетУчета КАК СчетУчетаБУ,
	|	ДанныеДокументов.СрокИспользованияБУ КАК СрокИспользования,
	|	ДанныеДокументов.ЛиквидационнаяСтоимостьБУ КАК ЛиквидационнаяСтоимость,
	|	ДанныеДокументов.МОЛ
	|ПОМЕСТИТЬ ДанныеДокументов
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК ДанныеДокументов
	|ГДЕ
	|	ДанныеДокументов.Ссылка В(&МассивОбъектов)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка КАК Ссылка,
	|	ДанныеДокументов.Организация,
	|	ДанныеДокументов.НаименованиеПолноеОрганизации,
	|	ДанныеДокументов.КодПоЕДРПОУ,
	|	ДанныеДокументов.ДатаДок,
	|	ДанныеДокументов.НомерДок,
	|	ДанныеДокументов.НематериальныйАктив,
	|	ДанныеДокументов.НаименованиеПолное,
	|	ДанныеДокументов.ПрочиеСведения,
	|	ДанныеДокументов.СчетУчетаБУ,
	|	ДанныеДокументов.СрокИспользования,
	|	ДанныеДокументов.ЛиквидационнаяСтоимость,
	|	ТЗСчетаКт.СчетУчетаБУВнеоборотногоАктива,
	|	ТЗПервоначальнаяСтоимость.ПервоначальнаяСтоимость,
	|	ДанныеДокументов.МОЛ
	|ИЗ
	|	ДанныеДокументов КАК ДанныеДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТЗСчетаКт КАК ТЗСчетаКт
	|		ПО ДанныеДокументов.Ссылка = ТЗСчетаКт.ДокументПринятиеКУчетуНМА
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТЗПервоначальнаяСтоимость КАК ТЗПервоначальнаяСтоимость
	|		ПО ДанныеДокументов.Ссылка = ТЗПервоначальнаяСтоимость.ДокументПринятиеКУчетуНМА";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		// Обработка выборки ВыборкаСсылка
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		ОбластьМакета = Макет.ПолучитьОбласть("НА1");
		Параметры     = ОбластьМакета.Параметры;
		
		Если Выборка.СрокИспользования <> 0 Тогда
			
			Если Выборка.ПервоначальнаяСтоимость <> 0  Тогда
				Параметры.ГодичнаяСуммаАмортизации = 12 * (Выборка.ПервоначальнаяСтоимость 
				- Выборка.ЛиквидационнаяСтоимость)
				/ Выборка.СрокИспользования;
			Иначе 
				
				Параметры.ГодичнаяСуммаАмортизации = 0;
				
			КонецЕсли; 
			
		КонецЕсли;
		
		Параметры.Заполнить(Выборка);
		
		ВыборкаПоКомиссии = ОбщегоНазначенияБПВызовСервера.ПолучитьСведенияОКомиссии(Выборка.Ссылка);
        Параметры.Заполнить(ВыборкаПоКомиссии);
		ОсновныеСотрудникиФизическихЛицМОЛ = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(Выборка.МОЛ, Истина, Ссылка.Организация, Ссылка.Дата);
		Если ЗначениеЗаполнено(ОсновныеСотрудникиФизическихЛицМОЛ) Тогда
			Для каждого Строка Из ОсновныеСотрудникиФизическихЛицМОЛ Цикл
			    ДанныеФизЛицаПолучил = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Строка.Сотрудник, "Должность", Ссылка.Дата);			
			КонецЦикла;
			Для каждого СтрокаДанныеПолучил Из ДанныеФизЛицаПолучил Цикл			
				ОбластьМакета.Параметры.МОЛДолжность = СтрокаДанныеПолучил.Должность;
				ОбластьМакета.Параметры.МОЛФИО 			= СтрокаДанныеПолучил.ФизическоеЛицо;			
			КонецЦикла;
		КонецЕсли;
		
		Параметры.КодПоЕДРПОУ = Выборка.КодПоЕДРПОУ;
		
		ОтветственныеЛицаОрганизации = ОтветственныеЛицаСервер.ПолучитьОтветственныеЛицаОрганизации(Ссылка.Организация,Ссылка.Дата);
		Параметры.ФИОРук      = ОтветственныеЛицаОрганизации[Метаданные.Перечисления.ОтветственныеЛицаОрганизаций.ЗначенияПеречисления.Руководитель.Имя + "Наименование"];
		Параметры.ФИОБух      = ОтветственныеЛицаОрганизации[Метаданные.Перечисления.ОтветственныеЛицаОрганизаций.ЗначенияПеречисления.ГлавныйБухгалтер.Имя + "Наименование"];
		
		
		ТабДокумент.Вывести(ОбластьМакета);
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
		НомерСтрокиНачало, ОбъектыПечати, Ссылка);
	КонецЦикла;
	Возврат ТабДокумент;

КонецФункции // ПечатьНА1()

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Процедура ОбработчикОбновления_2_1_3_ОтметитьКОбработке(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Операция.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК Операция
	|ГДЕ
	|	Операция.ВариантПримененияЦелевогоФинансирования = ЗНАЧЕНИЕ(Перечисление.ВариантыПримененияЦелевогоФинансирования.ПустаяСсылка)";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработчикОбновления_2_1_3(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Документ.ПринятиеКУчетуНМА";
	
	ОбработаноОбъектов = 0;
	ПроблемныхОбъектов = 0;
	
	ЗначенияЗаполнения = Новый Структура("ВариантПримененияЦелевогоФинансирования", Перечисления.ВариантыПримененияЦелевогоФинансирования.НеИспользуется);
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Документ.ПринятиеКУчетуНМА");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			Блокировка.Заблокировать();
		Исключение
			ОтменитьТранзакцию();
			Продолжить;;
		КонецПопытки;
		
		ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ЗаполнитьЗначенияСвойств(ДокументОбъект, ЗначенияЗаполнения);
		
		ОбработаноОбъектов = ОбработаноОбъектов + 1;
		
		Попытка
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
		Исключение
			
			ОбработаноОбъектов = ОбработаноОбъектов - 1;
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = НСтр("ru='Не удалось заполнить новые реквизиты значениями по умолчанию
                |в документе ""%1"" по причине:
                |%2'
                |;uk='Не вдалося заповнити нові реквізити значеннями по умовчанню
                |в документі ""%1"" з причини:
                |%2'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				Выборка.Ссылка.Метаданные(),
				Выборка.Ссылка,
				ТекстСообщения);
			ОтменитьТранзакцию();
			Продолжить;;
			
		КонецПопытки;
		ЗафиксироватьТранзакцию();
		
	КонецЦикла;
	
	Если ОбработаноОбъектов = 0 И ПроблемныхОбъектов > 0 Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Не выполнено заполние новых реквизитов значениями по умолчанию для некоторых документов принятия к учету НМА (пропущены): %1';uk='Не виконано заповнення нових реквізитів значеннями по умовчанню для деяких документів прийняття до обліку НМА (пропущені): %1'"),
			ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
		
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли